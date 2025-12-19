/*
// REQUEST
{
  "userId": "user123",
  "confirmDelete": true
}

// RESPONSE (Success)
{
  "success": true,
  "message": "User account deleted successfully",
  "deletionStats": {
    "messagesDeleted": 45,
    "participantsDeleted": 12,
    "chatsMarkedDeleted": 8,
    "userDataDeleted": true,
    "authUserDeleted": true
  }
}

// RESPONSE (Error)
{
  "success": false,
  "error": "User deletion failed: Invalid user ID"
}
*/

import {onRequest} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import cors from "cors";
import * as admin from "firebase-admin";

const db = getFirestore();
const corsHandler = cors({
  origin: true,
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
});

async function measure<T>(label: string, fn: () => Promise<T>): Promise<T> {
  const start = Date.now();
  try {
    const result = await fn();
    const seconds = ((Date.now() - start) / 1000).toFixed(2);
    logger.info(`${label} completed in ${seconds}s`);
    return result;
  } catch (error) {
    const seconds = ((Date.now() - start) / 1000).toFixed(2);
    logger.error(`${label} failed after ${seconds}s`, error);
    throw error;
  }
}

async function cleanupChatMessages(userId: string) {
  const start = Date.now();
  const chatsQuery = db.collection("chats")
    .where("participantsIds", "array-contains", userId);

  const chatsSnapshot = await chatsQuery.get();
  let messagesDeleted = 0;
  let participantsSubcollectionDeleted = 0;
  let chatsMarkedDeleted = 0;

  for (const chatDoc of chatsSnapshot.docs) {
    const batch = db.batch();
    const chatRef = chatDoc.ref;
    const messagesQuery = chatRef.collection("messages")
      .where("senderId", "==", userId);
    const messagesSnapshot = await messagesQuery.get();
    messagesSnapshot.forEach((doc) => {
      batch.delete(doc.ref);
      messagesDeleted++;
    });
    const participantDocRef = chatRef.collection("participants").doc(userId);
    batch.delete(participantDocRef);
    participantsSubcollectionDeleted++;
    const currentIds = chatDoc.data().participantsIds || [];
    const updatedIds = currentIds.filter((id: string) => id !== userId);
    const participants = chatDoc.data().participants || [];
    const updatedParticipants = participants.filter((p: any) => p.userId !== userId);
    const shouldMarkDeleted = updatedIds.length === 1;
    const updateData: any = {
      participantsIds: updatedIds,
      participants: updatedParticipants,
    };
    if (shouldMarkDeleted) {
      updateData.is_deleted = true;
      chatsMarkedDeleted++;
    }
    batch.update(chatRef, updateData);
    await batch.commit();
  }
  logger.info([
    `Cleaned up ${chatsSnapshot.size} chats:`,
    `- Deleted messages ${messagesDeleted} messages (where senderId = ${userId})`,
    `- Removed ${participantsSubcollectionDeleted} participant subcollection docs`,
    `- Marked ${chatsMarkedDeleted} chats as deleted`,
    "- Updated participants array and IDs",
  ].join("\n"));
  const seconds = ((Date.now() - start) / 1000).toFixed(2);
  logger.info(`chats deletion completed in  ${seconds}s`);
}

async function removeUserFromProfileMaps(userId: string, collectionName: string) {
  const start = Date.now();
  const profileMaps = [
    "likesProfileMap",
    "likedMeProfileMap",
    "matchesProfileMap",
    "reportedBy",
  ];
  const usersSnapshot = await db.collection(collectionName).get();
  let batch = db.batch();
  let updatesCount = 0;
  let subcollectionsDeleted = 0;
  let operationCount = 0;

  const commitAndResetBatch = async () => {
    if (operationCount === 0) return;
    await batch.commit();
    batch = db.batch();
    operationCount = 0;
  };
  for (const userDoc of usersSnapshot.docs) {
    const data = userDoc.data();
    let needsUpdate = false;
    const updates: any = {};
    profileMaps.forEach((mapField) => {
      if (data[mapField] && data[mapField][userId]) {
        updates[`${mapField}.${userId}`] = admin.firestore.FieldValue.delete();
        needsUpdate = true;
      }
    });
    const subcollectionsToClean = ["likes", "matches", "reports"];
    for (const subcollection of subcollectionsToClean) {
      try {
        const docRef = userDoc.ref.collection(subcollection).doc(userId);
        batch.delete(docRef);
        operationCount++;
        subcollectionsDeleted++;
        if (operationCount >= 400) {
          await commitAndResetBatch();
        }
      } catch (error) {
        logger.error(`Error scheduling delete in ${subcollection} for ${userId}:`, error);
      }
    }
    if (needsUpdate) {
      batch.update(userDoc.ref, updates);
      operationCount++;
      updatesCount++;
      if (operationCount >= 400) {
        await commitAndResetBatch();
      }
    }
  }
  await commitAndResetBatch();
  logger.info(`Removed user references from ${updatesCount} profiles and deleted ${subcollectionsDeleted} subcollection documents`);
  const seconds = ((Date.now() - start) / 1000).toFixed(2);
  logger.info(`remove user from profile operations completed in ${seconds}s`);
}

export const deleteUserAccount = onRequest({timeoutSeconds: 540,
  memory: "1GiB", invoker: "public"}, async (request, response) => {
  corsHandler(request, response, async () => {
    try {
      const overallStart = Date.now();
      if (!request.headers.authorization) {
        response.status(401).json({error: "Unauthorized"});
        return;
      }
      const {userId, collectionName} = request.body;
      if (!userId || !collectionName) {
        response.status(400).json({
          error: "Both userId and collectionName are required",
        });
        return;
      }
      logger.info(`cloud function {deleteUserAccount} triggered for { ${userId}`);
      await measure("firestore user document deletion", async () => {
        await db.collection(collectionName).doc(userId).delete();
        logger.info(`Deleted ${userId} from ${collectionName}`);
      });
      await Promise.all([
        cleanupChatMessages(userId),
        removeUserFromProfileMaps(userId, collectionName),
      ]);
      await measure("firebaseAuth user deletion", async () => {
        await admin.auth().deleteUser(userId);
        logger.info(`Deleted ${userId} from Auth`);
      });
      const overallSeconds = ((Date.now() - overallStart) / 1000).toFixed(2);
      logger.info(`cloud function {deleteUserAccount} completed for ${userId} in ${overallSeconds}s`);
      response.json({
        success: true,
        message: `Deleted user ${userId} and all related data`,
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        logger.error("Deletion failed:", error.message);
        response.status(500).json({
          success: false,
          error: error.message,
        });
      }
    }
  });
});
