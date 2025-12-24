/*
// REQUEST - Option 1: Secure Token (Recommended)
{
  "paymentMethodId": "pm_1234567890",
  "billing_details": {
    "name": "John Doe",
    "email": "john@example.com"
  }
}

// REQUEST - Option 2: Client-side Token (Stripe.js tokenization)
{
  "token": "tok_1234567890",
  "billing_details": {
    "name": "John Doe",
    "email": "john@example.com"
  }
}

// REQUEST - Option 3: Web Card Data (Secure server-side processing for web)
{
  "webCardData": {
    "number": "4242424242424242",
    "exp_month": 12,
    "exp_year": 2025,
    "cvc": "123"
  },
  "billing_details": {
    "name": "John Doe",
    "email": "john@example.com"
  }
}

// REQUEST - Option 4: Raw Card Data (Legacy - requires special permission)
{
  "card": {
    "number": "4242424242424242",
    "exp_month": 12,
    "exp_year": 2025,
    "cvc": "123"
  },
  "billing_details": {
    "name": "John Doe",
    "email": "john@example.com"
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
      "expMonth": 12,
      "expYear": 2025
    },
    "createdAt": "2025-12-06T10:30:00.000Z"
  }
}
*/

import {onCall} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {initStripe, useIdempotency, completeIdempotency} from "../utils";
import {COLLECTIONS, ERROR_CODES} from "../../../constants";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const createPaymentMethod = onCall(async (request) => {
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

    const {card, paymentMethodId, token, webCardData, billingDetails} = data;
    const userId = auth.uid;

    // Validate that we have either card data, paymentMethodId, token, or webCardData
    if (!card && !paymentMethodId && !token && !webCardData) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "Either card details, paymentMethodId, token, or webCardData is required",
        },
      };
    }

    const {ref} = await useIdempotency(
      userId,
      `payment_method_${paymentMethodId || token || webCardData?.number?.slice(-4) || (card?.number?.slice(-4) + "_" + Date.now())}`,
    );

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
            message: "User does not have a Stripe customer account. " +
              "Please create a customer first.",
          },
        };
      }

      let finalPaymentMethod: any;

      if (paymentMethodId) {
        // Option 1: Secure token approach (recommended)
        // Just attach the existing payment method to customer
        finalPaymentMethod = await stripe.paymentMethods.attach(
          paymentMethodId,
          {
            customer: userData.stripeCustomerId,
          },
        );

        // Update billing details if provided
        if (billingDetails) {
          finalPaymentMethod = await stripe.paymentMethods.update(
            paymentMethodId,
            {
              billing_details: billingDetails,
            },
          );
        }
      } else if (token) {
        // Option 2: Token approach (secure client-side tokenization)
        // Use modern Payment Methods API instead of deprecated Sources API
        const paymentMethod = await stripe.paymentMethods.create({
          type: "card",
          card: {
            token: token,
          },
        });

        await stripe.paymentMethods.attach(paymentMethod.id, {
          customer: userData.stripeCustomerId,
        });

        finalPaymentMethod = {
          id: paymentMethod.id,
          type: "card",
          card: {
            brand: paymentMethod.card?.brand,
            last4: paymentMethod.card?.last4,
            exp_month: paymentMethod.card?.exp_month,
            exp_year: paymentMethod.card?.exp_year,
          },
          created: paymentMethod.created,
        };
      } else if (webCardData) {
        // Option 3: Web Card Data (secure server-side processing for web)
        // Process card data securely on server-side for web compatibility
        if (!webCardData.number || !webCardData.exp_month || !webCardData.exp_year || !webCardData.cvc) {
          await completeIdempotency(ref, "failed");
          return {
            success: false,
            error: {
              code: ERROR_CODES.MISSING_REQUIRED_FIELD,
              message: "Card details (number, exp_month, exp_year, cvc) " +
                "are required for web card processing",
            },
          };
        }

        // Create payment method with card details (server-side for web)
        const paymentMethod = await stripe.paymentMethods.create({
          type: "card",
          card: {
            number: webCardData.number,
            exp_month: webCardData.exp_month,
            exp_year: webCardData.exp_year,
            cvc: webCardData.cvc,
          },
          billing_details: billingDetails || {},
        });

        // Attach payment method to customer
        finalPaymentMethod = await stripe.paymentMethods.attach(
          paymentMethod.id,
          {
            customer: userData.stripeCustomerId,
          },
        );
      } else if (card) {
        // Option 2: Legacy raw card data approach
        // This requires special Stripe permission and should be avoided
        if (!card.number || !card.exp_month || !card.exp_year || !card.cvc) {
          await completeIdempotency(ref, "failed");
          return {
            success: false,
            error: {
              code: ERROR_CODES.MISSING_REQUIRED_FIELD,
              message: "Card details (number, exp_month, exp_year, cvc) " +
                "are required",
            },
          };
        }

        // Create payment method with card details
        const paymentMethod = await stripe.paymentMethods.create({
          type: "card",
          card: {
            number: card.number,
            exp_month: card.exp_month,
            exp_year: card.exp_year,
            cvc: card.cvc,
          },
          billing_details: billingDetails || {},
        });

        // Attach payment method to customer
        finalPaymentMethod = await stripe.paymentMethods.attach(
          paymentMethod.id,
          {
            customer: userData.stripeCustomerId,
          },
        );
      }

      // Save payment method in user's payment methods array
      await db.collection(COLLECTIONS.USERS).doc(userId).update({
        paymentMethods: FieldValue.arrayUnion({
          paymentMethodId: finalPaymentMethod!.id,
          brand: finalPaymentMethod!.card?.brand,
          last4: finalPaymentMethod!.card?.last4,
          expMonth: finalPaymentMethod!.card?.exp_month,
          expYear: finalPaymentMethod!.card?.exp_year,
          isEnabled: true,
          createdAt: new Date(),
        }),
        updatedAt: new Date(),
      });

      await completeIdempotency(ref, "completed");

      return {
        success: true,
        message: "Payment method added successfully!",
        data: {
          paymentMethodId: finalPaymentMethod!.id,
          type: finalPaymentMethod!.type,
          card: {
            brand: finalPaymentMethod!.card?.brand,
            last4: finalPaymentMethod!.card?.last4,
            expMonth: finalPaymentMethod!.card?.exp_month,
            expYear: finalPaymentMethod!.card?.exp_year,
          },
          createdAt: new Date(finalPaymentMethod!.created * 1000).toISOString(),
        },
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeCardError") {
        return {
          success: false,
          error: {
            code: "CARD_ERROR",
            message: error.message,
            details: {stripeCode: error.code},
          },
        };
      }

      if (error.type === "StripeInvalidRequestError") {
        if (error.message && error.message.includes("Sending credit card numbers directly")) {
          return {
            success: false,
            error: {
              code: ERROR_CODES.STRIPE_ERROR,
              message: "Raw Card Data APIs not enabled. Please contact support or use mobile app for payment methods.",
              details: {
                stripeError: error.message,
                suggestion: "This error occurs because Raw Card Data APIs are not enabled for this Stripe account. " +
                  "Please use the mobile app to add payment methods, or contact support to enable Raw Card Data APIs.",
              },
            },
          };
        }

        return {
          success: false,
          error: {
            code: ERROR_CODES.STRIPE_ERROR,
            message: "Invalid payment method request",
            details: {stripeError: error.message},
          },
        };
      }

      throw error;
    }
  } catch (error: any) {
    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while creating payment method",
        details: {timestamp: new Date().toISOString()},
      },
    };
  }
});
