import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/pricing_utils.dart';
import 'package:flutter_boilerplate/services/stripe_service.dart';
import 'package:flutter_boilerplate/services/user_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/payment/widgets/payment_method_selector.dart';

class LoopjamStripeUpgradeScreen extends StatefulWidget {
  final String feature;
  final String? description;
  final String? adminStripeAccountId;
  final double? amount;
  final String? priceId;

  const LoopjamStripeUpgradeScreen({
    Key? key,
    required this.feature,
    this.description,
    this.adminStripeAccountId,
    this.amount,
    this.priceId,
  }) : super(key: key);

  static const String route = '/loopjam_stripe_upgrade';

  @override
  State<LoopjamStripeUpgradeScreen> createState() =>
      _LoopjamStripeUpgradeScreenState();
}

class _LoopjamStripeUpgradeScreenState
    extends State<LoopjamStripeUpgradeScreen> {
  final StripeService _stripeService = StripeService();
  
  bool _isProcessing = false;
  bool _isLoadingPaymentMethods = false;
  String? _errorMessage;
  String? _successMessage;
  List<Map<String, dynamic>> _paymentMethods = [];
  Map<String, dynamic>? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoadingPaymentMethods = true;
      _errorMessage = null;
    });

    try {
      final result = await _stripeService.getPaymentMethods();
      if (result['success'] == true && result['data'] != null) {
        final Map<String, dynamic> responseData =
            result['data'] as Map<String, dynamic>;
        final List<dynamic> methods = responseData['paymentMethods'] ?? [];
        setState(() {
          _paymentMethods =
              methods.map((method) => method as Map<String, dynamic>).toList();
        });
      } else {
        setState(() {
          _errorMessage = result['error']?.toString() ?? 'Failed to load payment methods';
        });
      }
    } catch (e) {
      logError('Error loading payment methods: $e');
      setState(() {
        _errorMessage = 'Failed to load payment methods: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoadingPaymentMethods = false;
      });
    }
  }

  void _onPaymentMethodSelectionChanged(Map<String, dynamic>? paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ProjectConfig.appType != AppType.loopjam) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(
          child: Text('Payment is only available for Loopjam'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: 64,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unlock Premium Features',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description ?? _getDefaultDescription(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.9),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_offer,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'One-time payment',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'No recurring charges',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.green,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '£${widget.amount?.toStringAsFixed(0) ?? PricingUtils.guestLandingPagePrice.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'What you get:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildFeatureItem('Unlimited event creation', Icons.event),
                  _buildFeatureItem(
                      'Guest photo & video uploads', Icons.cloud_upload),
                  _buildFeatureItem('Event sharing capabilities', Icons.share),
                  _buildFeatureItem('QR code generation', Icons.qr_code),
                  _buildFeatureItem(
                      '12 months of premium access', Icons.schedule),

                  const SizedBox(height: 24),

                  PaymentMethodSelector(
                    paymentMethods: _paymentMethods,
                    selectedPaymentMethod: _selectedPaymentMethod,
                    onSelectionChanged: _onPaymentMethodSelectionChanged,
                    onRefreshRequested: _loadPaymentMethods,
                    isLoading: _isLoadingPaymentMethods,
                  ),

                  const SizedBox(height: 24),

                  if (_errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_successMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _successMessage!,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isProcessing || _selectedPaymentMethod == null) 
                          ? null 
                          : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('Processing...'),
                              ],
                            )
                          : _selectedPaymentMethod == null
                              ? const Text(
                                  'Select Payment Method',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Pay £${widget.amount?.toStringAsFixed(0) ?? PricingUtils.guestLandingPagePrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Security notice
                  Row(
                    children: [
                      Icon(
                        Icons.security,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Secure payment powered by Stripe',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Icon(
            Icons.check,
            size: 20,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  String _getDefaultDescription() {
    switch (widget.feature.toLowerCase()) {
      case 'share':
        return 'Unlock event sharing and all premium features';
      case 'guest_uploads':
      case 'photos':
        return 'Unlock guest uploads and all premium features';
      default:
        return 'Unlock all premium features for your events';
    }
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      if (_selectedPaymentMethod == null) {
        setState(() {
          _errorMessage = 'Please select a payment method to continue';
          _isProcessing = false;
        });
        return;
      }

      if (ProjectConfig.appType == AppType.loopjam &&
          (widget.adminStripeAccountId == null ||
              widget.adminStripeAccountId!.isEmpty)) {
        setState(() {
          _errorMessage =
              'Payment not available. Admin needs to connect Stripe account first.';
          _isProcessing = false;
        });
        return;
      }

      final amount = widget.amount ?? PricingUtils.guestLandingPagePrice;
      final priceId = widget.priceId ?? PricingUtils.stripeGuestLandingPagePriceId;

      final amountInMinorUnit = (amount * 100).toInt();

      setState(() {
        _errorMessage = '🔄 Processing your payment...';
      });

      logInfo('DEBUG: Selected payment method data: $_selectedPaymentMethod');

      final result = await _stripeService.processOneTimePayment(
        amount: amountInMinorUnit,
        currency: 'gbp',
        paymentMethod: _selectedPaymentMethod!,  
        description: widget.description ?? 'Loopjam Premium Feature Upgrade - ${widget.feature}',
        stripeAccount: widget.adminStripeAccountId,
        applicationFeePercent: 0, 
        metadata: {
          'feature': widget.feature,
          'upgrade_type': 'loopjam_premium',
          'price_id': priceId,
        },
      );

      if (result['success'] == true) {
        setState(() {
          _successMessage = '✅ Payment successful! Updating your account...';
          _errorMessage = null;
        });

        logInfo('Payment successful for feature: ${widget.feature}');

        try {
          final userUpdateResult = await UserService.updateUserPaymentStatus(
            plan: 'Paid', 
            priceId: priceId,
            paymentIntentId: result['data']?['paymentIntentId'],
            planExpires: DateTime.now().add(const Duration(days: 365)), 
            metadata: {
              'feature': widget.feature,
              'upgrade_type': 'loopjam_premium',
              'payment_date': DateTime.now().toIso8601String(),
              'amount': amount,
              'currency': 'gbp',
            },
          );

          if (userUpdateResult['success'] == true) {
            setState(() {
              _successMessage = 'Payment successful! Premium features activated.';
            });
            logInfo('User profile updated successfully to paid plan');
          } else {
            logError('Failed to update user profile: ${userUpdateResult['error']}');
            setState(() {
              _successMessage = 'Payment successful! (Profile update pending...)';
            });
          }
        } catch (e) {
          logError('Error updating user profile after payment: $e');
          setState(() {
            _successMessage = 'Payment successful! (Profile update pending...)';
          });
        }

        _showSuccessDialogAndNavigateBack(result);
      } else {
        final errorMessage = result['error']?.toString() ?? 'Payment failed for unknown reason';
        logError('Payment failed for feature ${widget.feature}: $errorMessage');
        
        setState(() {
          _errorMessage = errorMessage;
          _successMessage = null;
        });

        _showErrorDialog('Payment Failed', errorMessage);
      }
    } catch (e) {
      logError('Payment processing exception: $e');
      setState(() {
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
        _successMessage = null;
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessDialogAndNavigateBack(Map<String, dynamic> result) {
    final amount = widget.amount ?? PricingUtils.guestLandingPagePrice;
    final priceId = widget.priceId ?? PricingUtils.stripeGuestLandingPagePriceId;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 3), () {
          if (Navigator.of(context).canPop()) {
            _navigateBackWithSuccess(result, amount, priceId);
          }
        });
        
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 64,
          ),
          title: const Text('Payment Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your premium features have been activated.'),
              const SizedBox(height: 16),
              Text(
                'Feature: ${widget.feature}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Amount: £${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (result['data']?['paymentIntentId'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Transaction ID: ${result['data']['paymentIntentId']}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Redirecting automatically in 3 seconds...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _navigateBackWithSuccess(result, amount, priceId);
              },
              child: const Text('Continue Now'),
            ),
          ],
        );
      },
    );
  }

  void _navigateBackWithSuccess(Map<String, dynamic> result, double amount, String priceId) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop({
        'success': true,
        'feature': widget.feature,
        'amount': amount,
        'adminStripeAccountId': widget.adminStripeAccountId,
        'priceId': priceId,
        'paymentIntentId': result['data']?['paymentIntentId'],
        'transactionId': result['data']?['paymentIntentId'],
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 48,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
