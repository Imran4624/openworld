import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_boilerplate/data/models/payment_provider_models.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class StripePaymentIntentResponse {
  final String id;
  final String clientSecret;
  final double amount;
  final String currency;
  final String status;

  StripePaymentIntentResponse({
    required this.id,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory StripePaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return StripePaymentIntentResponse(
      id: json['id'] ?? '',
      clientSecret: json['client_secret'] ?? '',
      amount: (json['amount'] ?? 0).toDouble() / 100,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class StripePaymentResponse {
  final String id;
  final double amount;
  final String currency;
  final String status;

  StripePaymentResponse({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory StripePaymentResponse.fromJson(Map<String, dynamic> json) {
    return StripePaymentResponse(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble() / 100, // Stripe uses cents
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class StripeClient {
  final String _secretKey;
  final String _baseUrl = 'https://api.stripe.com/v1';

  StripeClient(this._secretKey);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  Future<PaymentMethod?> createPaymentMethod({
    required Map<String, String> cardData,
    Map<String, dynamic>? billingDetails,
  }) async {
    try {
      final body = {
        'type': 'card',
        'card[number]': cardData['number']!,
        'card[exp_month]': cardData['exp_month']!,
        'card[exp_year]': cardData['exp_year']!,
        'card[cvc]': cardData['cvc']!,
      };

      if (billingDetails != null) {
        billingDetails.forEach((key, value) {
          body['billing_details[$key]'] = value.toString();
        });
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/payment_methods'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return PaymentMethod.fromMap(json);
      } else {
        showToast('Failed to create payment method. Please try again.');
        logError('Failed to create payment method: ${response.body}');
        return null;
      }
    } catch (e) {
      showToast(
          'Failed to create payment method. Please check your connection.');
      logError('Failed to create payment method: $e');
      return null;
    }
  }

  Future<StripePaymentIntentResponse?> createIntent(
    double amount,
    String currency, {
    Map<String, dynamic>? metadata,
    String? paymentMethodId,
  }) async {
    try {
      final body = {
        'amount': (amount * 100).round().toString(),
        'currency': currency.toLowerCase(),
      };

      if (paymentMethodId != null) {
        body['payment_method'] = paymentMethodId;
        body['confirmation_method'] = 'manual';
        body['confirm'] = 'true';
      } else {
        body['automatic_payment_methods[enabled]'] = 'true';
        body['automatic_payment_methods[allow_redirects]'] = 'never';
      }

      if (metadata != null) {
        metadata.forEach((key, value) {
          body['metadata[$key]'] = value.toString();
        });
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return StripePaymentIntentResponse.fromJson(json);
      } else {
        showToast('Failed to create payment intent. Please try again.');
        logError('Failed to create payment intent: ${response.body}');
        return null;
      }
    } catch (e) {
      showToast(
          'Failed to create payment intent. Please check your connection.');
      logError('Failed to create payment intent: $e');
      return null;
    }
  }

  Future<StripePaymentResponse?> createPaymentWithDummyCard({
    required double amount,
    required String currency,
    String? paymentMethodId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final finalPaymentMethodId = paymentMethodId ?? 'pm_card_visa';

      final body = {
        'amount': (amount * 100).round().toString(),
        'currency': currency.toLowerCase(),
        'payment_method': finalPaymentMethodId,
        'confirm': 'true',
        'automatic_payment_methods[enabled]': 'true',
        'automatic_payment_methods[allow_redirects]': 'never',
      };

      if (metadata != null) {
        metadata.forEach((key, value) {
          body['metadata[$key]'] = value.toString();
        });
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return StripePaymentResponse.fromJson(json);
      } else {
        showToast('Failed to process payment. Please try again.');
        logError('Failed to create and confirm payment: ${response.body}');
        return null;
      }
    } catch (e) {
      showToast('Payment failed. Please check your connection and try again.');
      logError('Failed to create payment with test method: $e');
      return null;
    }
  }

  Future<StripePaymentResponse?> createAndConfirmPayment({
    required double amount,
    required String currency,
    required String paymentMethodId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final body = {
        'amount': (amount * 100).round().toString(),
        'currency': currency.toLowerCase(),
        'payment_method': paymentMethodId,
        'confirm': 'true',
        'confirmation_method': 'automatic',
      };

      if (metadata != null) {
        metadata.forEach((key, value) {
          body['metadata[$key]'] = value.toString();
        });
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return StripePaymentResponse.fromJson(json);
      } else {
        showToast('Failed to process payment. Please try again.');
        logError('Failed to create and confirm payment: ${response.body}');
        return null;
      }
    } catch (e) {
      showToast('Payment failed. Please check your connection and try again.');
      logError('Failed to create and confirm payment: $e');
      return null;
    }
  }

  Future<StripePaymentResponse?> confirmIntent(
    String paymentIntentId, {
    String? methodId,
  }) async {
    try {
      final body = <String, String>{};

      if (methodId != null) {
        body['payment_method'] = methodId;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents/$paymentIntentId/confirm'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return StripePaymentResponse.fromJson(json);
      } else {
        showToast('Failed to confirm payment. Please try again.');
        logError('Failed to confirm payment intent: ${response.body}');
        return null;
      }
    } catch (e) {
      showToast('Payment confirmation failed. Please check your connection.');
      logError('Failed to confirm payment intent: $e');
      return null;
    }
  }

  Future<StripePaymentResponse?> retrievePayment(String paymentId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/payment_intents/$paymentId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return StripePaymentResponse.fromJson(json);
      } else {
        showToast('Failed to retrieve payment information. Please try again.');
        logError('Failed to retrieve payment: ${response.body}');
        return null;
      }
    } catch (e) {
      showToast('Failed to retrieve payment. Please check your connection.');
      logError('Failed to retrieve payment: $e');
      return null;
    }
  }

  Future<bool> refund(String paymentIntentId, {double? amount}) async {
    try {
      final body = <String, String>{
        'payment_intent': paymentIntentId,
      };

      if (amount != null) {
        body['amount'] = (amount * 100).round().toString();
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/refunds'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast('Refund processed successfully.');
        return true;
      } else {
        showToast('Failed to process refund. Please try again.');
        logError('Failed to refund payment: ${response.body}');
        return false;
      }
    } catch (e) {
      showToast('Refund failed. Please check your connection and try again.');
      logError('Failed to refund payment: $e');
      return false;
    }
  }
}
