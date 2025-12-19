/*
// REQUEST
{
  "paymentMethodId": "pm_1234567890",
  "billing_details": {
    "name": "John Doe Updated",
    "email": "john.updated@example.com",
    "address": {
      "line1": "456 New St",
      "city": "San Francisco",
      "state": "CA",
      "postal_code": "94105",
      "country": "US"
    }
  },
  "card": {
    "exp_month": 6,
    "exp_year": 2027
  }
}

// RESPONSE
{
  "success": true,
  "data": {
    "paymentMethodId": "pm_1234567890",
    "type": "card",
    "card": {
      "brand": "visa",
      "last4": "4242",
      "expMonth": 6,
      "expYear": 2027
    },
    "billing_details": {
      "name": "John Doe Updated",
      "email": "john.updated@example.com",
      "address": {
        "line1": "456 New St",
        "city": "San Francisco",
        "state": "CA",
        "postal_code": "94105",
        "country": "US"
      }
    },
    "updatedAt": "2025-12-06T10:30:00.000Z"
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

export const updatePaymentMethod = onCall(async (request) => {
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

    const {paymentMethodId, billingDetails, card} = data;
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

    const {ref} = await useIdempotency(userId, `update_pm_${paymentMethodId}_${Date.now()}`);

    try {
      const stripe = await initStripe();

      // Get user's Stripe customer ID
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

      // Update payment method in Stripe
      const updateData: Record<string, unknown> = {};
      if (billingDetails) {
        updateData.billing_details = billingDetails;
      }
      if (card) {
        updateData.card = card;
      }

      const updatedPaymentMethod = await stripe.paymentMethods.update(
        paymentMethodId,
        updateData,
      );

      // Update payment method in database
      const storedPaymentMethods = userData.paymentMethods || [];
      const updatedPaymentMethods = storedPaymentMethods.map(
        (pm: unknown) => {
          const paymentMethod = pm as {
            paymentMethodId?: string;
            brand?: string;
            last4?: string;
            expMonth?: number;
            expYear?: number;
          };
          return paymentMethod.paymentMethodId === paymentMethodId ?
            {
              ...paymentMethod,
              brand: updatedPaymentMethod.card?.brand || paymentMethod.brand,
              last4: updatedPaymentMethod.card?.last4 || paymentMethod.last4,
              expMonth: updatedPaymentMethod.card?.exp_month ||
                paymentMethod.expMonth,
              expYear: updatedPaymentMethod.card?.exp_year ||
                paymentMethod.expYear,
              updatedAt: new Date(),
            } :
            paymentMethod;
        },
      );

      await db.collection(COLLECTIONS.USERS).doc(userId).update({
        paymentMethods: updatedPaymentMethods,
        updatedAt: new Date(),
      });

      await completeIdempotency(ref, "completed");

      return {
        success: true,
        data: {
          paymentMethodId: updatedPaymentMethod.id,
          type: updatedPaymentMethod.type,
          card: {
            brand: updatedPaymentMethod.card?.brand,
            last4: updatedPaymentMethod.card?.last4,
            expMonth: updatedPaymentMethod.card?.exp_month,
            expYear: updatedPaymentMethod.card?.exp_year,
          },
          billing_details: updatedPaymentMethod.billing_details,
          updatedAt: new Date().toISOString(),
        },
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeInvalidRequestError") {
        return {
          success: false,
          error: {
            code: ERROR_CODES.STRIPE_ERROR,
            message: "Invalid payment method update request",
            details: {stripeError: error.message},
          },
        };
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Update payment method error:", error);
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while updating payment method",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
