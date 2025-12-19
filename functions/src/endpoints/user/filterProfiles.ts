/*
// REQUEST
{
  "filters": {
    "minAge": 18,
    "maxAge": 35,
    "gender": "female",
    "location": {
      "latitude": 40.7128,
      "longitude": -74.0060,
      "radius": 50
    },
    "interests": ["music", "travel"],
    "currentUserId": "user123",
    "isAdmin": false
  },
  "limit": 50,
  "lastDocId": "last_doc_id_here",
  "excludeLikedMatchedProfiles": true
}

// RESPONSE (Success)
{
  "success": true,
  "data": {
    "profiles": [
      {
        "id": "profile123",
        "name": "John Doe",
        "age": 28,
        "gender": "male",
        "location": {
          "latitude": 40.7580,
          "longitude": -73.9855
        },
        "interests": ["music", "sports"],
        "photos": ["photo1.jpg", "photo2.jpg"],
        "bio": "Love music and traveling"
      }
    ],
    "hasMore": true,
    "lastDocId": "new_last_doc_id"
  }
}

// RESPONSE (Error)
{
  "success": false,
  "error": "Invalid filter parameters"
}
*/

import {onRequest} from "firebase-functions/v2/https";
import {getFirestore, Query, DocumentData} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import cors from "cors";

const db = getFirestore();
const corsHandler = cors({
  origin: true,
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
});

