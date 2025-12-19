/*
// REQUEST
{
  "userId": "user456",
  "amount": 2000,
  "currency": "usd",
  "commissionAmount": 15,
  "commissionType": "percentage",
  "recipientId": "user123",
  "paymentMethodId": "pm_1234567890",
  "description": "Payment for services",
  "paymentType": "marketplace"
}

// RESPONSE
{
  "success": true,
  "data": {
    "paymentIntentId": "pi_1234567890",
    "amount": 2000,
    "currency": "usd",
    "status": "succeeded",
    "commissionAmount": 300,
    "netAmount": 1700,
    "createdAt": "2025-12-06T10:30:00.000Z"
  }
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {initStripe, useIdempotency, completeIdempotency} from "./utils";
import {PaymentIntentResponseBuilder} from "../../models/payment/PaymentIntentResponse";
import {PaymentIntentMapper} from "../../mappers/PaymentIntentMapper";
import {PaymentRequest, PaymentMetadata} from "../../models/PaymentRequest";
import {COLLECTIONS, ERROR_CODES} from "../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const processOneTimePayment = onCall(async (request) => {
  const {data, auth} = request;

  try {
    // Authentication check
    if (!auth?.uid) {
      return PaymentIntentResponseBuilder.error(
        ERROR_CODES.UNAUTHENTICATED,
        "User must be authenticated"
      );
    }

    const userId = auth.uid;
    let paymentRequest: PaymentRequest;

    try {
      paymentRequest = new PaymentRequest(data);
    } catch (validationError: any) {
      return PaymentIntentResponseBuilder.error(
        ERROR_CODES.MISSING_REQUIRED_FIELD,
        validationError.message
      );
    }

    // Setup idempotency
    const {idempotencyKey, ref} = await useIdempotency(userId, `payment_${paymentRequest.recipientId}_${paymentRequest.amount}_${Date.now()}`);

    try {
      // Initialize Stripe
      const stripe = await initStripe();

      // Get recipient account information
      const recipientDoc = await db.collection(COLLECTIONS.USERS).doc(paymentRequest.recipientId).get();
      const recipientData = recipientDoc.data();

      if (!recipientData?.orgStripeAccountId) {
        await completeIdempotency(ref, "failed");
        return PaymentIntentResponseBuilder.error(
          ERROR_CODES.CUSTOMER_NOT_FOUND,
          "Recipient does not have a valid Stripe Connect account"
        );
      }

      try {
        const connectAccount = await stripe.accounts.retrieve(recipientData.orgStripeAccountId);

        const transfersCapability = connectAccount.capabilities?.transfers;
        const cardPaymentsCapability = connectAccount.capabilities?.card_payments;

        if (transfersCapability !== "active") {
          await completeIdempotency(ref, "failed");
          return PaymentIntentResponseBuilder.error(
            ERROR_CODES.STRIPE_ERROR,
            "Recipient's account is not ready to receive transfers. Please complete account setup.",
            {
              accountId: connectAccount.id,
              transfersCapability: transfersCapability,
              chargesEnabled: connectAccount.charges_enabled,
              detailsSubmitted: connectAccount.details_submitted,
            }
          );
        }

        if (cardPaymentsCapability !== "active") {
          await completeIdempotency(ref, "failed");
          return PaymentIntentResponseBuilder.error(
            ERROR_CODES.STRIPE_ERROR,
            "Recipient's account cannot accept card payments. Please complete account setup.",
            {
              accountId: connectAccount.id,
              cardPaymentsCapability: cardPaymentsCapability,
              chargesEnabled: connectAccount.charges_enabled,
              detailsSubmitted: connectAccount.details_submitted,
            }
          );
        }
      } catch (accountError: any) {
        await completeIdempotency(ref, "failed");
        return PaymentIntentResponseBuilder.error(
          ERROR_CODES.STRIPE_ERROR,
          "Unable to verify recipient's account status",
          {stripeError: accountError.message}
        );
      }

      // Get payer customer information
      const payerDoc = await db.collection(COLLECTIONS.USERS).doc(paymentRequest.userId).get();
      const payerData = payerDoc.data();
      const customerId = payerData?.stripeCustomerId;

      if (!customerId) {
        await completeIdempotency(ref, "failed");
        return PaymentIntentResponseBuilder.error(
          ERROR_CODES.CUSTOMER_NOT_FOUND,
          "Payer does not have a valid Stripe customer ID"
        );
      }

      // Validate payment method belongs to user and is enabled
      const userPaymentMethods = payerData?.paymentMethods || [];
      const paymentMethodData = userPaymentMethods.find((pm: any) => pm.paymentMethodId === paymentRequest.paymentMethodId);

      if (!paymentMethodData) {
        await completeIdempotency(ref, "failed");
        return PaymentIntentResponseBuilder.error(
          ERROR_CODES.CUSTOMER_NOT_FOUND,
          "Payment method not found for this user"
        );
      }

      if (paymentMethodData.isEnabled === false) {
        await completeIdempotency(ref, "failed");
        return PaymentIntentResponseBuilder.error(
          "PAYMENT_METHOD_DISABLED",
          "Payment method is disabled"
        );
      }

      // Create payment metadata
      const calculatedCommission = paymentRequest.getCalculatedCommission();
      const paymentMetadata = new PaymentMetadata(paymentRequest.userId, paymentRequest.recipientId, paymentRequest.paymentType, idempotencyKey);

      // Create payment intent with transfer and proper automatic payment methods configuration
      const paymentIntent = await stripe.paymentIntents.create({
        amount: paymentRequest.amount,
        currency: paymentRequest.currency,
        customer: customerId,
        payment_method: paymentRequest.paymentMethodId,
        confirm: true,
        description: paymentRequest.description,
        transfer_data: {
          destination: recipientData.orgStripeAccountId,
        },
        application_fee_amount: calculatedCommission,
        metadata: paymentMetadata.toObject(),
        // Configure automatic payment methods to avoid redirect-based methods
        automatic_payment_methods: {
          enabled: true,
          allow_redirects: "never",
        },
        // Add return URL as fallback (required by Stripe when confirm=true)
        return_url: "https://dummyUrl.com",
      }, {idempotencyKey});

      // Save payment record to Firestore
      await db.collection(COLLECTIONS.PAYMENTS).doc(paymentIntent.id).set({
        userId: paymentRequest.userId,
        recipientId: paymentRequest.recipientId,
        paymentIntentId: paymentIntent.id,
        amount: paymentRequest.amount,
        commissionAmount: paymentRequest.commissionAmount,
        commissionType: paymentRequest.commissionType,
        calculatedCommission: calculatedCommission,
        currency: paymentRequest.currency,
        status: paymentIntent.status,
        customerId,
        destination: recipientData.orgStripeAccountId,
        description: paymentRequest.description,
        createdAt: new Date(),
        metadata: paymentMetadata.toObject(),
      });

      // Map to response model
      const responseData = PaymentIntentMapper.mapToPaymentIntentData(paymentIntent, paymentRequest.userId);

      // Complete idempotency
      await completeIdempotency(ref, "completed");

      return PaymentIntentResponseBuilder.success(responseData);
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeCardError") {
        return PaymentIntentResponseBuilder.error(
          "CARD_ERROR",
          error.message,
          {stripeCode: error.code}
        );
      }

      if (error.type === "StripeInvalidRequestError") {
        return PaymentIntentResponseBuilder.error(
          "STRIPE_ERROR",
          "Invalid payment request",
          {stripeError: error.message}
        );
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Marketplace payment processing error:", error);
    return PaymentIntentResponseBuilder.error(
      "INTERNAL_ERROR",
      "An unexpected error occurred while processing marketplace payment",
      {timestamp: new Date().toISOString()}
    );
  }
});
