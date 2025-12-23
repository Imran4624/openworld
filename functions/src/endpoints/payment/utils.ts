import * as admin from "firebase-admin";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {SecretManagerServiceClient} from "@google-cloud/secret-manager";
import Stripe from "stripe";

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = getFirestore();
const secretManagerClient = new SecretManagerServiceClient();

export async function getSecret(name: string) {
  try {
    let projectId = process.env.GOOGLE_CLOUD_PROJECT ||
                   process.env.GCLOUD_PROJECT ||
                   process.env.GCP_PROJECT;

    if (!projectId && admin.apps.length > 0) {
      projectId = admin.app().options.projectId;
    }

    if (!projectId) {
      console.error("Project ID not found. Make sure GOOGLE_CLOUD_PROJECT is set.");
      throw new Error("Project ID not found");
    }

    // Construct the secret name
    const secretName = `projects/${projectId}/secrets/${name}/versions/latest`;

    console.log(`Fetching secret from Google Cloud Secret Manager: ${secretName}`);

    // Access the secret version
    const [version] = await secretManagerClient.accessSecretVersion({
      name: secretName,
    });

    // Extract the secret value
    const secretValue = version.payload?.data?.toString();

    if (!secretValue) {
      console.error(`Secret ${name} is empty or undefined`);
      throw new Error(`Secret ${name} is empty or undefined`);
    }

    console.log(`Successfully retrieved secret: ${name}`);
    return secretValue;
  } catch (error: any) {
    console.error(`Error fetching secret ${name} from Google Cloud Secret Manager:`, error.message);
    throw error;
  }
}

export async function initStripe() {
  // const key = await getSecret("STRIPE_SECRET");
  return new Stripe("sk_test_51SORA1IPMSTLVcCTgI1vf3kpp2jMhyuo2H6tB1RWXzp4s4SbZnuRDcsudwNKp9IkXh0tytu8CAnZ5bIQ9A6s94fp00Eka7RONR", {apiVersion: "2024-06-20"});
}

export async function useIdempotency(userId: string, operation: string) {
  const key = db.collection("dummy").doc().id;
  const ref = db.collection("users").doc(userId)
    .collection("idempotency").doc(key);

  await ref.set({
    operation,
    status: "pending",
    createdAt: FieldValue.serverTimestamp(),
  });

  return {idempotencyKey: key, ref};
}

export async function completeIdempotency(ref: FirebaseFirestore.DocumentReference, status = "completed") {
  await ref.update({
    status,
    updatedAt: FieldValue.serverTimestamp(),
  });
}
