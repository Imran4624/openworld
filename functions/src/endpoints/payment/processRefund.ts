import * as functions from "firebase-functions";
import {initStripe, useIdempotency, completeIdempotency} from "./utils";

export const processRefund = functions.https.onCall(async (data: any, context: any) => {
  if (!context?.auth?.uid) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const userId = context.auth.uid;
  const {paymentIntentId, amount} = data;
  const stripe = await initStripe();
  const {idempotencyKey, ref} = await useIdempotency(userId, "refund");

  const refund = await stripe.refunds.create({
    payment_intent: paymentIntentId,
    amount: amount || undefined,
  }, {idempotencyKey});

  await completeIdempotency(ref);

  return refund;
});
