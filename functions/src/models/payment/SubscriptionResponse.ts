export interface SubscriptionResponse {
  readonly success: boolean;
  readonly data?: SubscriptionData;
  readonly error?: ApiError;
}

export interface SubscriptionData {
  readonly subscriptionId: string;
  readonly status: SubscriptionStatus;
  readonly customerId: string;
  readonly priceId: string;
  readonly currentPeriodStart: string;
  readonly currentPeriodEnd: string;
  readonly cancelAtPeriodEnd: boolean;
  readonly metadata: SubscriptionMetadata;
  readonly createdAt: string;
}

export interface SubscriptionMetadata {
  readonly userId: string;
  readonly planType: string;
  readonly features?: string[];
}

export interface ApiError {
  readonly code: string;
  readonly message: string;
  readonly details?: Record<string, unknown>;
}

export type SubscriptionStatus =
  | "active"
  | "past_due"
  | "unpaid"
  | "canceled"
  | "incomplete"
  | "incomplete_expired"
  | "trialing"
  | "paused";

export class SubscriptionResponseBuilder {
  static success(data: SubscriptionData): SubscriptionResponse {
    return {
      success: true,
      data,
    };
  }

  static error(
    code: string,
    message: string,
    details?: Record<string, unknown>
  ): SubscriptionResponse {
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
