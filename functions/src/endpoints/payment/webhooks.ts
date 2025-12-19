import {onRequest} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {initStripe} from "./utils";
import {WebhookResponseBuilder} from "../../models/payment/WebhookResponse";
import {WebhookMapper} from "../../mappers/WebhookMapper";

if (getApps().length === 0) {
  initializeApp();
}

const db = getFirestore();

export const paymentWebhooks = onRequest(async (req, res) => {
  try {
    // Only allow POST requests
    if (req.method !== "POST") {
      const response = WebhookResponseBuilder.error(
        "METHOD_NOT_ALLOWED",
        "Only POST requests are allowed"
      );
      res.status(405).json(response);
      return;
    }

    const stripe = await initStripe();
    const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET;

    if (!endpointSecret) {
      console.error("Stripe webhook secret not configured");
      const response = WebhookResponseBuilder.error(
        "WEBHOOK_SECRET_MISSING",
        "Webhook endpoint secret not configured"
      );
      res.status(500).json(response);
      return;
    }

    // Verify webhook signature
    const sig = req.headers["stripe-signature"] as string;
    let event;

    try {
      event = stripe.webhooks.constructEvent(req.body, sig, endpointSecret);
    } catch (error: any) {
      console.error("Webhook signature verification failed:", error.message);
      const response = WebhookResponseBuilder.error(
        "INVALID_SIGNATURE",
        "Webhook signature verification failed"
      );
      res.status(400).json(response);
      return;
    }

    // Process the event
    try {
      const processingResult = await processWebhookEvent(event);
      const response = WebhookResponseBuilder.success(processingResult);
      res.status(200).json(response);
    } catch (error: any) {
      console.error("Webhook processing error:", error);
      const response = WebhookResponseBuilder.error(
        "PROCESSING_ERROR",
        "Failed to process webhook event",
        {eventType: event.type, eventId: event.id}
      );
      res.status(500).json(response);
    }
  } catch (error: any) {
    console.error("Webhook handler error:", error);
    const response = WebhookResponseBuilder.error(
      "INTERNAL_ERROR",
      "An unexpected error occurred"
    );
    res.status(500).json(response);
  }
});

async function processWebhookEvent(event: any) {
  const eventData = WebhookMapper.mapToWebhookData(event);

  // Log the webhook event
  await db.collection("webhook_events").doc(event.id).set({
    eventId: event.id,
    type: event.type,
    data: eventData,
    processed: false,
    createdAt: FieldValue.serverTimestamp(),
  });

  let processingResult: any = {};

  try {
    switch (event.type) {
    case "payment_intent.succeeded":
      processingResult = await handlePaymentIntentSucceeded(event.data.object);
      break;

    case "payment_intent.payment_failed":
      processingResult = await handlePaymentIntentFailed(event.data.object);
      break;

    case "customer.subscription.created":
      processingResult = await handleSubscriptionCreated(event.data.object);
      break;

    case "customer.subscription.updated":
      processingResult = await handleSubscriptionUpdated(event.data.object);
      break;

    case "customer.subscription.deleted":
      processingResult = await handleSubscriptionDeleted(event.data.object);
      break;

    case "invoice.payment_succeeded":
      processingResult = await handleInvoicePaymentSucceeded(event.data.object);
      break;

    case "invoice.payment_failed":
      processingResult = await handleInvoicePaymentFailed(event.data.object);
      break;

    case "charge.dispute.created":
      processingResult = await handleDisputeCreated(event.data.object);
      break;

    default:
      console.log(`Unhandled event type: ${event.type}`);
      processingResult = {eventType: event.type, status: "unhandled"};
    }

    // Mark event as processed
    await db.collection("webhook_events").doc(event.id).update({
      processed: true,
      processingResult,
      processedAt: FieldValue.serverTimestamp(),
    });

    return processingResult;
  } catch (error: any) {
    // Mark event as failed
    await db.collection("webhook_events").doc(event.id).update({
      processed: false,
      processingError: error.message,
      processedAt: FieldValue.serverTimestamp(),
    });
    throw error;
  }
}

async function handlePaymentIntentSucceeded(paymentIntent: any) {
  await db.collection("payments").doc(paymentIntent.id).update({
    status: "succeeded",
    succeededAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });

  return {
    action: "payment_confirmed",
    paymentIntentId: paymentIntent.id,
    amount: paymentIntent.amount,
  };
}

async function handlePaymentIntentFailed(paymentIntent: any) {
  await db.collection("payments").doc(paymentIntent.id).update({
    status: "failed",
    failureReason: paymentIntent.last_payment_error?.message || "Unknown error",
    failedAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });

  return {
    action: "payment_failed",
    paymentIntentId: paymentIntent.id,
    reason: paymentIntent.last_payment_error?.message,
  };
}

async function handleSubscriptionCreated(subscription: any) {
  const existingDoc = await db.collection("subscriptions").doc(subscription.id).get();

  if (!existingDoc.exists) {
    await db.collection("subscriptions").doc(subscription.id).set({
      stripeSubscriptionId: subscription.id,
      customerId: subscription.customer,
      status: subscription.status,
      createdAt: FieldValue.serverTimestamp(),
      webhookCreated: true,
    });
  }

  return {
    action: "subscription_created",
    subscriptionId: subscription.id,
    status: subscription.status,
  };
}

async function handleSubscriptionUpdated(subscription: any) {
  await db.collection("subscriptions").doc(subscription.id).update({
    status: subscription.status,
    currentPeriodStart: new Date(subscription.current_period_start * 1000),
    currentPeriodEnd: new Date(subscription.current_period_end * 1000),
    updatedAt: FieldValue.serverTimestamp(),
  });

  return {
    action: "subscription_updated",
    subscriptionId: subscription.id,
    status: subscription.status,
  };
}

async function handleSubscriptionDeleted(subscription: any) {
  await db.collection("subscriptions").doc(subscription.id).update({
    status: "canceled",
    canceledAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });

  return {
    action: "subscription_canceled",
    subscriptionId: subscription.id,
  };
}

async function handleInvoicePaymentSucceeded(invoice: any) {
  if (invoice.subscription) {
    await db.collection("subscriptions").doc(invoice.subscription).update({
      lastPaymentSucceeded: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  }

  return {
    action: "invoice_paid",
    invoiceId: invoice.id,
    subscriptionId: invoice.subscription,
  };
}

async function handleInvoicePaymentFailed(invoice: any) {
  if (invoice.subscription) {
    await db.collection("subscriptions").doc(invoice.subscription).update({
      lastPaymentFailed: FieldValue.serverTimestamp(),
      paymentFailureCount: FieldValue.increment(1),
      updatedAt: FieldValue.serverTimestamp(),
    });
  }

  return {
    action: "invoice_payment_failed",
    invoiceId: invoice.id,
    subscriptionId: invoice.subscription,
  };
}

async function handleDisputeCreated(dispute: any) {
  await db.collection("disputes").doc(dispute.id).set({
    disputeId: dispute.id,
    chargeId: dispute.charge,
    amount: dispute.amount,
    currency: dispute.currency,
    reason: dispute.reason,
    status: dispute.status,
    createdAt: FieldValue.serverTimestamp(),
  });

  return {
    action: "dispute_created",
    disputeId: dispute.id,
    chargeId: dispute.charge,
  };
}