export const filterProfiles = onRequest({
  invoker: "public",
}, async (request, response) => {
  corsHandler(request, response, async () => {
    try {
      logger.info("Filter profiles function called", {structuredData: true});
      const filters = request.method === "POST" ?
        request.body.filters :
        JSON.parse(request.query.filters as string || "{}");
      const limit = parseInt(request.query.limit as string || "50", 10);
      const lastDocId = request.query.lastDocId as string;
      const currentUserId = request.query.currentUserId as string ||
        filters.currentUserId;
      const excludeLikedMatchedProfiles =
        request.query.excludeLikedMatchedProfiles === "true" ||
        request.body.excludeLikedMatchedProfiles === true;
      const isAdmin = filters.isAdmin === true;
      const selectedCompanyId = request.method === "POST" ?
        request.body.selectedCompanyId :
        request.query.selectedCompanyId as string;
      logger.info("Received filters:", filters);
      logger.info("Is Admin:", isAdmin);
      logger.info("Selected Company ID:", selectedCompanyId);
      logger.info("Exclude liked/matched profiles:",
        excludeLikedMatchedProfiles);

      const profilesCollection = db.collection("users");
      let baseQuery: Query<DocumentData> = profilesCollection;

      logger.info(`Filtering by state: ${filters.state || "active (default)"}`);
      if (filters.state === "reported") {
        baseQuery = baseQuery.where("reported", "==", true);
      } else if (filters.state === "active") {
        baseQuery = baseQuery.where("archived_at", "==", 0)
          .where("is_deleted", "==", false);
      } else if (filters.state === "archived") {
        baseQuery = baseQuery.where("archived_at", ">", 0)
          .where("is_deleted", "==", false);
      } else if (filters.state === "deleted") {
        baseQuery = baseQuery.where("is_deleted", "==", true);
      } else {
        baseQuery = baseQuery.where("archived_at", "==", 0)
          .where("is_deleted", "==", false);
      }

      const dynamicFields = filters.dynamicFields || {};

      for (const [field, filterValue] of Object.entries(dynamicFields)) {
        if (filterValue === undefined || filterValue === null ||
          (typeof filterValue === "string" && filterValue.trim() === "") ||
          (Array.isArray(filterValue) && filterValue.length === 0)) {
          continue;
        }

        try {
          if (typeof filterValue === "string" ||
              typeof filterValue === "number" ||
              typeof filterValue === "boolean") {
            const queryValue = filterValue;
            let fieldPath = "";
            if (field === "email") {
              fieldPath = "email";
            } else {
              fieldPath = `dynamicFields.${field}`;
            }
            baseQuery = baseQuery.where(fieldPath, "==", queryValue);
            logger.info(`Applied equality filter: ${fieldPath} == ${queryValue}`);
            continue;
          }

          if (Array.isArray(filterValue) && filterValue.length === 1) {
            const queryValue = filterValue[0];
            let fieldPath = "";
            if (field === "email") {
              fieldPath = "email";
            } else {
              fieldPath = `dynamicFields.${field}`;
            }
            baseQuery = baseQuery.where(fieldPath, "array-contains",
              queryValue);
            logger.info(`Applied array-contains filter: ${fieldPath} array-contains ${queryValue}`);
            continue;
          }

          if (typeof filterValue === "object" && filterValue !== null &&
              !Array.isArray(filterValue)) {
            const rangeValue = filterValue as {min?: number; max?: number};
            const fieldPath = field === "email" ? "email" :
              `dynamicFields.${field}`;
            if (rangeValue.min !== undefined && rangeValue.max !== undefined) {
              baseQuery = baseQuery
                .where(fieldPath, ">=", rangeValue.min)
                .where(fieldPath, "<=", rangeValue.max);
              logger.info(`Applied range filter: ${fieldPath} ` +
                `>= ${rangeValue.min} AND <= ${rangeValue.max}`);
              continue;
            } else if (rangeValue.min !== undefined) {
              baseQuery = baseQuery.where(fieldPath, ">=", rangeValue.min);
              logger.info(`Applied min filter: ${fieldPath} >= ${rangeValue.min}`);
              continue;
            } else if (rangeValue.max !== undefined) {
              baseQuery = baseQuery.where(fieldPath, "<=", rangeValue.max);
              logger.info(`Applied max filter: ${fieldPath} <= ${rangeValue.max}`);
              continue;
            }
          }

          logger.warn("Filter type not supported by Firestore " +
            `for ${field}:`, filterValue);
        } catch (error) {
          logger.warn("Could not apply Firestore filter " +
            `for ${field}: ${error}`);
        }
      }

      if (!isAdmin && filters.preferredGender &&
          filters.preferredGender !== "all" &&
          typeof filters.preferredGender === "string" &&
          !Object.prototype.hasOwnProperty.call(dynamicFields, "gender")) {
        try {
          baseQuery = baseQuery.where("dynamicFields.gender",
            "==", filters.preferredGender);
          logger.info("Applied gender preference filter for non-admin user: " +
            `${filters.preferredGender}`);
        } catch (error) {
          logger.warn(`Could not apply gender preference filter: ${error}`);
        }
      } else if (isAdmin) {
        logger.info("Skipping gender filter for admin user");
      }

      if (selectedCompanyId && typeof selectedCompanyId === "string" &&
          selectedCompanyId.trim() !== "") {
        logger.info("Applying company filter with ID:", selectedCompanyId);
        try {
          baseQuery = baseQuery.where("companyIds", "array-contains",
            selectedCompanyId);
          logger.info("✅ Successfully applied company filter: companyIds " +
            "array-contains " + selectedCompanyId);
        } catch (error) {
          logger.warn("Company filter failed - companyIds field may not exist:",
            error);
        }
      } else if (selectedCompanyId !== undefined) {
        logger.warn("⚠️ Selected company ID provided but empty/invalid:",
          selectedCompanyId, typeof selectedCompanyId);
      } else {
        logger.info("ℹ️ No company ID provided - showing all profiles");
      }

      if (lastDocId) {
        const lastDocRef = profilesCollection.doc(lastDocId);
        const lastDocSnapshot = await lastDocRef.get();
        if (lastDocSnapshot.exists) {
          baseQuery = baseQuery.startAfter(lastDocSnapshot);
        }
      }

      const excludedProfileIds: string[] = [];
      if (currentUserId) {
        excludedProfileIds.push(currentUserId);
        logger.info(`Always excluding current user: ${currentUserId}`);
      }
      if (excludeLikedMatchedProfiles && currentUserId) {
        logger.info(`Getting additional exclusions for user: ${currentUserId}`);
        try {
          const [matchesSnapshot, likesSnapshot, passesSnapshot] = await
          Promise.all([
            db.collection("users").doc(currentUserId).collection(
              "matches").get(),
            db.collection("users").doc(currentUserId).collection("likes").get(),
            db.collection("users").doc(currentUserId).collection(
              "passes").get(),
          ]);
          matchesSnapshot.forEach((doc) => excludedProfileIds.push(doc.id));
          likesSnapshot.forEach((doc) => excludedProfileIds.push(doc.id));
          passesSnapshot.forEach((doc) => excludedProfileIds.push(doc.id));
          logger.info(`Will exclude ${excludedProfileIds.length} profiles`);
        } catch (error) {
          logger.warn("Could not fetch exclusions:", error);
        }
      } else if (currentUserId) {
        logger.info(`Will exclude ${excludedProfileIds.length} profiles ` +
          "(current user only)");
      }

      baseQuery = baseQuery.limit(limit);

      logger.info(`Executing Firestore query with limit ${limit}`);
      const querySnapshot = await baseQuery.get();

      let profiles = querySnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      logger.info(`Fetched ${profiles.length} profiles from Firestore query`);

      if (excludedProfileIds.length > 0) {
        const beforeExclusion = profiles.length;
        profiles = profiles.filter((profile) =>
          !excludedProfileIds.includes(profile.id)
        );
        logger.info(`After exclusions: ${profiles.length} profiles ` +
          `(filtered out ${beforeExclusion - profiles.length})`);
      }

      const finalProfiles = profiles.slice(0, limit);

      const lastDocument = finalProfiles.length > 0 ?
        finalProfiles[finalProfiles.length - 1].id : null;

      logger.info(`Returned ${finalProfiles.length} profiles`);

      response.json({
        profiles: finalProfiles,
        lastDocument: lastDocument,
        totalCount: finalProfiles.length,
        returnedCount: finalProfiles.length,
        hasMore: finalProfiles.length === limit,
        excludedCount: excludedProfileIds.length,
      });
    } catch (error: any) {
      logger.error("Error in filterProfiles:", error);
      response.status(500).send({
        error: "Failed to filter profiles",
        details: error.message,
      });
    }
  });
});
