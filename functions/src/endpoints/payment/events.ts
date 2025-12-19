import {onRequest} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import cors from "cors";
import * as admin from "firebase-admin";
import {initStripe} from "./utils";

const db = getFirestore();
const corsHandler = cors({
  origin: true,
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
});

export const processPayment = onRequest({
  timeoutSeconds: 540,
  memory: "1GiB",
  invoker: "public",
}, async (request, response) => {
  corsHandler(request, response, async () => {
    try {
      if (request.method !== "POST") {
        return response.status(405).json({
          error: "Method Not Allowed",
          message: "Only POST requests are allowed",
        });
      }

      const {
        paymentType = "test",
        amount,
        currency = "gbp",
        eventId,
        eventName,
        userEmail,
        paymentMethodId,
        metadata = {},
      } = request.body;

      if (!amount || !eventId || !userEmail) {
        return response.status(400).json({
          error: "Bad Request",
          message: "Missing required fields: amount, eventId, userEmail",
        });
      }

      const stripe = await initStripe();
      let defaultPaymentMethod: string;

      if (paymentType === "production") {
        defaultPaymentMethod = "pm_card_visa";
      } else {
        defaultPaymentMethod = "pm_card_mastercard";
      }

      const amountInCents = Math.round(amount * 100);

      const finalPaymentMethodId = paymentMethodId || defaultPaymentMethod;

      const enhancedMetadata = {
        ...metadata,
        event_id: eventId,
        event_name: eventName,
        user_email: userEmail,
        payment_type: paymentType,
        processed_by: "firebase_function",
        processed_at: new Date().toISOString(),
      };

      logger.info(`Processing ${paymentType} payment`, {
        amount: amountInCents,
        currency,
        eventId,
        userEmail,
        paymentMethodId: finalPaymentMethodId,
      });

      const paymentIntent = await stripe.paymentIntents.create({
        amount: amountInCents,
        currency: currency.toLowerCase(),
        payment_method: finalPaymentMethodId,
        confirm: true,
        automatic_payment_methods: {
          enabled: true,
          allow_redirects: "never",
        },
        return_url: "https://dummyUrl.com",
        metadata: enhancedMetadata,
      });

      logger.info("Payment intent created successfully", {
        id: paymentIntent.id,
        status: paymentIntent.status,
        amount: paymentIntent.amount,
      });

      const paymentRecord = {
        id: paymentIntent.id,
        amount: amount,
        currency: currency.toUpperCase(),
        status: paymentIntent.status,
        paymentType,
        eventId,
        eventName,
        userEmail,
        paymentMethodId: finalPaymentMethodId,
        stripePaymentIntentId: paymentIntent.id,
        metadata: enhancedMetadata,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };

      await db.collection("payments").doc(paymentIntent.id).set(paymentRecord);

      return response.status(200).json({
        success: true,
        paymentId: paymentIntent.id,
        status: paymentIntent.status,
        amount: amount,
        currency: currency.toUpperCase(),
        eventId: eventId,
        eventName: eventName,
        userEmail: userEmail,
        createdAt: new Date().toISOString(),
      });
    } catch (error: any) {
      logger.error("Payment processing error:", error);
      return response.status(500).json({
        error: "Payment processing failed",
        message: error.message,
      });
    }
  });
});

export const getPaymentStatus = onRequest({
  timeoutSeconds: 30,
  memory: "512MiB",
  invoker: "public",
}, async (request, response) => {
  corsHandler(request, response, async () => {
    try {
      const paymentId = request.query.paymentId as string;

      if (!paymentId) {
        return response.status(400).json({
          error: "Bad Request",
          message: "Missing paymentId parameter",
        });
      }

      const paymentDoc = await db.collection("payments").doc(paymentId).get();

      if (!paymentDoc.exists) {
        return response.status(404).json({
          error: "Payment Not Found",
          message: `Payment with ID ${paymentId} not found`,
        });
      }

      const paymentData = paymentDoc.data();

      const stripe = await initStripe();
      const stripePaymentIntent = await stripe.
        paymentIntents.retrieve(paymentId);

      if (stripePaymentIntent.status !== paymentData?.status) {
        await db.collection("payments").doc(paymentId).update({
          status: stripePaymentIntent.status,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      return response.status(200).json({
        success: true,
        paymentId: paymentId,
        status: stripePaymentIntent.status,
        amount: paymentData?.amount || 0,
        currency: paymentData?.currency || "GBP",
        paymentType: paymentData?.paymentType || "test",
        eventId: paymentData?.eventId,
        eventName: paymentData?.eventName,
        userEmail: paymentData?.userEmail,
        createdAt: paymentData?.createdAt,
        updatedAt: new Date().toISOString(),
      });
    } catch (error: any) {
      logger.error("Get payment status error:", error);
      return response.status(500).json({
        error: "Error retrieving payment status",
        message: error.message,
      });
    }
  });
});
