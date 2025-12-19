export class SubscriptionRequest {
  public readonly amount: number;
  public readonly currency: string;
  public readonly interval: string;
  public readonly intervalCount: number;
  public readonly productName: string;
  public readonly trialPeriodDays: number;

  constructor(data: unknown) {
    this.validate(data);

    this.amount = (data as Record<string, unknown>).amount as number;
    this.currency = (data as Record<string, unknown>).currency as string;
    this.interval = (data as Record<string, unknown>).interval as string;
    this.intervalCount = (data as Record<string, unknown>).intervalCount as
      number;
    this.productName = (data as Record<string, unknown>).productName as
      string;
    this.trialPeriodDays = (data as Record<string, unknown>)
      .trialPeriodDays as number;
  }

  private validate(data: unknown): void {
    const requiredFields = [
      "amount",
      "currency",
      "interval",
      "intervalCount",
      "productName",
      "trialPeriodDays",
    ];

    const dataObj = data as Record<string, unknown>;
    for (const field of requiredFields) {
      if (dataObj[field] === undefined || dataObj[field] === null) {
        throw new Error(`${field} is required`);
      }
    }

    if ((dataObj.amount as number) < 50) {
      throw new Error("Amount must be at least 50 cents");
    }

    if (!["day", "week", "month", "year"].includes(
      dataObj.interval as string,
    )) {
      throw new Error("Interval must be one of: day, week, month, year");
    }

    const intervalCount = dataObj.intervalCount as number;
    if (!Number.isInteger(intervalCount) ||
        intervalCount < 1 ||
        intervalCount > 12) {
      throw new Error(
        "Interval count must be an integer between 1 and 12",
      );
    }

    if ((dataObj.trialPeriodDays as number) < 0) {
      throw new Error("Trial period days must be non-negative");
    }
  }
}
