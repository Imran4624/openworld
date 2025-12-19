/*
// REQUEST
{
  "email": "user@example.com",
  "name": "John Doe",
  "phone": "+1234567890"
}

// RESPONSE
{
  "success": true,
  "data": {
    "customerId": "cus_1234567890",
    "email": "user@example.com",
    "name": "John Doe",
    "phone": "+1234567890",
    "createdAt": "2025-12-06T10:30:00.000Z"
  }
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {initStripe, useIdempotency, completeIdempotency} from "./utils";
import {COLLECTIONS, ERROR_CODES} from "../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const createStripeCustomer = onCall(async (request) => {
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

    const {email, name, phone} = data;
    const userId = auth.uid;

    if (!email || !name) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "Email and name are required",
        },
      };
    }

    const {idempotencyKey, ref} = await useIdempotency(userId, `customer_${email}_${Date.now()}`);

    try {
      const stripe = await initStripe();

      const customer = await stripe.customers.create({
        email,
        name,
        phone,
        metadata: {
          userId,
          idempotencyKey,
        },
      });

      const updateData: any = {
        stripeCustomerId: customer.id,
        customerEmail: email,
        customerName: name,
        updatedAt: new Date(),
      };

      if (phone !== undefined && phone !== null) {
        updateData.customerPhone = phone;
      }

      await db.collection(COLLECTIONS.USERS).doc(userId).update(updateData);

      await completeIdempotency(ref, "completed");

      return {
        success: true,
        data: {
          customerId: customer.id,
          email: customer.email,
          name: customer.name,
          phone: customer.phone,
          createdAt: new Date(customer.created * 1000).toISOString(),
        },
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeInvalidRequestError") {
        return {
          success: false,
          error: {
            code: ERROR_CODES.STRIPE_ERROR,
            message: "Invalid customer creation request",
            details: {stripeError: error.message},
          },
        };
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Customer creation error:", error);
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while creating customer",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
