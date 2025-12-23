/*
Required JSON Request for Stripe Connect Account Creation:
{
  "email": "seller@example.com",
  "businessType": "individual",
  "country": "US",
  "firstName": "John",
  "lastName": "Doe",
  "businessName": "My Business", // Only required for company accounts
  "businessUrl": "https://mybusiness.com", // Optional
  "phone": "+1234567890",
  "refreshUrl": "https://yourapp.com/connect/refresh",
  "returnUrl": "https://yourapp.com/connect/return",
  "bankAccountNumber": "000123456789", // Optional
  "bankRoutingNumber": "110000000", // Optional
  "bankAccountHolderName": "John Doe", // Optional
  "bankName": "Chase Bank" // Optional
}

Note: This function only creates NEW Stripe Connect accounts.
If user already has an account, it will return an error.
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

export const createStripeConnectAccount = onCall(async (request) => {
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

    const {
      email, businessType, country, firstName, lastName,
      businessName, businessUrl, phone, refreshUrl, returnUrl,
      bankAccountNumber, bankRoutingNumber, bankAccountHolderName,
      bankName,
    } = data;
    const userId = auth.uid;

    console.log("createStripeConnectAccount called with data:", {
      email,
      businessType,
      country,
      firstName,
      lastName,
      businessName,
      businessUrl,
      phone,
      refreshUrl,
      returnUrl,
      bankAccountNumber: bankAccountNumber ? "***" + bankAccountNumber.slice(-4) : null,
      bankRoutingNumber,
      bankAccountHolderName,
      bankName,
      userId,
    });

    if (!email || !businessType || !country || !refreshUrl || !returnUrl) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "Email, businessType, country, refreshUrl, and returnUrl are required",
        },
      };
    }

    if (!["individual", "company"].includes(businessType)) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "Business type must be individual or company",
        },
      };
    }

    if (businessType === "individual" && (!firstName || !lastName)) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "First name and last name are required for individual accounts",
        },
      };
    }

    if (businessType === "company" && !businessName) {
      return {
        success: false,
        error: {
          code: ERROR_CODES.MISSING_REQUIRED_FIELD,
          message: "Business name is required for company accounts",
        },
      };
    }

    const {idempotencyKey, ref} = await useIdempotency(userId, `connect_${email}_${Date.now()}`);

    try {
      const stripe = await initStripe();

      const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
      const userData = userDoc.data();

      if (userData?.orgStripeAccountId) {
        return {
          success: false,
          error: {
            code: ERROR_CODES.STRIPE_ERROR,
            message: "User already has a Stripe Connect account",
          },
        };
      }

      const accountData: any = {
        type: "express",
        business_type: businessType,
        country: country,
        email: email,
        capabilities: {
          card_payments: {requested: true},
          transfers: {requested: true},
        },
        // Add settings to ensure proper capability activation
        settings: {
          payouts: {
            schedule: {
              interval: "manual", // Start with manual payouts to avoid issues
            },
          },
        },
      };

      if (businessType === "company") {
        accountData.business_profile = {
          name: businessName,
          url: businessUrl,
        };
        accountData.company = {
          name: businessName,
          phone: phone,
        };
      } else {
        accountData.individual = {
          first_name: firstName,
          last_name: lastName,
          email: email,
          phone: phone,
        };
        if (businessUrl) {
          accountData.business_profile = {
            url: businessUrl,
          };
        }
      }

      const account = await stripe.accounts.create(accountData);

      let bankAccount: any = null;
      if (bankAccountNumber && bankRoutingNumber) {
        console.log("Creating bank account with details:", {
          bankAccountNumber: bankAccountNumber ? "***" + bankAccountNumber.slice(-4) : null,
          bankRoutingNumber: bankRoutingNumber,
          bankAccountHolderName: bankAccountHolderName,
          bankName: bankName,
          country: country,
          businessType: businessType,
        });

        try {
          const getCurrencyByCountry = (country: string): string => {
            const currencyMap: {[key: string]: string} = {
              "US": "usd", "GB": "gbp", "CA": "cad", "AU": "aud", "JP": "jpy",
              "CH": "chf", "DK": "dkk", "NO": "nok", "SE": "sek", "SG": "sgd",
              "AT": "eur", "BE": "eur", "CY": "eur", "EE": "eur", "FI": "eur",
              "FR": "eur", "DE": "eur", "GR": "eur", "IE": "eur", "IT": "eur",
              "LV": "eur", "LT": "eur", "LU": "eur", "MT": "eur", "NL": "eur",
              "PT": "eur", "SK": "eur", "SI": "eur", "ES": "eur",
            };
            return currencyMap[country] || "usd";
          };

          const externalAccountData = {
            external_account: {
              object: "bank_account" as const,
              country: country,
              currency: getCurrencyByCountry(country),
              account_number: bankAccountNumber,
              routing_number: bankRoutingNumber,
              account_holder_name: bankAccountHolderName || `${firstName} ${lastName}`.trim(),
              account_holder_type: businessType === "company" ? "company" as const : "individual" as const,
            },
          };

          console.log("Creating external account with data:", JSON.stringify(externalAccountData, null, 2));

          bankAccount = await stripe.accounts.createExternalAccount(account.id, externalAccountData);

          console.log("Bank account created successfully:", {
            id: bankAccount.id,
            last4: bankAccount.last4,
            status: bankAccount.status,
            currency: bankAccount.currency,
          });
        } catch (bankError: any) {
          console.error("Bank account creation error:", bankError);
          console.error("Bank account error details:", {
            type: bankError.type,
            code: bankError.code,
            message: bankError.message,
            param: bankError.param,
          });

          console.log("Continuing without bank account due to error");
        }
      } else {
        console.log("No bank account details provided - skipping bank account creation");
      }

      const accountLink = await stripe.accountLinks.create({
        account: account.id,
        refresh_url: refreshUrl,
        return_url: returnUrl,
        type: "account_onboarding",
      });

      await db.collection(COLLECTIONS.USERS).doc(userId).update({
        orgStripeAccountId: account.id,
        stripeOnboardingCompleted: false,
        accountEmail: email,
        businessType: businessType,
        updatedAt: new Date(),
      });

      // Create STRIPE_ACCOUNTS document
      const stripeAccountData = {
        userId,
        accountId: account.id,
        email: email,
        businessType: businessType,
        country: country,
        detailsSubmitted: account.details_submitted,
        chargesEnabled: account.charges_enabled,
        payoutsEnabled: account.payouts_enabled,
        onboardingUrl: accountLink.url,
        // Add capability tracking
        capabilities: {
          card_payments: account.capabilities?.card_payments,
          transfers: account.capabilities?.transfers,
        },
        // Bank account details
        bankAccount: bankAccount ? {
          id: bankAccount.id,
          bankName: bankName,
          last4: bankAccount.last4,
          currency: bankAccount.currency,
          status: bankAccount.status,
          accountHolderName: bankAccountHolderName || `${firstName} ${lastName}`.trim(),
          accountHolderType: businessType === "company" ? "company" : "individual",
        } : null,
        createdAt: new Date(),
        updatedAt: new Date(),
        metadata: {
          idempotencyKey,
        },
      };

      console.log("Saving to Firebase stripe_accounts collection:", JSON.stringify(stripeAccountData, null, 2));

      await db.collection(COLLECTIONS.STRIPE_ACCOUNTS).doc(account.id).set(stripeAccountData);

      console.log("Successfully saved stripe account data to Firebase");

      // Verify the data was saved correctly by reading it back
      const savedDoc = await db.collection(COLLECTIONS.STRIPE_ACCOUNTS).doc(account.id).get();
      const savedData = savedDoc.data();

      if (savedDoc.exists && savedData) {
        console.log("Verification - Document exists in Firebase");
        if (savedData.bankAccount) {
          console.log("Verification - Bank account data successfully saved:", {
            id: savedData.bankAccount.id,
            bankName: savedData.bankAccount.bankName,
            last4: savedData.bankAccount.last4,
            status: savedData.bankAccount.status,
          });
        } else {
          console.log("Verification - No bank account data found in saved document");
        }
      } else {
        console.error("Verification - Document was not saved to Firebase!");
      }

      if (bankAccount) {
        console.log("Bank account included in saved data:", {
          id: bankAccount.id,
          bankName: bankName,
          last4: bankAccount.last4,
          status: bankAccount.status,
        });
      } else {
        console.log("No bank account data to save");
      }

      await completeIdempotency(ref, "completed");

      const responseData = {
        accountId: account.id,
        country: account.country,
        email: account.email,
        businessType: businessType,
        detailsSubmitted: account.details_submitted,
        chargesEnabled: account.charges_enabled,
        payoutsEnabled: account.payouts_enabled,
        onboardingUrl: accountLink.url,
        // Include capability status
        capabilities: {
          card_payments: account.capabilities?.card_payments,
          transfers: account.capabilities?.transfers,
        },
        // Add onboarding status information
        onboardingRequired: !account.details_submitted ||
                           account.capabilities?.card_payments !== "active" ||
                           account.capabilities?.transfers !== "active",
        bankAccount: bankAccount ? {
          id: bankAccount.id,
          bankName: bankName,
          last4: bankAccount.last4,
          currency: bankAccount.currency,
          status: bankAccount.status,
          accountHolderName: bankAccountHolderName || `${firstName} ${lastName}`.trim(),
          accountHolderType: businessType === "company" ? "company" : "individual",
        } : null,
        createdAt: new Date((account.created || 0) * 1000).toISOString(),
      };

      console.log("Returning response data:", JSON.stringify(responseData, null, 2));

      return {
        success: true,
        data: responseData,
      };
    } catch (error: any) {
      await completeIdempotency(ref, "failed");

      if (error.type === "StripeInvalidRequestError") {
        return {
          success: false,
          error: {
            code: ERROR_CODES.STRIPE_ERROR,
            message: "Invalid account registration request",
            details: {stripeError: error.message},
          },
        };
      }

      throw error;
    }
  } catch (error: any) {
    console.error("Connect account creation error:", error);
    console.error("Error stack:", error.stack);
    console.error("Error message:", error.message);
    console.error("Error type:", error.type);
    console.error("Request data:", JSON.stringify(data, null, 2));

    return {
      success: false,
      error: {
        code: ERROR_CODES.INTERNAL_ERROR,
        message: "An unexpected error occurred while creating Connect account",
        details: {
          timestamp: new Date().toISOString(),
          errorMessage: error.message,
          errorType: error.type,
        },
      },
    };
  }
});
