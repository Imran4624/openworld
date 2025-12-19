import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_boilerplate/services/stripe_service.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'web_stripe_elements.dart' if (dart.library.io) 'web_stripe_elements_stub.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  static const String route = '/add_payment_method';

  @override
  _AddPaymentMethodScreenState createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final StripeService _stripeService = StripeService();
  final _formKey = GlobalKey<FormState>();

  // For manual card entry (fallback)
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _useStripeElements = !kIsWeb;
  CardFieldInputDetails? _cardFieldDetails;

  @override
  void initState() {
    super.initState();
    _initializeStripe();
    _initializeUserData();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _initializeStripe() async {
    if (kIsWeb) {
      try {
        final initResult = WebStripeElements.initializeStripeForWeb(Config.STRIPE_PUBLISHABLE_KEY);
        if (initResult == true) {
          setState(() {
            _useStripeElements = true;
          });
        } else {
          logError('DEBUG: Failed to initialize Stripe for web');
          setState(() {
            _errorMessage = 'Failed to initialize Stripe for web payments';
          });
        }
      } catch (e) {
        logError('Error initializing Stripe for web: $e');
        setState(() {
          _errorMessage = 'Stripe initialization failed for web';
        });
      }
      return;
    }

    try {
      Stripe.publishableKey = Config.STRIPE_PUBLISHABLE_KEY;
    } catch (e) {
      logError('Error initializing Stripe: $e');
      if (mounted) {
        setState(() {
          _useStripeElements = false;
          _errorMessage = 'Stripe initialization failed. Using manual input.';
        });
      }
    }
  }

  Future<void> _initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }
  }

  Future<void> _addPaymentMethodWithElements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (!kIsWeb && (_cardFieldDetails == null || !_cardFieldDetails!.complete)) {
        setState(() {
          _errorMessage = 'Please enter complete card information';
        });
        return;
      }

      if (_nameController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Please enter cardholder name';
        });
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
        });
        return;
      }

      setState(() {
        _errorMessage = '🔄 Creating secure payment method...';
      });

      if (kIsWeb) {
        final billingDetails = {
          'name': _nameController.text.trim(),
          'email': user.email ?? '',
        };

        setState(() {
          _errorMessage = '🔄 Creating secure token...';
        });

        final extractResult = await WebStripeElements.extractCardDataForCloudFunction(billingDetails);

        final bool success = extractResult['success'] == true;
        final String? error = extractResult['error'];
        final dynamic token = extractResult['token'];
        final dynamic paymentMethod = extractResult['paymentMethod'];

        if (!success) {
          setState(() {
            _errorMessage = error ?? 'Failed to create secure payment data';
          });
          return;
        }

        setState(() {
          _errorMessage = '🔄 Creating payment method via cloud function...';
        });

        Map<String, dynamic> paymentData = {
          'billingDetails': billingDetails,
        };

        if (paymentMethod != null) {
          paymentData['paymentMethodId'] = paymentMethod['id'];
          logInfo('DEBUG: Using payment method: ${paymentMethod['id']}');
        } else if (token != null) {
          final String? tokenId = token['id']?.toString();
          if (tokenId != null && tokenId.isNotEmpty) {
            paymentData['token'] = tokenId;
            logInfo('DEBUG: Using token: $tokenId');
          } else {
            setState(() {
              _errorMessage = 'Invalid payment data received';
            });
            return;
          }
        } else {
          setState(() {
            _errorMessage = 'No valid payment data received';
          });
          return;
        }
        
        try {
          final cloudResult = await _stripeService.createPaymentMethod(paymentData);

          if (cloudResult['success'] == true) {
            final successMessage =
                cloudResult['message'] ?? 'Payment method added successfully!';
            final paymentMethodId = cloudResult['data']?['paymentMethodId'];
            _showSuccessDialog(successMessage, paymentMethodId);
          } else {
            setState(() {
              _errorMessage =
                  cloudResult['error']?.toString() ?? 'Failed to create payment method';
            });
          }
        } catch (e) {
          setState(() {
            _errorMessage = 'Error calling cloud function: $e';
          });
        }
        return;
      }

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: _nameController.text.trim(),
              email: user.email,
            ),
          ),
        ),
      );

      setState(() {
        _errorMessage = '🔄 Attaching payment method to your account...';
      });

      final result = await _stripeService.createPaymentMethod({
        'paymentMethodId': paymentMethod.id,
        'billingDetails': {
          'name': _nameController.text.trim(),
          'email': user.email ?? '',
        },
      });

      if (result['success'] == true) {
        final successMessage =
            result['message'] ?? 'Payment method added successfully!';
        final paymentMethodId =
            result['data']?['paymentMethodId'] ?? paymentMethod.id;
        _showSuccessDialog(successMessage, paymentMethodId);
      } else {
        setState(() {
          _errorMessage =
              result['error']?.toString() ?? 'Failed to add payment method';
        });
      }
    } catch (e) {
      logError('Error adding payment method: $e');
      setState(() {
        _errorMessage = 'Error adding payment method: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message, [String? paymentMethodId]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Success'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(paymentMethodId ?? true);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }




  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter cardholder name';
    }

    return null;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                        icon: Icon(Icons.close, color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),
              ],
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: _validateName,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              if (_useStripeElements && !kIsWeb) ...[
                const Text(
                  'Card Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CardField(
                    onCardChanged: (card) {
                      setState(() {
                        _cardFieldDetails = card;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _useStripeElements = false;
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Enter card details manually'),
                ),
              ] else if (kIsWeb) ...[
                const Text(
                  'Card Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.blue[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Secure card details powered by Stripe Elements',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: WebStripeElements.createStripeElementsWidget(),
                ),
                const SizedBox(height: 8),
                
              ],
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your card information is encrypted and secure. We use Stripe to process payments.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _addPaymentMethodWithElements, // Always use Elements approach
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Add Payment Method',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
