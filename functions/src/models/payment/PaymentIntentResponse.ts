export interface PaymentIntentResponse {
  readonly success: boolean;
  readonly data?: PaymentIntentData;
  readonly error?: ApiError;
}

export interface PaymentIntentData {
  readonly paymentIntentId: string;
  readonly status: PaymentStatus;
  readonly amount: number;
  readonly currency: string;
  readonly clientSecret?: string;
  readonly metadata: PaymentMetadata;
  readonly createdAt: string;
}

export interface PaymentMetadata {
  readonly userId: string;
  readonly customerId?: string;
  readonly description?: string;
}

export interface ApiError {
  readonly code: string;
  readonly message: string;
  readonly details?: Record<string, unknown>;
}

export type PaymentStatus =
  | "requires_payment_method"
  | "requires_confirmation"
  | "requires_action"
  | "processing"
  | "succeeded"
  | "canceled";

export class PaymentIntentResponseBuilder {
  static success(data: PaymentIntentData): PaymentIntentResponse {
    return {
      success: true,
      data,
    };
  }

  static error(
    code: string,
    message: string,
    details?: Record<string, unknown>
  ): PaymentIntentResponse {
    return {
      success: false,
      error: {
        code,
        message,
        details,
      },
    };
  }
}
