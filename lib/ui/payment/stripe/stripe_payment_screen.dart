import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/services/stripe_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/payment_method_manager_screen.dart';
import 'package:flutter_boilerplate/ui/payment/widgets/payment_method_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StripePaymentScreen extends StatefulWidget {
  final String? preselectedRecipientId;
  final String? preselectedRecipientName;

  const StripePaymentScreen({
    super.key,
    this.preselectedRecipientId,
    this.preselectedRecipientName,
  });

  static const String route = '/stripe_payment';

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final StripeService _stripeService = StripeService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _subscriptionAmountController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _trialDaysController = TextEditingController(text: '0');

  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _paymentMethods = [];
  Map<String, dynamic>? _selectedPaymentMethod;
  List<Map<String, dynamic>> _availableRecipients = [];
  Map<String, dynamic>? _selectedRecipient;
  Map<String, dynamic>? _selectedRecipientConnectAccount;
  double _applicationFeePercent = 2.9;

  bool _isSubscriptionMode = false;
  String _subscriptionInterval = 'month';
  int _subscriptionIntervalCount = 1;
  String _subscriptionCurrency = 'usd';

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
    _loadAvailableRecipients();

    if (widget.preselectedRecipientId != null) {
      _setPreselectedRecipient();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['mode'] == 'subscription') {
        setState(() {
          _isSubscriptionMode = true;
          _subscriptionAmountController.text = '9.99';
          _productNameController.text = args['productName'] ?? 'Subscription Service';
          _trialDaysController.text = '0';
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _subscriptionAmountController.dispose();
    _productNameController.dispose();
    _trialDaysController.dispose();
    super.dispose();
  }

  Future<void> _setPreselectedRecipient() async {
    try {
      final recipientDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.preselectedRecipientId!)
          .get();

      if (recipientDoc.exists &&
          recipientDoc.data()!['orgStripeAccountId'] != null) {
        final recipientConnectResult =
            await _getRecipientConnectAccount(widget.preselectedRecipientId!);

        setState(() {
          _selectedRecipient = {
            'userId': widget.preselectedRecipientId,
            'name': widget.preselectedRecipientName ?? 'Selected User',
            'email': recipientDoc.data()!['email'] ?? '',
          };
          _selectedRecipientConnectAccount = recipientConnectResult;
        });
      }
    } catch (e) {
      logInfo('Error setting preselected recipient: $e');
    }
  }

  Future<Map<String, dynamic>?> _getRecipientConnectAccount(
      String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data()!['orgStripeAccountId'] != null) {
        final stripeAccountId = userDoc.data()!['orgStripeAccountId'];

        final stripeAccountDoc = await FirebaseFirestore.instance
            .collection('stripe_accounts')
            .doc(stripeAccountId)
            .get();

        if (stripeAccountDoc.exists) {
          return stripeAccountDoc.data();
        }
      }
      return null;
    } catch (e) {
      logError('Error getting recipient connect account: $e');
      return null;
    }
  }

  Future<void> _loadAvailableRecipients() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      final usersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('orgStripeAccountId', isNotEqualTo: null)
          .get();

      final recipients = <Map<String, dynamic>>[];

      for (final doc in usersQuery.docs) {
        if (doc.id != currentUserId) {
          recipients.add({
            'userId': doc.id,
            'name': doc.data()['displayName'] ??
                doc.data()['email'] ??
                'Unknown User',
            'email': doc.data()['email'] ?? '',
            'orgStripeAccountId': doc.data()['orgStripeAccountId'],
          });
        }
      }

      setState(() {
        _availableRecipients = recipients;
      });
    } catch (e) {
      logError('Error loading recipients: $e');
    }
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
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
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load payment methods: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectRecipient(Map<String, dynamic> recipient) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final connectAccount =
          await _getRecipientConnectAccount(recipient['userId']);
      setState(() {
        _selectedRecipient = recipient;
        _selectedRecipientConnectAccount = connectAccount;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading recipient details: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _handlePaymentPress() {
    if (_isSubscriptionMode) {
      _processSubscription();
      return;
    }

    if (_selectedRecipient == null) {
      _showToast('Please select a recipient to continue');
      return;
    }

    if (_selectedPaymentMethod == null) {
      _showToast('Please select a payment method (card) to continue');
      return;
    }

    if (_amountController.text.isEmpty) {
      _showToast('Please enter an amount to continue');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showToast('Please enter a valid amount greater than \$0');
      return;
    }

    if (amount < 0.50) {
      _showToast('Minimum payment amount is \$0.50');
      return;
    }

    if (amount > 10000) {
      _showToast('Maximum payment amount is \$10,000 per transaction');
      return;
    }

    _processPayment();
  }

  Future<void> _processPayment() async {
    setState(() {
      _errorMessage = null;
    });

    if (_amountController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount to pay';
      });
      return;
    }

    if (_selectedPaymentMethod == null) {
      setState(() {
        _errorMessage = 'Please select a payment method (card)';
      });
      return;
    }

    if (_selectedRecipient == null) {
      setState(() {});
      return;
    }

    if (_selectedRecipientConnectAccount == null) {
      setState(() {
        _errorMessage = 'Recipient bank account information not available';
      });
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = ' Please enter a valid amount greater than \$0';
      });
      return;
    }

    if (amount < 0.50) {
      setState(() {
        _errorMessage = 'Minimum payment amount is \$0.50';
      });
      return;
    }

    if (amount > 10000) {
      setState(() {
        _errorMessage = 'Maximum payment amount is \$10,000 per transaction';
      });
      return;
    }

    if (_selectedRecipientConnectAccount!['bankAccount'] == null) {
      setState(() {
        _errorMessage =
            'Recipient has not set up a bank account for receiving payments';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '🔄 Processing your payment...';
    });

    try {
      final amountInCents = (amount * 100).toInt();
      final commissionAmount =
          (amountInCents * _applicationFeePercent / 100).round();

      setState(() {
        _errorMessage = '💳 Charging your card...';
      });

      final result = await _stripeService.processOneTimePayment(
        amount: amountInCents,
        currency: 'usd',
        paymentMethod: _selectedPaymentMethod!['paymentMethodId'],
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : 'Payment to ${_selectedRecipient!['name']}',
        stripeAccount: _selectedRecipient!['userId'],
        applicationFeePercent: _applicationFeePercent,
      );

      if (result['success'] == true) {
        setState(() {
          _errorMessage = '✅ Payment successful! Transferring to recipient...';
        });

        final netAmount = amountInCents - commissionAmount;

        _showSuccessDialog(
          'Payment Processed Successfully!\n\n'
          'Recipient: ${_selectedRecipient!['name']}\n'
          'Amount: \$${(amountInCents / 100).toStringAsFixed(2)}\n'
          'Platform Fee: \$${(commissionAmount / 100).toStringAsFixed(2)}\n'
          'Net Amount to Recipient: \$${(netAmount / 100).toStringAsFixed(2)}\n\n'
          'Money will be deposited to:\n'
          '${_selectedRecipientConnectAccount!['bankAccount']?['bankName'] ?? 'Bank'} '
          '****${_selectedRecipientConnectAccount!['bankAccount']?['last4'] ?? ''}\n\n'
          'Transaction ID: ${result['data']?['paymentIntentId'] ?? 'N/A'}',
        );

        _amountController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedPaymentMethod = null;
          _selectedRecipient = null;
          _selectedRecipientConnectAccount = null;
          _errorMessage = null;
        });
      } else {
        logError('Payment failed: ${result['error']}');
        final errorMessage =
            result['error']?.toString() ?? 'Payment failed for unknown reason';
        setState(() {
          _errorMessage = 'Payment Failed: $errorMessage';
        });

        _showErrorDialog('Payment Failed', errorMessage);
      }
    } catch (e) {
      logError('💥 Payment error: $e');
      final errorMessage = 'Error processing payment: ${e.toString()}';
      setState(() {
        _errorMessage = ' $errorMessage';
      });

      _showErrorDialog('Payment Error', errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _processSubscription() async {
    if (_productNameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a product name.';
      });
      return;
    }

    if (_subscriptionAmountController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount.';
      });
      return;
    }

    final amount = double.tryParse(_subscriptionAmountController.text);
    if (amount == null || amount < 0.50) {
      setState(() {
        _errorMessage = 'Amount must be at least \$0.50.';
      });
      return;
    }

    final trialDays = int.tryParse(_trialDaysController.text.isEmpty ? '0' : _trialDaysController.text);
    if (trialDays == null || trialDays < 0) {
      setState(() {
        _errorMessage = 'Trial period days must be 0 or a positive number.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '🔄 Setting up subscription...';
    });

    try {
      if (_selectedPaymentMethod == null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentMethodManagerScreen(),
          ),
        );

        if (result == null) {
          setState(() {
            _errorMessage =
                'Subscription cancelled. Please add a payment method to subscribe.';
          });
          return;
        }
        await _loadPaymentMethods();

        if (_paymentMethods.isEmpty) {
          setState(() {
            _errorMessage =
                'No payment method found. Please add a payment method to subscribe.';
          });
          return;
        }

        _selectedPaymentMethod = _paymentMethods.first;
      }

      setState(() {
        _errorMessage = '🔄 Creating subscription...';
      });

      final customerId = await _stripeService.getCurrentUserStripeCustomerId();

      if (customerId == null) {
        setState(() {
          _errorMessage = 'Unable to get customer ID. Please try again.';
        });
        return;
      }

      final result = await _stripeService.createSubscription(
        customerId: customerId,
        amount: (double.parse(_subscriptionAmountController.text) * 100).toInt(), 
        currency: _subscriptionCurrency,
        interval: _subscriptionInterval,
        intervalCount: _subscriptionIntervalCount,
        productName: _productNameController.text,
        trialPeriodDays: int.tryParse(_trialDaysController.text) ?? 0,
        paymentMethod: _selectedPaymentMethod!['paymentMethodId'],
      );

      if (result['success'] == true) {
        _showSuccessDialog(
          'Subscription Created Successfully!\n\n'
          'You are now subscribed and your payment method will be charged automatically according to the subscription plan.\n\n'
          'Subscription ID: ${result['data']?['subscriptionId'] ?? 'N/A'}',
        );
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to create subscription';
        });
      }
    } catch (e) {
      logError('Error creating subscription: $e');
      setState(() {
        _errorMessage = 'Error creating subscription: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Payment Successful'),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orange[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '💡 Tips:\n'
                    '• Make sure your card has sufficient funds\n'
                    '• Check if your card supports online payments\n'
                    '• Verify recipient has a valid bank account\n'
                    '• Try again in a few moments',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  String _getLoadingText() {
    if (_isSubscriptionMode) {
      if (_errorMessage != null && _errorMessage!.startsWith('🔄')) {
        return 'Setting up subscription...';
      }
      return 'Processing subscription...';
    }

    if (_errorMessage != null && _errorMessage!.startsWith('🔄')) {
      return 'Processing...';
    } else if (_errorMessage != null && _errorMessage!.startsWith('💳')) {
      return 'Charging Card...';
    } else if (_errorMessage != null && _errorMessage!.startsWith('✅')) {
      return 'Transferring...';
    }
    return 'Processing...';
  }

  String _getButtonText() {
    if (_isSubscriptionMode) {
      return 'Subscribe Now';
    }
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      return 'Pay \$${amount.toStringAsFixed(2)}';
    }
    return 'Process Payment';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSubscriptionMode ? 'Subscribe' : 'Send Payment'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                  ],
                  if (!_isSubscriptionMode) ...[
                    _buildRecipientSection(),
                    const SizedBox(height: 24),
                  ],
                  _buildPaymentMethodSection(),
                  const SizedBox(height: 24),
                  if (!_isSubscriptionMode) ...[
                    _buildPaymentDetailsSection(),
                    const SizedBox(height: 24),
                  ],
                  if (_isSubscriptionMode) ...[
                    _buildSubscriptionDetailsSection(),
                    const SizedBox(height: 24),
                  ],
                  if (!_isSubscriptionMode &&
                      _selectedRecipient != null &&
                      _selectedRecipientConnectAccount != null)
                    _buildPaymentSummary(),
                  if (!_isSubscriptionMode) _buildValidationChecklist(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handlePaymentPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ? Colors.grey : Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: _isLoading ? 0 : 2,
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _getLoadingText(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.payment, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _getButtonText(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRecipientSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Recipient',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_selectedRecipient != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedRecipient!['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _selectedRecipient!['email'],
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                          if (_selectedRecipientConnectAccount?[
                                  'bankAccount'] !=
                              null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Bank: ${_selectedRecipientConnectAccount!['bankAccount']['bankName']} ****${_selectedRecipientConnectAccount!['bankAccount']['last4']}',
                              style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedRecipient = null;
                          _selectedRecipientConnectAccount = null;
                        });
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              if (_availableRecipients.isNotEmpty)
                ...(_availableRecipients.map(
                  (recipient) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(recipient['name']),
                      subtitle: Text(recipient['email']),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _selectRecipient(recipient),
                    ),
                  ),
                ))
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orange[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'No recipients with Stripe Connect accounts found.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return PaymentMethodSelector(
      paymentMethods: _paymentMethods,
      selectedPaymentMethod: _selectedPaymentMethod,
      onSelectionChanged: (method) {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      onRefreshRequested: _loadPaymentMethods,
      isLoading: _isLoading,
    );
  }

  Widget _buildPaymentDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (\$)',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                hintText: 'What is this payment for?',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final amountText = _amountController.text;
    if (amountText.isEmpty) return const SizedBox.shrink();

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return const SizedBox.shrink();

    final amountInCents = (amount * 100).toInt();
    final commissionAmount =
        (amountInCents * _applicationFeePercent / 100).round();
    final netAmount = amountInCents - commissionAmount;

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Amount:'),
                Text('\$${(amountInCents / 100).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Platform Fee (${_applicationFeePercent.toStringAsFixed(1)}%):'),
                Text('\$${(commissionAmount / 100).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.orange[700])),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recipient Receives:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${(netAmount / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const Divider(),
            if (_selectedRecipientConnectAccount?['bankAccount'] != null) ...[
              const Text('Money will be deposited to:',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                '${_selectedRecipientConnectAccount!['bankAccount']['bankName']} ****${_selectedRecipientConnectAccount!['bankAccount']['last4']}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Account Holder: ${_selectedRecipientConnectAccount!['bankAccount']['accountHolderName']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationChecklist() {
    final amount = double.tryParse(_amountController.text);
    final hasAmount = amount != null && amount > 0;
    final hasRecipient = _selectedRecipient != null;
    final hasPaymentMethod = _selectedPaymentMethod != null;
    final hasBankAccount =
        _selectedRecipientConnectAccount?['bankAccount'] != null;

    if (hasAmount && hasRecipient && hasPaymentMethod && hasBankAccount) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  'Payment Requirements',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChecklistItem(
              'Enter payment amount',
              hasAmount,
              hasAmount
                  ? 'Amount: \$${amount.toStringAsFixed(2)}'
                  : 'Please enter amount above \$0.50',
            ),
            _buildChecklistItem(
              'Select recipient',
              hasRecipient,
              hasRecipient
                  ? 'Recipient: ${_selectedRecipient!['name']}'
                  : 'Choose who will receive the payment',
            ),
            _buildChecklistItem(
              'Select payment method',
              hasPaymentMethod,
              hasPaymentMethod
                  ? 'Card: ****${_selectedPaymentMethod!['last4']}'
                  : 'Choose which card to charge',
            ),
            if (hasRecipient)
              _buildChecklistItem(
                'Verify bank account',
                hasBankAccount,
                hasBankAccount
                    ? 'Bank: ${_selectedRecipientConnectAccount!['bankAccount']['bankName']} ****${_selectedRecipientConnectAccount!['bankAccount']['last4']}'
                    : 'Recipient needs to set up bank account',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String title, bool isComplete, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isComplete ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isComplete ? Colors.green[700] : Colors.grey[700],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isComplete ? Colors.green[600] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetailsSection() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter product or service name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _subscriptionAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (\$$_subscriptionCurrency)',
                hintText: 'Enter amount (minimum \$0.50)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _subscriptionInterval,
                    decoration: const InputDecoration(
                      labelText: 'Billing Interval',
                      border: OutlineInputBorder(),
                    ),
                    items: ['day', 'week', 'month', 'year']
                        .map((interval) => DropdownMenuItem(
                              value: interval,
                              child: Text(interval.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _subscriptionInterval = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<int>(
                    value: _subscriptionIntervalCount,
                    decoration: const InputDecoration(
                      labelText: 'Every',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(12, (index) => index + 1)
                        .map((count) => DropdownMenuItem(
                              value: count,
                              child: Text(count.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _subscriptionIntervalCount = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _trialDaysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Free Trial Period (Days)',
                hintText: 'Enter 0 for no trial period',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _subscriptionCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: ['usd', 'eur', 'gbp', 'cad', 'aud']
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _subscriptionCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment method will be charged automatically every $_subscriptionIntervalCount $_subscriptionInterval${_subscriptionIntervalCount > 1 ? 's' : ''}. You can cancel anytime.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
