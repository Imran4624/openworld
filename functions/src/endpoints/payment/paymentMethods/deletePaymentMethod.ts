/*
// REQUEST
{
  "paymentMethodId": "pm_1234567890"
}

// RESPONSE
{
  "success": true,
  "data": {
    "paymentMethodId": "pm_1234567890",
    "deleted": true,
    "message": "Payment method successfully deleted"
  }
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {initStripe, useIdempotency, completeIdempotency} from "../utils";
import {COLLECTIONS, ERROR_CODES} from "../../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const deletePaymentMethod = onCall(async (request) => {
  const {data, auth} = request;

  try {
    if (!auth?.uid) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.UNAUTHENTICATED,
          message: "User must be authenticated",
        },
      };
    }

    const {paymentMethodId} = data;
    const userId = auth.uid;

    if (!paymentMethodId) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "paymentMethodId is required",
        },
      };
    }

    const {ref} = await useIdempotency(
      userId,
      `delete_pm_${paymentMethodId}_${Date.now()}`,
    );

    try {
      const stripe = await initStripe();

      // Get user data
      const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
      const userData = userDoc.data();

      if (!userData?.stripeCustomerId) {
        await completeIdempotency(ref, "failed");
        return {
          success: false,
          error: {
            code: ERROR_CODES.CUSTOMER_NOT_FOUND,
            message: "User does not have a Stripe customer account",
          },
        };
      }

      // Detach payment method from Stripe
      await stripe.paymentMethods.detach(paymentMethodId);

      // Remove payment method from database
      const storedPaymentMethods = userData.paymentMethods || [];
      const updatedPaymentMethods = storedPaymentMethods.filter(
        (pm: unknown) => {
          const paymentMethod = pm as {paymentMethodId?: string};
          return paymentMethod.paymentMethodId !== paymentMethodId;
        },
      );

      const updateData: Record<string, unknown> = {
        paymentMethods: updatedPaymentMethods,
        updatedAt: new Date(),
      };

      // If this was the default payment method, clear it
      if (userData.defaultPaymentMethodId === paymentMethodId) {
        updateData.defaultPaymentMethodId = null;
      }

      await db.collection(COLLECTIONS.USERS).doc(userId).update(updateData);

      await completeIdempotency(ref, "completed");

      return {
        success: true,
        data: {
          paymentMethodId,
          deleted: true,
          message: "Payment method successfully deleted",
        },
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeInvalidRequestError") {
        return {
          success: false,
          error: {
            code: ERROR_CODES.STRIPE_ERROR,
            message: "Invalid payment method deletion request",
            details: {stripeError: error.message},
          },
        };
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Delete payment method error:", error);
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while deleting payment method",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
