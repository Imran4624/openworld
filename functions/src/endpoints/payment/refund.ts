/*
Required JSON Request:
{
  "paymentIntentId": "pi_1234567890",
  "amount": 1000,
  "reason": "requested_by_customer"
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {initStripe} from "./utils";
import {RefundResponseBuilder} from "../../models/payment/RefundResponse";
import {RefundMapper} from "../../mappers/RefundMapper";
import {COLLECTIONS, ERROR_CODES} from "../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const refund = onCall(async (request) => {
  const {data, auth} = request;

  try {
    // Authentication check
    if (!auth?.uid) {
      return RefundResponseBuilder.error(
        ERROR_CODES.UNAUTHENTICATED,
        "User must be authenticated"
      );
    }

    const {paymentIntentId, amount, reason} = data;
    const userId = auth.uid;

    // Input validation
    if (!paymentIntentId) {
      return RefundResponseBuilder.error(
        ERROR_CODES.MISSING_REQUIRED_FIELD,
        "Payment intent ID is required"
      );
    }

    if (!reason) {
      return RefundResponseBuilder.error(
        ERROR_CODES.MISSING_REQUIRED_FIELD,
        "Refund reason is required"
      );
    }

    try {
      // Verify user owns this payment or has admin privileges
      const paymentDoc = await db.collection(COLLECTIONS.PAYMENTS).doc(paymentIntentId).get();

      if (!paymentDoc.exists) {
        return RefundResponseBuilder.error(
          ERROR_CODES.PAYMENT_NOT_FOUND,
          "Payment record not found"
        );
      }

      const paymentData = paymentDoc.data();

      // Check if user owns the payment or is admin
      if (paymentData?.userId !== userId) {
        // Check if user has admin role
        const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
        const userData = userDoc.data();

        if (!userData?.isAdmin) {
          return RefundResponseBuilder.error(
            ERROR_CODES.UNAUTHORIZED,
            "You are not authorized to refund this payment"
          );
        }
      }

      // Validate amount if provided
      if (amount && amount > paymentData?.amount) {
        return RefundResponseBuilder.error(
          ERROR_CODES.INVALID_AMOUNT,
          "Refund amount cannot exceed original payment amount"
        );
      }

      // Initialize Stripe
      const stripe = await initStripe();

      // Create refund
      const refundData: any = {
        payment_intent: paymentIntentId,
        metadata: {
          userId,
          reason: reason,
          processedBy: userId,
        },
      };

      if (amount) {
        refundData.amount = amount;
      }

      const stripeRefund = await stripe.refunds.create(refundData);

      // Save refund record to Firestore
      await db.collection(COLLECTIONS.REFUNDS).doc(stripeRefund.id).set({
        userId: paymentData?.userId,
        processedBy: userId,
        refundId: stripeRefund.id,
        paymentIntentId,
        amount: stripeRefund.amount,
        currency: stripeRefund.currency,
        status: stripeRefund.status,
        reason: reason,
        createdAt: FieldValue.serverTimestamp(),
        metadata: {
          originalPaymentAmount: paymentData?.amount,
          refundType: amount ? "partial" : "full",
        },
      });

      // Update payment record
      await db.collection(COLLECTIONS.PAYMENTS).doc(paymentIntentId).update({
        refunded: true,
        refundedAmount: FieldValue.increment(stripeRefund.amount),
        lastRefundAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      // Map to response model
      const responseData = RefundMapper.mapToRefundData(stripeRefund, userId);

      return RefundResponseBuilder.success(responseData);
    } catch (error: any) {
      if (error.type === "StripeInvalidRequestError") {
        if (error.code === "charge_already_refunded") {
          return RefundResponseBuilder.error(
            "ALREADY_REFUNDED",
            "This payment has already been fully refunded"
          );
        }

        if (error.code === "amount_too_large") {
          return RefundResponseBuilder.error(
            "REFUND_AMOUNT_TOO_LARGE",
            "Refund amount exceeds available amount"
          );
        }

        return RefundResponseBuilder.error(
          "STRIPE_ERROR",
          "Invalid refund request",
          {stripeError: error.message}
        );
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Refund processing error:", error);
    return RefundResponseBuilder.error(
      "INTERNAL_ERROR",
      "An unexpected error occurred while processing refund",
      {timestamp: new Date().toISOString()}
    );
  }
});
