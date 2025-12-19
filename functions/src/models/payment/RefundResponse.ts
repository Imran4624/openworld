export interface RefundResponse {
  readonly success: boolean;
  readonly data?: RefundData;
  readonly error?: ApiError;
}

export interface RefundData {
  readonly refundId: string;
  readonly status: RefundStatus;
  readonly amount: number;
  readonly currency: string;
  readonly paymentIntentId: string;
  readonly reason: RefundReason;
  readonly metadata: RefundMetadata;
  readonly createdAt: string;
}

export interface RefundMetadata {
  readonly userId: string;
  readonly originalTransactionId?: string;
  readonly refundRequestId?: string;
}

export interface ApiError {
  readonly code: string;
  readonly message: string;
  readonly details?: Record<string, unknown>;
}

export type RefundStatus =
  | "pending"
  | "succeeded"
  | "failed"
  | "canceled";

export type RefundReason =
  | "duplicate"
  | "fraudulent"
  | "requested_by_customer"
  | "expired_uncaptured_charge";

export class RefundResponseBuilder {
  static success(data: RefundData): RefundResponse {
    return {
      success: true,
      data,
    };
  }

  static error(
    code: string,
    message: string,
    details?: Record<string, unknown>
  ): RefundResponse {
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
