import {onRequest} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import * as logger from "firebase-functions/logger";
import * as dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Initialize Firebase Admin
initializeApp();

// Get app type from environment variable
const getAppType = (): string => {
  return process.env.APP_TYPE || "incorrect_app_type";
};

// Helper function to create function name with app type suffix
const createFunctionName = (baseName: string): string => {
  const appType = getAppType();
  console.log(`Creating function: ${baseName}_${appType}`);
  return `${baseName}_${appType}`;
};

// Import all functions
import {createStripeCustomer} from "./endpoints/payment/createStripeCustomer";
import {createStripeConnectAccount} from
  "./endpoints/payment/createStripeConnectAccount";
import {
  createPaymentMethod,
  getPaymentMethods,
  updatePaymentMethod,
  deletePaymentMethod,
  setDefaultPaymentMethod,
  togglePaymentMethod,
} from "./endpoints/payment/paymentMethods";
import {processOneTimePayment} from "./endpoints/payment/processOneTimePayment";
import {subscribe} from "./endpoints/payment/subscribe";
import {unsubscribe} from "./endpoints/payment/unsubscribe";
import {refund} from "./endpoints/payment/refund";
import {paymentWebhooks} from "./endpoints/payment/webhooks";
import {deleteUserAccount} from "./endpoints/user/deleteUserAccount";
import {filterProfiles} from "./endpoints/user/filterProfiles";
import {sendEmail} from "./endpoints/email/sendEmail";
import {updateAppVersion} from "./endpoints/config/updateAppVersion";

// Simple hello world endpoint for testing
const helloWorld = onRequest({
  invoker: "public",
}, (request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

// Export all functions with app type suffix
const exportsObj: {[key: string]: unknown} = {};

// Payment-related endpoints
exportsObj[createFunctionName("createStripeCustomer")] = createStripeCustomer;
exportsObj[createFunctionName("createStripeConnectAccount")] =
  createStripeConnectAccount;
exportsObj[createFunctionName("createPaymentMethod")] = createPaymentMethod;
exportsObj[createFunctionName("getPaymentMethods")] = getPaymentMethods;
exportsObj[createFunctionName("updatePaymentMethod")] = updatePaymentMethod;
exportsObj[createFunctionName("deletePaymentMethod")] = deletePaymentMethod;
exportsObj[createFunctionName("setDefaultPaymentMethod")] =
  setDefaultPaymentMethod;
exportsObj[createFunctionName("togglePaymentMethod")] = togglePaymentMethod;
exportsObj[createFunctionName("processOneTimePayment")] =
  processOneTimePayment;
exportsObj[createFunctionName("subscribe")] = subscribe;
exportsObj[createFunctionName("unsubscribe")] = unsubscribe;
exportsObj[createFunctionName("refund")] = refund;
exportsObj[createFunctionName("paymentWebhooks")] = paymentWebhooks;

// User-related endpoints
exportsObj[createFunctionName("deleteUserAccount")] = deleteUserAccount;
exportsObj[createFunctionName("filterProfiles")] = filterProfiles;

// Email-related endpoints
exportsObj[createFunctionName("sendEmail")] = sendEmail;

// Config-related endpoints
exportsObj[createFunctionName("updateAppVersion")] = updateAppVersion;

// Simple hello world endpoint for testing
exportsObj[createFunctionName("helloWorld")] = helloWorld;

// Export all functions
Object.keys(exportsObj).forEach((key) => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (exports as any)[key] = exportsObj[key];
});
