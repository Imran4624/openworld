export interface WebhookResponse {
  readonly success: boolean;
  readonly data?: WebhookData;
  readonly error?: ApiError;
}

export interface WebhookData {
  readonly eventId: string;
  readonly eventType: string;
  readonly processed: boolean;
  readonly processedAt: string;
  readonly metadata: WebhookMetadata;
}

export interface WebhookMetadata {
  readonly apiVersion?: string;
  readonly livemode: boolean;
  readonly objectId?: string;
  readonly customerId?: string;
}

export interface ApiError {
  readonly code: string;
  readonly message: string;
  readonly details?: Record<string, unknown>;
}

export class WebhookResponseBuilder {
  static success(data: WebhookData): WebhookResponse {
    return {
      success: true,
      data,
    };
  }

  static error(
    code: string,
    message: string,
    details?: Record<string, unknown>
  ): WebhookResponse {
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
