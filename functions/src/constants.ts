/**
 * Firestore Collection Names
 * Centralized constants for all Firestore collection references
 */
export const COLLECTIONS = {
  USERS: "users",
  PAYMENTS: "payments",
  SUBSCRIPTIONS: "subscriptions",
  REFUNDS: "refunds",
  WEBHOOK_EVENTS: "webhook_events",
  IDEMPOTENCY: "idempotency",
  STRIPE_ACCOUNTS: "stripe_accounts",
  INVOICES: "invoices",
  CUSTOMERS: "customers",
} as const;

/**
 * Payment Status Constants
 */
export const PAYMENT_STATUS = {
  PENDING: "pending",
  SUCCEEDED: "succeeded",
  FAILED: "failed",
  CANCELED: "canceled",
  REQUIRES_ACTION: "requires_action",
  PROCESSING: "processing",
} as const;

/**
 * Subscription Status Constants
 */
export const SUBSCRIPTION_STATUS = {
  ACTIVE: "active",
  PAST_DUE: "past_due",
  UNPAID: "unpaid",
  CANCELED: "canceled",
  INCOMPLETE: "incomplete",
  INCOMPLETE_EXPIRED: "incomplete_expired",
  TRIALING: "trialing",
  PAUSED: "paused",
} as const;

/**
 * Refund Status Constants
 */
export const REFUND_STATUS = {
  PENDING: "pending",
  SUCCEEDED: "succeeded",
  FAILED: "failed",
  CANCELED: "canceled",
} as const;

/**
 * Error Codes
 */
export const ERROR_CODES = {
  // Authentication
  UNAUTHENTICATED: "UNAUTHENTICATED",
  UNAUTHORIZED: "UNAUTHORIZED",

  // Validation
  INVALID_AMOUNT: "INVALID_AMOUNT",
  INVALID_CURRENCY: "INVALID_CURRENCY",
  INVALID_INTERVAL: "INVALID_INTERVAL",
  MISSING_REQUIRED_FIELD: "MISSING_REQUIRED_FIELD",

  // Business Logic
  CUSTOMER_NOT_FOUND: "CUSTOMER_NOT_FOUND",
  SUBSCRIPTION_NOT_FOUND: "SUBSCRIPTION_NOT_FOUND",
  PAYMENT_NOT_FOUND: "PAYMENT_NOT_FOUND",
  ALREADY_REFUNDED: "ALREADY_REFUNDED",

  // External Services
  STRIPE_ERROR: "STRIPE_ERROR",
  CARD_ERROR: "CARD_ERROR",

  // System
  INTERNAL_ERROR: "INTERNAL_ERROR",
  DATABASE_ERROR: "DATABASE_ERROR",
} as const;
