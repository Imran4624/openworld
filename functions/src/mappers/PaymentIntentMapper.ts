import Stripe from "stripe";
import {
  PaymentIntentData,
  PaymentStatus,
  PaymentMetadata,
} from "../models/payment/PaymentIntentResponse";

export class PaymentIntentMapper {
  static mapToPaymentIntentData(
    paymentIntent: Stripe.PaymentIntent,
    userId: string
  ): PaymentIntentData {
    return {
      paymentIntentId: paymentIntent.id,
      status: this.mapStatus(paymentIntent.status),
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
      clientSecret: paymentIntent.client_secret || undefined,
      metadata: this.mapMetadata(paymentIntent, userId),
      createdAt: new Date(paymentIntent.created * 1000).toISOString(),
    };
  }

  private static mapStatus(stripeStatus: string): PaymentStatus {
    const statusMap: Record<string, PaymentStatus> = {
      "requires_payment_method": "requires_payment_method",
      "requires_confirmation": "requires_confirmation",
      "requires_action": "requires_action",
      "processing": "processing",
      "succeeded": "succeeded",
      "canceled": "canceled",
    };

    return statusMap[stripeStatus] || "requires_payment_method";
  }

  private static mapMetadata(
    paymentIntent: Stripe.PaymentIntent,
    userId: string
  ): PaymentMetadata {
    return {
      userId,
      customerId: paymentIntent.customer as string || undefined,
      description: paymentIntent.description || undefined,
    };
  }
}
