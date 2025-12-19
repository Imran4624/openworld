/*
// REQUEST
{
  // No body required - uses authenticated user's ID
}

// RESPONSE
{
  "success": true,
  "data": {
    "paymentMethods": [
      {
        "paymentMethodId": "pm_1234567890",
        "type": "card",
        "card": {
          "brand": "visa",
          "last4": "4242",
          "expMonth": 12,
          "expYear": 2025
        },
        "isPrimary": true,
        "isEnabled": true,
        "createdAt": "2025-12-06T10:30:00.000Z"
      }
    ],
    "defaultPaymentMethodId": "pm_1234567890"
  }
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {initStripe} from "../utils";
import {COLLECTIONS, ERROR_CODES} from "../../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const getPaymentMethods = onCall(async (request) => {
  const {auth} = request;

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

    const userId = auth.uid;

    // Get user's Stripe customer ID and payment methods from database
    const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
    const userData = userDoc.data();

    if (!userData?.stripeCustomerId) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.CUSTOMER_NOT_FOUND,
          message: "User does not have a Stripe customer account",
        },
      };
    }

    const stripe = await initStripe();

    // Get payment methods from Stripe
    const paymentMethods = await stripe.paymentMethods.list({
      customer: userData.stripeCustomerId,
      type: "card",
    });

    // Get stored payment method data from database
    const storedPaymentMethods = userData.paymentMethods || [];
    const defaultPaymentMethodId = userData.defaultPaymentMethodId;

    // Combine Stripe data with database data
    const enrichedPaymentMethods = paymentMethods.data.map((pm: any) => {
      const stored = storedPaymentMethods.find((spm: any) => spm.paymentMethodId === pm.id);
      return {
        paymentMethodId: pm.id,
        type: pm.type,
        card: {
          brand: pm.card?.brand,
          last4: pm.card?.last4,
          expMonth: pm.card?.exp_month,
          expYear: pm.card?.exp_year,
        },
        isPrimary: pm.id === defaultPaymentMethodId,
        isEnabled: stored?.isEnabled !== false, // Default to true if not specified
        createdAt: stored?.createdAt || new Date(pm.created * 1000).toISOString(),
      };
    });

    return {
      success: true,
      data: {
        paymentMethods: enrichedPaymentMethods,
        defaultPaymentMethodId: defaultPaymentMethodId || null,
      },
    };
  } catch (error: any) {
    console.error("Get payment methods error:", error);
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while retrieving payment methods",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
