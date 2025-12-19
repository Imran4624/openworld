import 'dart:convert';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_boilerplate/.env.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/project_config.dart';

class StripeService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final appName = ProjectConfig.appType.name;
  Future<Map<String, dynamic>> _ensureStripeCustomer() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      String? stripeCustomerId;
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        stripeCustomerId = userData?['stripeCustomerId'] as String?;
      }

      if (stripeCustomerId == null) {
        logInfo(
            'DEBUG: No stripeCustomerId found. Creating Stripe customer for user: ${currentUser.uid}');

        final createCustomerResult = await createStripeCustomer(
          email: currentUser.email ?? '',
          name: currentUser.displayName ?? currentUser.email ?? 'User',
        );

        if (createCustomerResult['success'] != true) {
          return {
            'success': false,
            'error':
                'Failed to create Stripe customer: ${createCustomerResult['error']}',
          };
        }

        stripeCustomerId = createCustomerResult['data']?['id'] as String?;

        if (stripeCustomerId == null) {
          return {
            'success': false,
            'error': 'Failed to get customer ID from Stripe customer creation',
          };
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'stripeCustomerId': stripeCustomerId,
        }, SetOptions(merge: true));

        logInfo(
            'DEBUG: Created and saved new stripeCustomerId: $stripeCustomerId');
      } else {
        logInfo('DEBUG: Using existing stripeCustomerId: $stripeCustomerId');
      }

      return {
        'success': true,
        'customerId': stripeCustomerId,
      };
    } catch (e) {
      logError('Error in _ensureStripeCustomer: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<String?> getCurrentUserStripeCustomerId() async {
    final customerResult = await _ensureStripeCustomer();
    if (customerResult['success'] == true) {
      return customerResult['customerId'] as String?;
    }
    return null;
  }

  String _getFunctionUrl(String key) {
    switch (key) {
      case 'createStripeCustomer':
        return Config.CF_CREATE_STRIPE_CUSTOMER;
      case 'createStripeConnectAccount':
        return Config.CF_CREATE_STRIPE_CONNECT_ACCOUNT;
      case 'createPaymentMethod':
        return Config.CF_CREATE_PAYMENT_METHOD;
      case 'getPaymentMethods':
        return Config.CF_GET_PAYMENT_METHODS;
      case 'updatePaymentMethod':
        return Config.CF_UPDATE_PAYMENT_METHOD;
      case 'deletePaymentMethod':
        return Config.CF_DELETE_PAYMENT_METHOD;
      case 'setDefaultPaymentMethod':
        return Config.CF_SET_DEFAULT_PAYMENT_METHOD;
      case 'togglePaymentMethod':
        return Config.CF_TOGGLE_PAYMENT_METHOD;
      case 'processOneTimePayment':
        return Config.CF_PROCESS_ONE_TIME_PAYMENT;
      case 'subscribe':
        return Config.CF_SUBSCRIBE;
      case 'unsubscribe':
        return Config.CF_UNSUBSCRIBE;
      case 'refund':
        return Config.CF_REFUND;
      default:
        throw Exception('Unknown function: $key');
    }
  }

  // Create Stripe Customer
  Future<Map<String, dynamic>> createStripeCustomer({
    required String email,
    String? name,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final HttpsCallable callable =
          _functions.httpsCallable('createStripeCustomer_$appName');

      final requestData = {
        'email': email,
        'name': name,
        'metadata': metadata,
      };

      final HttpsCallableResult result = await callable.call(requestData);

      dynamic responseData = result.data;
      Map<String, dynamic> data;

      if (responseData is Map<String, dynamic>) {
        data = responseData;
      } else if (responseData is Map) {
        data = Map<String, dynamic>.from(responseData);
      } else {
        data = {'data': responseData, 'success': true};
      }

      logInfo('DEBUG: Create customer data: $data');

      String? errorMessage;
      if (data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message']?.toString() ?? 'Unknown error occurred';
        } else {
          errorMessage = errorData.toString();
        }
      }

      return {
        'success': data['success'] ?? false,
        'data': data['data'],
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Create Stripe Connect Account
  Future<Map<String, dynamic>> createStripeConnectAccount({
    required String email,
    required String businessType,
    required String country,
    String? firstName,
    String? lastName,
    String? businessName,
    String? businessUrl,
    String? phone,
    String? refreshUrl,
    String? returnUrl,
    String? bankAccountNumber,
    String? bankRoutingNumber,
    String? bankAccountHolderName,
    String? bankName,
  }) async {
    try {
      final HttpsCallable callable =
          _functions.httpsCallable('createStripeConnectAccount_$appName');

      final requestData = {
        'email': email,
        'businessType': businessType,
        'country': country,
        'firstName': firstName,
        'lastName': lastName,
        'businessName': businessName,
        'businessUrl': businessUrl,
        'phone': phone,
        'refreshUrl': refreshUrl,
        'returnUrl': returnUrl,
        'bankAccountNumber': bankAccountNumber,
        'bankRoutingNumber': bankRoutingNumber,
        'bankAccountHolderName': bankAccountHolderName,
        'bankName': bankName,
      };

      final HttpsCallableResult result = await callable.call(requestData);

      dynamic responseData = result.data;
      Map<String, dynamic> data;

      if (responseData is Map<String, dynamic>) {
        data = responseData;
      } else if (responseData is Map) {
        data = Map<String, dynamic>.from(responseData);
      } else {
        data = {'data': responseData, 'success': true};
      }

      logInfo('DEBUG: Processed data: $data');

      String? errorMessage;
      if (data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message']?.toString() ?? 'Unknown error occurred';
        } else {
          errorMessage = errorData.toString();
        }
      }

      return {
        'success': data['success'] ?? false,
        'data': data['data'],
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Create Payment Method
  Future<Map<String, dynamic>> createPaymentMethod(
      Map<String, dynamic> paymentMethodData) async {
    try {
      final customerResult = await _ensureStripeCustomer();
      if (customerResult['success'] != true) {
        return customerResult;
      }

      HttpsCallable callable =
          _functions.httpsCallable('createPaymentMethod_$appName');
      
      HttpsCallableResult result = await callable.call(paymentMethodData);

      dynamic responseData = result.data;
      
      Map<String, dynamic> data;

      if (responseData is Map<String, dynamic>) {
        data = responseData;
      } else if (responseData is Map) {
        data = Map<String, dynamic>.from(responseData);
      } else {
        data = {'data': responseData, 'success': true};
      }

      logInfo('Create payment method processed data: $data');

      String? errorMessage;
      if (data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message']?.toString() ?? 'Unknown error occurred';
        } else {
          errorMessage = errorData.toString();
        }
      }

      return {
        'success': data['success'] ?? false,
        'data': data['data'],
        'error': errorMessage,
        'message': data['message'],
      };
    } catch (e) {
      logError('Exception in createPaymentMethod: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Get Payment Methods
  Future<Map<String, dynamic>> getPaymentMethods([String? customerId]) async {
    try {
      String? stripeCustomerId = customerId;

      if (stripeCustomerId == null) {
        final customerResult = await _ensureStripeCustomer();
        if (customerResult['success'] != true) {
          return customerResult;
        }
        stripeCustomerId = customerResult['customerId'] as String?;
      }

      final HttpsCallable callable =
          _functions.httpsCallable('getPaymentMethods_$appName');

      final requestData = {'customer_id': stripeCustomerId};
      final HttpsCallableResult result = await callable.call(requestData);

      dynamic responseData = result.data;
      Map<String, dynamic> data;

      if (responseData is Map<String, dynamic>) {
        data = responseData;
      } else if (responseData is Map) {
        data = Map<String, dynamic>.from(responseData);
      } else {
        data = {'data': responseData, 'success': true};
      }

      logInfo('DEBUG: Get payment methods data: $data');

      String? errorMessage;
      if (data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message']?.toString() ?? 'Unknown error occurred';
        } else {
          errorMessage = errorData.toString();
        }
      }

      return {
        'success': data['success'] ?? false,
        'data': data['data'],
        'error': errorMessage,
      };
    } catch (e) {
      logError('DEBUG: Error in getPaymentMethods: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Update Payment Method
  Future<Map<String, dynamic>> updatePaymentMethod({
    required String paymentMethodId,
    Map<String, dynamic>? billingDetails,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_getFunctionUrl('updatePaymentMethod')),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payment_method_id': paymentMethodId,
          'billing_details': billingDetails,
          'metadata': metadata,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'data': data,
        'error': response.statusCode != 200
            ? data['message'] ?? 'Unknown error'
            : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Delete Payment Method
  Future<Map<String, dynamic>> deletePaymentMethod(
      String paymentMethodId) async {
    try {
      final response = await http.post(
        Uri.parse(_getFunctionUrl('deletePaymentMethod')),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payment_method_id': paymentMethodId,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'data': data,
        'error': response.statusCode != 200
            ? data['message'] ?? 'Unknown error'
            : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Set Default Payment Method
  Future<Map<String, dynamic>> setDefaultPaymentMethod({
    required String customerId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_getFunctionUrl('setDefaultPaymentMethod')),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customer_id': customerId,
          'payment_method_id': paymentMethodId,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'data': data,
        'error': response.statusCode != 200
            ? data['message'] ?? 'Unknown error'
            : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Toggle Payment Method (Enable/Disable)
  Future<Map<String, dynamic>> togglePaymentMethod({
    required String paymentMethodId,
    required bool enabled,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_getFunctionUrl('togglePaymentMethod')),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payment_method_id': paymentMethodId,
          'enabled': enabled,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'data': data,
        'error': response.statusCode != 200
            ? data['message'] ?? 'Unknown error'
            : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> processOneTimePayment({
    required int amount, 
    required String currency,
    required dynamic paymentMethod,
    String? description,
    String? stripeAccount,
    double? applicationFeePercent,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      String? paymentMethodId;
      
      if (paymentMethod is String) {
        paymentMethodId = paymentMethod;
      } else if (paymentMethod is Map<String, dynamic>) {
        paymentMethodId = paymentMethod['paymentMethodId'] as String?;
      }

      if (paymentMethodId == null || paymentMethodId.isEmpty) {
        return {
          'success': false,
          'error': 'Valid payment method ID is required',
        };
      }

      if (ProjectConfig.appType == AppType.opw && stripeAccount != null) {
        logInfo('DEBUG: Using events121 Cloud Function for OPW payment processing');
        
        final HttpsCallable callable = _functions.httpsCallable('processOneTimePayment_$appName');
        
        final requestData = {
          'userId': currentUser.uid, 
          'amount': amount,
          'currency': currency,
          'commissionAmount': applicationFeePercent ?? 0, 
          'commissionType': 'percentage',
          'recipientId': stripeAccount,
          'paymentMethodId': paymentMethodId,
          'description': description ?? 'Payment via mobile app',
          'paymentType': 'marketplace', 
          'metadata': metadata ?? {},
        };

        logInfo('DEBUG: Cloud Function request data for OPW: $requestData');
        
        final result = await callable.call(requestData);
        
        logInfo('DEBUG: Cloud Function result for OPW: ${result.data}');

        return {
          'success': true,
          'data': result.data,
        };
      } else {
        final HttpsCallable callable = _functions.httpsCallable('processOneTimePayment_$appName');
        
        final requestData = {
          'userId': currentUser.uid, 
          'amount': amount,
          'currency': currency,
          'commissionAmount': applicationFeePercent ?? 0, 
          'commissionType': 'percentage',
          'recipientId': stripeAccount ?? '',
          'paymentMethodId': paymentMethodId,
          'description': description ?? 'Payment via mobile app',
          'paymentType': stripeAccount != null ? 'marketplace' : 'direct',
          'metadata': metadata ?? {},
        };

        
        final result = await callable.call(requestData);

        return {
          'success': true,
          'data': result.data,
        };
      }
    } catch (e) {
      logError('DEBUG: processOneTimePayment error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> createSubscription({
    required String customerId,
    String? priceId, 
    required int amount,
    required String currency,
    required String interval, 
    required int intervalCount,
    required String productName,
    int trialPeriodDays = 0,
    String? paymentMethod,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      final HttpsCallable callable =
          _functions.httpsCallable('subscribe_$appName');
      
      final requestData = {
        'userId': currentUser.uid,
        'customerId': customerId,
        'amount': amount,
        'currency': currency,
        'interval': interval,
        'intervalCount': intervalCount,
        'productName': productName,
        'trialPeriodDays': trialPeriodDays,
        'paymentMethod': paymentMethod,
        'metadata': metadata ?? {},
      };

      final HttpsCallableResult result = await callable.call(requestData);

      dynamic responseData = result.data;
      Map<String, dynamic> data;

      if (responseData is Map<String, dynamic>) {
        data = responseData;
      } else if (responseData is Map) {
        data = Map<String, dynamic>.from(responseData);
      } else {
        data = {'data': responseData, 'success': true};
      }


      String? errorMessage;
      if (data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message']?.toString() ?? 'Unknown error occurred';
        } else {
          errorMessage = errorData.toString();
        }
      }

      return {
        'success': data['success'] ?? false,
        'data': data['data'],
        'error': errorMessage,
        'message': data['message'],
      };
    } catch (e) {
      logError('Exception in createSubscription: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getUserSubscriptions() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      final QuerySnapshot subscriptionsSnapshot = await FirebaseFirestore.instance
          .collection('subscriptions')
          .where('userId', isEqualTo: currentUser.uid)
          .where('status', whereIn: ['active', 'trialing', 'past_due'])
          .get();

      final List<Map<String, dynamic>> subscriptions = subscriptionsSnapshot.docs
          .map((doc) => {
                'subscriptionId': doc.id,
                'data': doc.data() as Map<String, dynamic>,
              })
          .toList();

      return {
        'success': true,
        'subscriptions': subscriptions,
      };
    } catch (e) {
      logError('Exception in getUserSubscriptions: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> cancelSubscription(String subscriptionId, {bool cancelImmediately = false}) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      final HttpsCallable callable =
          _functions.httpsCallable('unsubscribe_$appName');
      
      final requestData = {
        'userId': currentUser.uid,
        'subscriptionId': subscriptionId,
        'cancelImmediately': cancelImmediately,
      };

      final HttpsCallableResult result = await callable.call(requestData);

      dynamic responseData = result.data;
      Map<String, dynamic> data;

      if (responseData is Map<String, dynamic>) {
        data = responseData;
      } else if (responseData is Map) {
        data = Map<String, dynamic>.from(responseData);
      } else {
        data = {'data': responseData, 'success': true};
      }

      logInfo('DEBUG: Cancel subscription data: $data');

      String? errorMessage;
      if (data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message']?.toString() ?? 'Unknown error occurred';
        } else {
          errorMessage = errorData.toString();
        }
      }

      return {
        'success': data['success'] ?? false,
        'data': data['data'],
        'error': errorMessage,
        'message': data['message'],
      };
    } catch (e) {
      logError('Exception in cancelSubscription: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> refundPayment({
    required String paymentIntentId,
    int? amount, 
    String? reason,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_getFunctionUrl('refund')),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payment_intent_id': paymentIntentId,
          'amount': amount,
          'reason': reason,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'data': data,
        'error': response.statusCode != 200
            ? data['message'] ?? 'Unknown error'
            : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
