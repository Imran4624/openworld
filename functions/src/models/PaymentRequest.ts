export class PaymentRequest {
  public readonly userId: string;
  public readonly amount: number;
  public readonly currency: string;
  public readonly commissionAmount: number;
  public readonly commissionType: "fixed" | "percentage";
  public readonly recipientId: string;
  public readonly paymentMethodId: string;
  public readonly description: string;
  public readonly paymentType: string;

  constructor(data: unknown) {
    this.validate(data);

    this.userId = (data as any).userId;
    this.amount = (data as any).amount;
    this.currency = (data as any).currency;
    this.commissionAmount = (data as any).commissionAmount;
    this.commissionType = (data as any).commissionType;
    this.recipientId = (data as any).recipientId;
    this.paymentMethodId = (data as any).paymentMethodId;
    this.description = (data as any).description;
    this.paymentType = (data as any).paymentType;
  }

  public getCalculatedCommission(): number {
    if (this.commissionType === "percentage") {
      return Math.round((this.amount * this.commissionAmount) / 100);
    }
    return this.commissionAmount;
  }

  private validate(data: unknown): void {
    const requiredFields = [
      "userId",
      "amount",
      "currency",
      "commissionAmount",
      "commissionType",
      "recipientId",
      "paymentMethodId",
      "description",
      "paymentType",
    ];

    for (const field of requiredFields) {
      if ((data as any)[field] === undefined ||
        (data as any)[field] === null) {
        throw new Error(`${field} is required`);
      }
    }

    if ((data as any).amount < 50) {
      throw new Error("Amount must be at least 50 cents");
    }

    if (!["fixed", "percentage"].includes((data as any).commissionType)) {
      throw new Error(
        "Commission type must be either \"fixed\" or \"percentage\""
      );
    }

    if ((data as any).commissionType === "percentage" &&
      ((data as any).commissionAmount < 0 ||
        (data as any).commissionAmount > 100)) {
      throw new Error("Percentage commission must be between 0 and 100");
    }

    if ((data as any).commissionType === "fixed" &&
      (data as any).commissionAmount < 0) {
      throw new Error("Fixed commission must be non-negative");
    }
  }
}

export class PaymentMetadata {
  public readonly userId: string;
  public readonly recipientId: string;
  public readonly paymentType: string;
  public readonly idempotencyKey: string;

  constructor(
    userId: string,
    recipientId: string,
    paymentType: string,
    idempotencyKey: string
  ) {
    this.userId = userId;
    this.recipientId = recipientId;
    this.paymentType = paymentType;
    this.idempotencyKey = idempotencyKey;
  }

  toObject(): Record<string, string> {
    return {
      userId: this.userId,
      recipientId: this.recipientId,
      paymentType: this.paymentType,
      idempotencyKey: this.idempotencyKey,
    };
  }
}
