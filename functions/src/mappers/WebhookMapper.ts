import Stripe from "stripe";
import {WebhookData, WebhookMetadata} from "../models/payment/WebhookResponse";

export class WebhookMapper {
  static mapToWebhookData(event: Stripe.Event): WebhookData {
    return {
      eventId: event.id,
      eventType: event.type,
      processed: true,
      processedAt: new Date().toISOString(),
      metadata: this.mapMetadata(event),
    };
  }

  private static mapMetadata(event: Stripe.Event): WebhookMetadata {
    const data = event.data.object as any;

    return {
      apiVersion: event.api_version || undefined,
      livemode: event.livemode,
      objectId: data?.id || undefined,
      customerId: this.extractCustomerId(data) || undefined,
    };
  }

  private static extractCustomerId(data: any): string | undefined {
    if (!data) return undefined;

    // Direct customer field
    if (data.customer) {
      return typeof data.customer === "string" ?
        data.customer :
        data.customer.id;
    }

    // For payment intents
    if (data.charges?.data?.[0]?.customer) {
      return data.charges.data[0].customer;
    }

    // For subscriptions
    if (data.object === "subscription") {
      return data.customer;
    }

    return undefined;
  }
}
