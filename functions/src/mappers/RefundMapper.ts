import Stripe from "stripe";
import {
  RefundData,
  RefundStatus,
  RefundReason,
  RefundMetadata,
} from "../models/payment/RefundResponse";

export class RefundMapper {
  static mapToRefundData(
    refund: Stripe.Refund,
    userId: string
  ): RefundData {
    return {
      refundId: refund.id,
      status: this.mapStatus(refund.status || "pending"),
      amount: refund.amount,
      currency: refund.currency,
      paymentIntentId: refund.payment_intent as string,
      reason: this.mapReason(refund.reason),
      metadata: this.mapMetadata(refund, userId),
      createdAt: new Date(refund.created * 1000).toISOString(),
    };
  }

  private static mapStatus(stripeStatus: string): RefundStatus {
    const statusMap: Record<string, RefundStatus> = {
      "pending": "pending",
      "succeeded": "succeeded",
      "failed": "failed",
      "canceled": "canceled",
    };

    return statusMap[stripeStatus] || "pending";
  }

  private static mapReason(
    stripeReason: Stripe.Refund.Reason | null,
  ): RefundReason {
    if (!stripeReason) return "requested_by_customer";

    const reasonMap: Record<Stripe.Refund.Reason, RefundReason> = {
      "duplicate": "duplicate",
      "fraudulent": "fraudulent",
      "requested_by_customer": "requested_by_customer",
      "expired_uncaptured_charge": "expired_uncaptured_charge",
    };

    return reasonMap[stripeReason] || "requested_by_customer";
  }

  private static mapMetadata(
    refund: Stripe.Refund,
    userId: string
  ): RefundMetadata {
    const metadata = refund.metadata || {};

    return {
      userId,
      originalTransactionId: metadata.originalTransactionId || undefined,
      refundRequestId: metadata.refundRequestId || undefined,
    };
  }
}
