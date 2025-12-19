import 'package:flutter_boilerplate/data/models/payment_provider_models.dart';
import 'package:flutter_boilerplate/data/models/stripe_test_payment_methods.dart';
import 'package:flutter_boilerplate/data/providers/payment_provider.dart';
import 'package:flutter_boilerplate/data/repositories/clients/stripeClient.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class StripePaymentProvider extends PaymentProvider {
  final StripeClient client;

  StripePaymentProvider(this.client);

  String _getPaymentMethodIdFromConfig() {
    if (Config.PAYMENT_ENABLED) {
      return Config.PRODUCTION_PAYMENT_METHOD;
    } else {
      return Config.TEST_PAYMENT_METHOD;
    }
  }

  Future<PaymentMethod?> createTestPaymentMethod({
    String cardType = 'visa_success',
    Map<String, dynamic>? billingDetails,
  }) async {
    final cardData = StripeTestPaymentMethods.getTestCardData(cardType);
    if (cardData == null) {
      return null;
    }

    return await client.createPaymentMethod(
      cardData: cardData,
      billingDetails: billingDetails,
    );
  }

  @override
  Future<PaymentIntent?> createPaymentIntent(
    double amount,
    String currency, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      
      final paymentMethodId = _getPaymentMethodIdFromConfig();
      
      final requestBody = {
        'amount': amount,
        'currency': currency.toLowerCase(),
        'paymentMethodId': paymentMethodId,
        'paymentType': Config.PAYMENT_ENABLED ? 'production' : 'test',
        'eventId': metadata?['event_id'] ?? 'unknown_event',
        'eventName': metadata?['event_name'] ?? 'Unknown Event',
        'userEmail': metadata?['customer_email'] ?? 'unknown@email.com',
        'metadata': {
          ...?metadata,
          'app_name': Config.APP_NAME,
          'app_version': Config.APP_VERSION,
        },
      };

      final response = await http.post(
        Uri.parse(Config.CLOUDFUNCTION_PROCESSPAYMENT),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          final paymentData = data['data'] ?? data;
          
          return PaymentIntent(
            id: paymentData['id'] ?? paymentData['paymentId'],
            clientSecret: paymentData['client_secret'] ?? '',
            amount: (paymentData['amount'] ?? amount).toDouble(),
            currency: (paymentData['currency'] ?? currency).toString().toUpperCase(),
            status: PaymentStatusX.fromString(paymentData['status'] ?? 'succeeded'),
            metadata: metadata,
          );
        } else {
          logError('Payment failed: ${data['message'] ?? data['error']}');
          return null;
        }
      } else {
        logError('Payment request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logError('Payment error: $e');
      return null;
    }
  }

  @override
  Future<Payment?> confirmPayment(
    String paymentIntentId, {
    String? paymentMethodId,
  }) async {
    return await getPaymentStatus(paymentIntentId);
  }

  @override
  Future<Payment?> getPaymentStatus(String paymentId) async {
    try {
      
      final uri = Uri.parse(Config.CLOUDFUNCTION_GETPAYMENTSTATUS)
          .replace(queryParameters: {'paymentId': paymentId});

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          return Payment(
            id: paymentId,
            amount: (data['amount'] ?? 0).toDouble(),
            currency: data['currency'] ?? 'USD',
            status: PaymentStatusX.fromString(data['status'] ?? 'unknown'),
            method: PaymentMethod(
              id: paymentId,
              type: PaymentMethodType.card,
            ),
            provider: PaymentProviderType.stripe,
            createdAt: DateTime.now(),
          );
        }
      }
      
      logError('Failed to get payment status');
      return null;
    } catch (e) {
      logError('Payment status error: $e');
      return null;
    }
  }

  @override
  Future<bool> refundPayment(String paymentId, {double? amount}) async {
    return await client.refund(paymentId, amount: amount);
  }

  Future<Payment?> createAndChargeTestPayment({
    required double amount,
    required String currency,
    required String appType,
    Map<String, dynamic>? metadata,
    String cardType = 'visa_success',
  }) async {
    final paymentIntent = await createPaymentIntent(
      amount,
      currency,
      metadata: {
        ...?metadata,
        'card_type': cardType,
        'app_type': appType,
      },
    );

    if (paymentIntent == null) {
      return null;
    }

    return Payment(
      id: paymentIntent.id,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
      status: paymentIntent.status,
      method: PaymentMethod(
        id: 'cloud_function_method',
        type: PaymentMethodType.card,
      ),
      provider: PaymentProviderType.stripe,
      createdAt: DateTime.now(),
    );
  }
}
