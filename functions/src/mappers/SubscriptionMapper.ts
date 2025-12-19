import Stripe from "stripe";
import {
  SubscriptionData,
  SubscriptionStatus,
  SubscriptionMetadata,
} from "../models/payment/SubscriptionResponse";

export class SubscriptionMapper {
  static mapToSubscriptionData(
    subscription: Stripe.Subscription,
    userId: string,
    planType: string
  ): SubscriptionData {
    const firstItem = subscription.items.data[0];

    return {
      subscriptionId: subscription.id,
      status: this.mapStatus(subscription.status),
      customerId: subscription.customer as string,
      priceId: firstItem?.price.id || "",
      currentPeriodStart: new Date(
        subscription.current_period_start * 1000,
      ).toISOString(),
      currentPeriodEnd: new Date(
        subscription.current_period_end * 1000,
      ).toISOString(),
      cancelAtPeriodEnd: subscription.cancel_at_period_end,
      metadata: this.mapMetadata(subscription, userId, planType),
      createdAt: new Date(subscription.created * 1000).toISOString(),
    };
  }

  private static mapStatus(
    stripeStatus: Stripe.Subscription.Status,
  ): SubscriptionStatus {
    const statusMap: Record<Stripe.Subscription.Status, SubscriptionStatus> = {
      "active": "active",
      "past_due": "past_due",
      "unpaid": "unpaid",
      "canceled": "canceled",
      "incomplete": "incomplete",
      "incomplete_expired": "incomplete_expired",
      "trialing": "trialing",
      "paused": "paused",
    };

    return statusMap[stripeStatus] || "incomplete";
  }

  private static mapMetadata(
    subscription: Stripe.Subscription,
    userId: string,
    planType: string
  ): SubscriptionMetadata {
    const features = this.extractFeatures(subscription.metadata || {});

    return {
      userId,
      planType,
      features: features.length > 0 ? features : undefined,
    };
  }

  private static extractFeatures(metadata: Record<string, string>): string[] {
    const featuresString = metadata.features;
    if (!featuresString) return [];

    try {
      return JSON.parse(featuresString);
    } catch {
      return featuresString.split(",").map((f) => f.trim());
    }
  }
}
