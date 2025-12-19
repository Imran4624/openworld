export class UnsubscribeRequest {
  public readonly subscriptionId: string;
  public readonly cancelImmediately: boolean;

  constructor(data: unknown) {
    this.validate(data);
    const typedData = data as {
      subscriptionId: string;
      cancelImmediately: boolean;
    };

    this.subscriptionId = typedData.subscriptionId;
    this.cancelImmediately = typedData.cancelImmediately;
  }

  private validate(data: unknown): void {
    const typedData = data as {
      subscriptionId?: string;
      cancelImmediately?: boolean;
    };

    if (!typedData.subscriptionId) {
      throw new Error("subscriptionId is required");
    }

    if (typeof typedData.cancelImmediately !== "boolean") {
      throw new Error("cancelImmediately is required and must be a boolean");
    }
  }
}

export class RefundRequest {
  public readonly paymentIntentId: string;
  public readonly amount: number;
  public readonly reason: string;

  constructor(data: unknown) {
    this.validate(data);
    const typedData = data as {
      paymentIntentId: string;
      amount: number;
      reason: string;
    };

    this.paymentIntentId = typedData.paymentIntentId;
    this.amount = typedData.amount;
    this.reason = typedData.reason;
  }

  private validate(data: unknown): void {
    const typedData = data as { [key: string]: unknown };
    const requiredFields = ["paymentIntentId", "amount", "reason"];

    for (const field of requiredFields) {
      if (!typedData[field]) {
        throw new Error(`${field} is required`);
      }
    }

    if ((typedData.amount as number) <= 0) {
      throw new Error("Refund amount must be positive");
    }
  }
}
