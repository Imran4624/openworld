/**
 * Endpoint Schema Registry
 *
 * This file contains the complete schema definitions for all Firebase
 * Function endpoints. Each endpoint must have both request and response
 * schemas defined here.
 */

import {EndpointSchema, field} from "../utils/schemaValidator";

// =============================================================================
// PAYMENT ENDPOINTS
// =============================================================================

export const processOneTimePaymentSchema: EndpointSchema = {
  request: {
    userId: field.string(),
    amount: field.number({min: 50}),
    currency: field.string({enum: ["usd", "eur", "gbp"]}),
    commissionAmount: field.number({min: 0}),
    commissionType: field.string({enum: ["percentage", "fixed"]}),
    recipientId: field.string(),
    paymentMethodId: field.string(),
    description: field.string({maxLength: 500}),
    paymentType: field.string({
      enum: ["marketplace", "donation", "subscription"],
    }),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentIntentId: field.string(),
      amount: field.number(),
      currency: field.string(),
      status: field.string(),
      commissionAmount: field.number(),
      netAmount: field.number(),
      createdAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

export const createPaymentMethodSchema: EndpointSchema = {
  request: {
    card: field.object({
      number: field.string({pattern: /^[0-9]{13,19}$/}),
      exp_month: field.number({min: 1, max: 12}),
      exp_year: field.number({min: new Date().getFullYear()}),
      cvc: field.string({pattern: /^[0-9]{3,4}$/}),
    }),
    billing_details: field.optional(field.object({
      name: field.optional(field.string({maxLength: 100})),
      email: field.optional(field.string({
        pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      })),
      address: field.optional(field.object({
        line1: field.optional(field.string({maxLength: 200})),
        city: field.optional(field.string({maxLength: 100})),
        state: field.optional(field.string({maxLength: 100})),
        postal_code: field.optional(field.string({maxLength: 20})),
        country: field.optional(field.string({maxLength: 2})),
      })),
    })),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentMethodId: field.string(),
      type: field.string(),
      card: field.object({
        brand: field.string(),
        last4: field.string(),
        expMonth: field.number(),
        expYear: field.number(),
      }),
      createdAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

export const getPaymentMethodsSchema: EndpointSchema = {
  request: {},
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentMethods: field.array(field.object({
        paymentMethodId: field.string(),
        type: field.string(),
        card: field.object({
          brand: field.string(),
          last4: field.string(),
          expMonth: field.number(),
          expYear: field.number(),
        }),
        isDefault: field.boolean(),
        isEnabled: field.boolean(),
        createdAt: field.string(),
      })),
    })),
    error: field.optional(field.string()),
  },
};

export const updatePaymentMethodSchema: EndpointSchema = {
  request: {
    paymentMethodId: field.string(),
    billing_details: field.optional(field.object({
      name: field.optional(field.string({maxLength: 100})),
      email: field.optional(field.string({
        pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      })),
      address: field.optional(field.object({
        line1: field.optional(field.string({maxLength: 200})),
        city: field.optional(field.string({maxLength: 100})),
        state: field.optional(field.string({maxLength: 100})),
        postal_code: field.optional(field.string({maxLength: 20})),
        country: field.optional(field.string({maxLength: 2})),
      })),
    })),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentMethodId: field.string(),
      type: field.string(),
      billing_details: field.object({}),
      updatedAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

export const deletePaymentMethodSchema: EndpointSchema = {
  request: {
    paymentMethodId: field.string(),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentMethodId: field.string(),
      deleted: field.boolean(),
    })),
    error: field.optional(field.string()),
  },
};

export const setDefaultPaymentMethodSchema: EndpointSchema = {
  request: {
    paymentMethodId: field.string(),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentMethodId: field.string(),
      isDefault: field.boolean(),
      updatedAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

export const togglePaymentMethodSchema: EndpointSchema = {
  request: {
    paymentMethodId: field.string(),
    enabled: field.boolean(),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      paymentMethodId: field.string(),
      isEnabled: field.boolean(),
      updatedAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

export const subscribeSchema: EndpointSchema = {
  request: {
    amount: field.number({min: 100}),
    currency: field.string({enum: ["usd", "eur", "gbp"]}),
    interval: field.string({
      enum: ["day", "week", "month", "year"],
    }),
    intervalCount: field.number({min: 1, max: 12}),
    productName: field.string({maxLength: 200}),
    trialPeriodDays: field.optional(field.number({min: 0, max: 365})),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      subscriptionId: field.string(),
      customerId: field.string(),
      status: field.string(),
      currentPeriodStart: field.string(),
      currentPeriodEnd: field.string(),
      amount: field.number(),
      currency: field.string(),
      interval: field.string(),
      trialEnd: field.optional(field.string()),
      createdAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

export const unsubscribeSchema: EndpointSchema = {
  request: {
    subscriptionId: field.string(),
    cancelImmediately: field.optional(field.boolean()),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      subscriptionId: field.string(),
      status: field.string(),
      canceledAt: field.string(),
      currentPeriodEnd: field.optional(field.string()),
    })),
    error: field.optional(field.string()),
  },
};

export const processRefundSchema: EndpointSchema = {
  request: {
    paymentIntentId: field.string(),
    amount: field.optional(field.number({min: 1})),
    reason: field.optional(field.string({
      enum: ["duplicate", "fraudulent", "requested_by_customer"],
    })),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      refundId: field.string(),
      paymentIntentId: field.string(),
      amount: field.number(),
      currency: field.string(),
      status: field.string(),
      reason: field.optional(field.string()),
      createdAt: field.string(),
    })),
    error: field.optional(field.string()),
  },
};

