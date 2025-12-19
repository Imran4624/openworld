/*
Required JSON Request:
{
  "subscriptionId": "sub_1234567890",
  "cancelImmediately": false
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {initStripe} from "./utils";
import {SubscriptionResponseBuilder} from "../../models/payment/SubscriptionResponse";
import {SubscriptionMapper} from "../../mappers/SubscriptionMapper";
import {COLLECTIONS, ERROR_CODES} from "../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const unsubscribe = onCall(async (request) => {
  const {data, auth} = request;

  try {
    // Authentication check
    if (!auth?.uid) {
      return SubscriptionResponseBuilder.error(
        ERROR_CODES.UNAUTHENTICATED,
        "User must be authenticated"
      );
    }

    const {subscriptionId, cancelImmediately} = data;
    const userId = auth.uid;

    // Input validation
    if (!subscriptionId) {
      return SubscriptionResponseBuilder.error(
        ERROR_CODES.MISSING_REQUIRED_FIELD,
        "Subscription ID is required"
      );
    }

    if (typeof cancelImmediately !== "boolean") {
      return SubscriptionResponseBuilder.error(
        ERROR_CODES.MISSING_REQUIRED_FIELD,
        "Cancel immediately flag is required and must be a boolean"
      );
    }

    try {
      // Verify user owns this subscription
      const subscriptionDoc = await db.collection(COLLECTIONS.SUBSCRIPTIONS).doc(subscriptionId).get();

      if (!subscriptionDoc.exists) {
        return SubscriptionResponseBuilder.error(
          ERROR_CODES.SUBSCRIPTION_NOT_FOUND,
          "Subscription not found"
        );
      }

      const subscriptionData = subscriptionDoc.data();

      if (subscriptionData?.userId !== userId) {
        return SubscriptionResponseBuilder.error(
          ERROR_CODES.UNAUTHORIZED,
          "You are not authorized to cancel this subscription"
        );
      }

      // Initialize Stripe
      const stripe = await initStripe();

      // Cancel subscription
      const canceledSubscription = await stripe.subscriptions.cancel(
        subscriptionId,
        {
          prorate: !cancelImmediately,
          invoice_now: cancelImmediately,
        }
      );

      // Update subscription record in Firestore
      await db.collection(COLLECTIONS.SUBSCRIPTIONS).doc(subscriptionId).update({
        status: canceledSubscription.status,
        canceledAt: FieldValue.serverTimestamp(),
        cancelReason: cancelImmediately ? "immediate" : "end_of_period",
        updatedAt: FieldValue.serverTimestamp(),
      });

      // Map to response model
      const responseData = SubscriptionMapper.mapToSubscriptionData(canceledSubscription, userId, subscriptionData?.productName);

      return SubscriptionResponseBuilder.success(responseData);
    } catch (error: any) {
      if (error.type === "StripeInvalidRequestError") {
        if (error.code === "resource_missing") {
          return SubscriptionResponseBuilder.error(
            "SUBSCRIPTION_NOT_FOUND",
            "Subscription not found in Stripe"
          );
        }

        return SubscriptionResponseBuilder.error(
          "STRIPE_ERROR",
          "Invalid cancellation request",
          {stripeError: error.message}
        );
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Subscription cancellation error:", error);
    return SubscriptionResponseBuilder.error(
      "INTERNAL_ERROR",
      "An unexpected error occurred while canceling subscription",
      {timestamp: new Date().toISOString()}
    );
  }
});
