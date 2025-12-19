/*
// REQUEST
{
  "paymentMethodId": "pm_1234567890",
  "enabled": false
}

// RESPONSE
{
  "success": true,
  "data": {
    "paymentMethodId": "pm_1234567890",
    "enabled": false,
    "message": "Payment method disabled successfully"
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

export const togglePaymentMethod = onCall(async (request) => {
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

    const {paymentMethodId, enabled} = data;
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

    if (typeof enabled !== "boolean") {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "enabled must be a boolean value",
        },
      };
    }

    const {ref} = await useIdempotency(userId, `toggle_pm_${paymentMethodId}_${enabled}_${Date.now()}`);

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

      // Update payment method enabled status
      const storedPaymentMethods = userData.paymentMethods || [];
      const updatedPaymentMethods = storedPaymentMethods.map((pm: any) =>
        pm.paymentMethodId === paymentMethodId ?
          {...pm, isEnabled: enabled, updatedAt: new Date()} :
          pm
      );

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

      const updateData: any = {
        paymentMethods: updatedPaymentMethods,
        updatedAt: new Date(),
      };

      // If disabling the default payment method, clear it
      if (!enabled && userData.defaultPaymentMethodId === paymentMethodId) {
        updateData.defaultPaymentMethodId = null;
      }

      await db.collection(COLLECTIONS.USERS).doc(userId).update(updateData);

      await completeIdempotency(ref, "completed");

      return {
        success: true,
        data: {
          paymentMethodId,
          enabled,
          message: `Payment method ${enabled ? "enabled" : "disabled"} successfully`,
        },
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");
      throw error;
    }
  } catch (error: any) {
    console.error("Toggle payment method error:", error);
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while toggling payment method",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
