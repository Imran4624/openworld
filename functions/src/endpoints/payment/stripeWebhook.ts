import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {initStripe, getSecret} from "./utils";

const db = admin.firestore();

export const stripeWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const stripe = await initStripe();
    const webhookSecret = await getSecret("STRIPE_WEBHOOK_SECRET");

    let event;
    try {
      const signature = req.headers["stripe-signature"];
      if (!signature) {
        res.status(400).send("Missing stripe signature");
        return;
      }

      event = stripe.webhooks.constructEvent(
        req.rawBody,
        signature,
        webhookSecret
      );
    } catch (err) {
      res.status(400).send("Invalid signature");
      return;
    }

    const type = event.type;
    const data = event.data.object as any;

    switch (type) {
    case "payment_intent.succeeded":
      await db.collection("payments").doc(data.id).update({
        status: "succeeded",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      break;
    case "payment_intent.payment_failed":
      await db.collection("payments").doc(data.id).update({
        status: "failed",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      break;
    case "invoice.payment_succeeded":
      await db.collection("subscriptions").doc(data.subscription)
        .collection("events").add({
          stripeEventId: event.id,
          status: "payment_succeeded",
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
      await db.collection("subscriptions").doc(data.subscription).update({
        status: "active",
        lastPayment: admin.firestore.FieldValue.serverTimestamp(),
      });
      break;
    case "invoice.payment_failed":
      await db.collection("subscriptions").doc(data.subscription).update({
        status: "past_due",
      });
      break;
    case "customer.subscription.deleted":
      await db.collection("subscriptions").doc(data.id).update({
        status: "canceled",
      });
      break;
    case "charge.refunded":
      await db.collection("payments").doc(data.payment_intent)
        .collection("transactions").add({
          type: "refund",
          stripeEventId: event.id,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
      break;
    }

    res.sendStatus(200);
  } catch (error) {
    res.status(500).send("Webhook error");
  }
});
