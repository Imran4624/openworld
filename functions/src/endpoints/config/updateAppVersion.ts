/*
// REQUEST
{
  "platform": "android", // or "ios"
  "latest": "1.2.3"
}

// RESPONSE (Success)
{
  "success": true,
  "message": "Updated android version to 1.2.3"
}

// RESPONSE (Error)
{
  "success": false,
  "error": "Missing required parameters."
}
*/

import {onRequest} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import cors from "cors";

const db = getFirestore();
const corsHandler = cors({
  origin: true,
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
});

export const updateAppVersion = onRequest({
  invoker: "public",
}, async (request, response) => {
  corsHandler(request, response, async () => {
    let platform: string | undefined;
    let latest: string | undefined;

    if (request.method === "POST") {
      const body = request.body;
      platform = body.platform;
      latest = body.latest;
    } else if (request.method === "GET") {
      platform = request.query.platform as string;
      latest = request.query.latest as string;
    } else {
      return response.status(405).send("Method Not Allowed");
    }

    if (!platform || !latest) {
      return response.status(400).send("Missing required parameters.");
    }

    const hardcodedValues = {
      minimum: process.env.APP_VERSION_MINIMUM,
      update_url: process.env.APP_VERSION_UPDATE_URL,
      release_notes: process.env.APP_VERSION_RELEASE_NOTES,
      is_update_required:
        process.env.APP_VERSION_UPDATE_REQUIRED,
      maintenance_mode: process.env.APP_VERSION_MAINTENANCE_MODE,
      maintenance_message:
        process.env.APP_VERSION_MAINTENANCE_MESSAGE,
      feature_flags: process.env.APP_VERSION_FEATURE_FLAGS,
    };

    const newConfig = {latest, ...hardcodedValues};

    try {
      await db.collection("app_config")
        .doc("app_version")
        .set({[platform]: newConfig}, {merge: true});

      logger.info(`Successfully updated ${platform} version to ${latest}`);
      return response.status(200)
        .send(`Updated ${platform} version to ${latest}`);
    } catch (error: any) {
      logger.error("Failed to update app version:", error);
      return response.status(500).
        send(`Error updating version: ${error.message}`);
    }
  });
});
