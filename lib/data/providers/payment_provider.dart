import 'package:flutter_boilerplate/data/models/payment_provider_models.dart';

abstract class PaymentProvider {
  Future<PaymentIntent?> createPaymentIntent(
    double amount, 
    String currency, {
    Map<String, dynamic>? metadata,
  });
  
  Future<Payment?> confirmPayment(
    String paymentIntentId, {
    String? paymentMethodId,
  });
  
  Future<Payment?> getPaymentStatus(String paymentId);
  
  Future<bool> refundPayment(
    String paymentId, {
    double? amount,
  });

  Stream<PaymentEvent>? get paymentEvents => null;
}