// =============================================================================
// USER ENDPOINTS
// =============================================================================

export const deleteUserAccountSchema: EndpointSchema = {
  request: {
    userId: field.string(),
    confirmDelete: field.boolean(),
  },
  response: {
    success: field.boolean(),
    message: field.optional(field.string()),
    deletionStats: field.optional(field.object({
      messagesDeleted: field.number(),
      participantsDeleted: field.number(),
      chatsMarkedDeleted: field.number(),
      userDataDeleted: field.boolean(),
      authUserDeleted: field.boolean(),
    })),
    error: field.optional(field.string()),
  },
};

export const filterProfilesSchema: EndpointSchema = {
  request: {
    filters: field.object({
      minAge: field.optional(field.number({min: 18, max: 100})),
      maxAge: field.optional(field.number({min: 18, max: 100})),
      gender: field.optional(field.string({
        enum: ["male", "female", "other"],
      })),
      location: field.optional(field.object({
        latitude: field.number({min: -90, max: 90}),
        longitude: field.number({min: -180, max: 180}),
        radius: field.number({min: 1, max: 1000}),
      })),
      interests: field.optional(field.array(field.string())),
      currentUserId: field.string(),
      isAdmin: field.optional(field.boolean()),
    }),
    limit: field.optional(field.number({min: 1, max: 100})),
    lastDocId: field.optional(field.string()),
    excludeLikedMatchedProfiles: field.optional(field.boolean()),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      profiles: field.array(field.object({
        id: field.string(),
        name: field.string(),
        age: field.number(),
        gender: field.string(),
        location: field.optional(field.object({
          latitude: field.number(),
          longitude: field.number(),
        })),
        interests: field.optional(field.array(field.string())),
        photos: field.optional(field.array(field.string())),
        bio: field.optional(field.string()),
      })),
      hasMore: field.boolean(),
      lastDocId: field.optional(field.string()),
    })),
    error: field.optional(field.string()),
  },
};

// =============================================================================
// CONFIG ENDPOINTS
// =============================================================================

export const updateAppVersionSchema: EndpointSchema = {
  request: {
    platform: field.string({enum: ["android", "ios"]}),
    latest: field.string({pattern: /^\d+\.\d+\.\d+$/}),
  },
  response: {
    success: field.boolean(),
    message: field.optional(field.string()),
    error: field.optional(field.string()),
  },
};

export const sendEmailSchema: EndpointSchema = {
  request: {
    to: field.string({pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/}),
    subject: field.string({maxLength: 200}),
    text: field.optional(field.string()),
    html: field.optional(field.string()),
    from: field.optional(field.string()),
    template: field.optional(field.string()),
  },
  response: {
    success: field.boolean(),
    data: field.optional(field.object({
      messageId: field.string(),
      accepted: field.array(field.string()),
      rejected: field.array(field.string()),
    })),
    error: field.optional(field.string()),
  },
};

// =============================================================================
// SCHEMA REGISTRY
// =============================================================================

export const ENDPOINT_SCHEMAS: {[key: string]: EndpointSchema} = {
  // Payment endpoints
  "processOneTimePayment": processOneTimePaymentSchema,
  "createPaymentMethod": createPaymentMethodSchema,
  "getPaymentMethods": getPaymentMethodsSchema,
  "updatePaymentMethod": updatePaymentMethodSchema,
  "deletePaymentMethod": deletePaymentMethodSchema,
  "setDefaultPaymentMethod": setDefaultPaymentMethodSchema,
  "togglePaymentMethod": togglePaymentMethodSchema,
  "subscribe": subscribeSchema,
  "unsubscribe": unsubscribeSchema,
  "processRefund": processRefundSchema,

  // User endpoints
  "deleteUserAccount": deleteUserAccountSchema,
  "filterProfiles": filterProfilesSchema,

  // Config endpoints
  "updateAppVersion": updateAppVersionSchema,
  "sendEmail": sendEmailSchema,
};

/**
 * Get schema for an endpoint by name
 */
export function getEndpointSchema(
  endpointName: string,
): EndpointSchema | undefined {
  return ENDPOINT_SCHEMAS[endpointName];
}

/**
 * Get all available endpoint schemas
 */
export function getAllEndpointSchemas(): {[key: string]: EndpointSchema} {
  return {...ENDPOINT_SCHEMAS};
}
