/*
// REQUEST
{
  "paymentMethodId": "pm_1234567890"
}

// RESPONSE
{
  "success": true,
  "data": {
    "defaultPaymentMethodId": "pm_1234567890",
    "message": "Default payment method updated successfully"
  }
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {useIdempotency, completeIdempotency} from "../utils";
import {COLLECTIONS, ERROR_CODES} from "../../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const setDefaultPaymentMethod = onCall(async (request) => {
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

    const {ref} = await useIdempotency(userId, `set_default_pm_${paymentMethodId}_${Date.now()}`);

    try {
      // Get user data
      const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
      const userData = userDoc.data();

      if (!userData) {
        await completeIdempotency(ref, "failed");
        return {
          success: false,
          error: {
            code: ERROR_CODES.CUSTOMER_NOT_FOUND,
            message: "User not found",
          },
        };
      }

      // Verify the payment method belongs to the user
      const storedPaymentMethods = userData.paymentMethods || [];
      const paymentMethodExists = storedPaymentMethods.some((pm: any) => pm.paymentMethodId === paymentMethodId);

      if (!paymentMethodExists) {
        await completeIdempotency(ref, "failed");
        return {
          success: false,
          error: {
            code: ERROR_CODES.CUSTOMER_NOT_FOUND,
            message: "Payment method not found for this user",
          },
        };
      }

      // Update default payment method
      await db.collection(COLLECTIONS.USERS).doc(userId).update({
        defaultPaymentMethodId: paymentMethodId,
        updatedAt: new Date(),
      });

      await completeIdempotency(ref, "completed");

      return {
        success: true,
        data: {
          defaultPaymentMethodId: paymentMethodId,
          message: "Default payment method updated successfully",
        },
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");
      throw error;
    }
  } catch (error: any) {
    console.error("Set default payment method error:", error);
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while setting default payment method",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
