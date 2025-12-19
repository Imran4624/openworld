/*
// REQUEST
{
  "amount": 2000,
  "currency": "usd",
  "interval": "month",
  "intervalCount": 1,
  "productName": "Premium Plan",
  "trialPeriodDays": 7
}

// RESPONSE (Success)
{
  "success": true,
  "data": {
    "subscriptionId": "sub_1234567890",
    "customerId": "cus_1234567890",
    "status": "active",
    "currentPeriodStart": "2025-12-06T10:30:00.000Z",
    "currentPeriodEnd": "2026-01-06T10:30:00.000Z",
    "amount": 2000,
    "currency": "usd",
    "interval": "month",
    "trialEnd": "2025-12-13T10:30:00.000Z",
    "createdAt": "2025-12-06T10:30:00.000Z"
  }
}

// RESPONSE (Error)
{
  "success": false,
  "error": "Invalid subscription parameters"
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {initStripe, useIdempotency, completeIdempotency} from "./utils";
import {SubscriptionResponseBuilder} from "../../models/payment/SubscriptionResponse";
import {SubscriptionMapper} from "../../mappers/SubscriptionMapper";
import {SubscriptionRequest} from "../../models/SubscriptionRequest";
import {COLLECTIONS, ERROR_CODES} from "../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const subscribe = onCall(async (request) => {
  const {data, auth} = request;

  try {
    // Authentication check
    if (!auth?.uid) {
      return SubscriptionResponseBuilder.error(
        ERROR_CODES.UNAUTHENTICATED,
        "User must be authenticated"
      );
    }

    const userId = auth.uid;
    let subscriptionRequest: SubscriptionRequest;

    try {
      subscriptionRequest = new SubscriptionRequest(data);
    } catch (validationError: any) {
      return SubscriptionResponseBuilder.error(
        ERROR_CODES.MISSING_REQUIRED_FIELD,
        validationError.message
      );
    }

    // Setup idempotency
    const {idempotencyKey, ref} = await useIdempotency(userId, `subscribe_${subscriptionRequest.interval}_${subscriptionRequest.amount}_${Date.now()}`);

    try {
      // Initialize Stripe
      const stripe = await initStripe();

      // Get customer
      const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
      const customerId = userDoc.data()?.stripeCustomerId;

      if (!customerId) {
        return SubscriptionResponseBuilder.error(
          ERROR_CODES.CUSTOMER_NOT_FOUND,
          "User does not have a Stripe customer ID"
        );
      }

      // Create price for subscription
      const price = await stripe.prices.create({
        unit_amount: subscriptionRequest.amount,
        currency: subscriptionRequest.currency,
        recurring: {
          interval: subscriptionRequest.interval as any,
          interval_count: subscriptionRequest.intervalCount,
        },
        product_data: {
          name: subscriptionRequest.productName,
        },
      });

      // Create subscription
      const subscriptionData: any = {
        customer: customerId,
        items: [{price: price.id}],
        expand: ["latest_invoice.payment_intent"],
        metadata: {
          userId,
          idempotencyKey,
        },
      };

      // Add trial period if specified
      if (subscriptionRequest.trialPeriodDays && subscriptionRequest.trialPeriodDays > 0) {
        subscriptionData.trial_period_days = subscriptionRequest.trialPeriodDays;
      }

      const subscription = await stripe.subscriptions.create(subscriptionData, {idempotencyKey});

      // Save subscription record to Firestore
      await db.collection(COLLECTIONS.SUBSCRIPTIONS).doc(subscription.id).set({
        userId,
        amount: subscriptionRequest.amount,
        currency: subscriptionRequest.currency,
        interval: subscriptionRequest.interval,
        intervalCount: subscriptionRequest.intervalCount,
        status: subscription.status,
        stripeSubscriptionId: subscription.id,
        stripePriceId: price.id,
        stripeCustomerId: customerId,
        productName: subscriptionRequest.productName,
        trialPeriodDays: subscriptionRequest.trialPeriodDays,
        createdAt: FieldValue.serverTimestamp(),
        metadata: {
          idempotencyKey,
        },
      });

      // Map to response model
      const responseData = SubscriptionMapper.mapToSubscriptionData(subscription, userId, subscriptionRequest.productName);

      // Complete idempotency
      await completeIdempotency(ref, "completed");

      return SubscriptionResponseBuilder.success(responseData);
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeCardError") {
        return SubscriptionResponseBuilder.error(
          ERROR_CODES.CARD_ERROR,
          error.message,
          {stripeCode: error.code}
        );
      }

      if (error.type === "StripeInvalidRequestError") {
        return SubscriptionResponseBuilder.error(
          ERROR_CODES.STRIPE_ERROR,
          "Invalid subscription request",
          {stripeError: error.message}
        );
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Subscription creation error:", error);
    return SubscriptionResponseBuilder.error(
      ERROR_CODES.INTERNAL_ERROR,
      "An unexpected error occurred while creating subscription",
      {timestamp: new Date().toISOString()}
    );
  }
});
