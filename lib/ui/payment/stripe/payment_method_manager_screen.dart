import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/stripe_service.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/add_payment_method_screen.dart';

class PaymentMethodManagerScreen extends StatefulWidget {
  const PaymentMethodManagerScreen({super.key});

  static const String route = '/payment_method_manager';

  @override
  _PaymentMethodManagerScreenState createState() =>
      _PaymentMethodManagerScreenState();
}

class _PaymentMethodManagerScreenState
    extends State<PaymentMethodManagerScreen> {
  final StripeService _stripeService = StripeService();
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _defaultPaymentMethodId;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _stripeService.getPaymentMethods();
      if (result['success'] == true) {
        final Map<String, dynamic> responseData = result['data'] as Map<String, dynamic>;
        final List<dynamic> methods = responseData['paymentMethods'] ?? [];
        setState(() {
          _paymentMethods = methods.map((method) => method as Map<String, dynamic>).toList();
          _defaultPaymentMethodId = responseData['defaultPaymentMethodId'];
        });
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to load payment methods';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading payment methods: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePaymentMethod(String paymentMethodId) async {
    final confirmed = await _showConfirmationDialog(
      'Delete Payment Method',
      'Are you sure you want to delete this payment method? This action cannot be undone.',
    );

    if (!confirmed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _stripeService.deletePaymentMethod(paymentMethodId);
      if (result['success'] == true) {
        await _loadPaymentMethods();
        _showSuccessSnackBar('Payment method deleted successfully');
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to delete payment method';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deleting payment method: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setDefaultPaymentMethod(String paymentMethodId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customerId = await _stripeService.getCurrentUserStripeCustomerId();

      if (customerId == null) {
        setState(() {
          _errorMessage = 'Unable to get customer ID. Please try again.';
        });
        return;
      }

      final result = await _stripeService.setDefaultPaymentMethod(
        customerId: customerId,
        paymentMethodId: paymentMethodId,
      );

      if (result['success'] == true) {
        setState(() {
          _defaultPaymentMethodId = paymentMethodId;
        });
        _showSuccessSnackBar('Default payment method updated');
      } else {
        setState(() {
          _errorMessage =
              result['error'] ?? 'Failed to set default payment method';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error setting default payment method: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> paymentMethod) {
    final card = paymentMethod['card'];
    final isDefault = _defaultPaymentMethodId == paymentMethod['id'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDefault ? Colors.green : Colors.grey[300],
          child: Icon(
            Icons.credit_card,
            color: isDefault ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Row(
          children: [
            Text('**** **** **** ${card['last4']}'),
            if (isDefault)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DEFAULT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
            '${card['brand'].toUpperCase()} • Expires ${card['exp_month']}/${card['exp_year']}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'set_default':
                _setDefaultPaymentMethod(paymentMethod['id']);
                break;
              case 'delete':
                _deletePaymentMethod(paymentMethod['id']);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!isDefault)
              const PopupMenuItem(
                value: 'set_default',
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20),
                    SizedBox(width: 8),
                    Text('Set as Default'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Payment Methods'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: _loadPaymentMethods,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
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
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading && _paymentMethods.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _paymentMethods.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.credit_card_off,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No payment methods found',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add a payment method to get started',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _navigateToAddPaymentMethod(),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Payment Method'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadPaymentMethods,
                        child: ListView.builder(
                          itemCount: _paymentMethods.length,
                          itemBuilder: (context, index) {
                            return _buildPaymentMethodCard(
                                _paymentMethods[index]);
                          },
                        ),
                      ),
          ),
          if (_isLoading && _paymentMethods.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddPaymentMethod(),
        icon: const Icon(Icons.add),
        label: const Text('Add New'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _navigateToAddPaymentMethod() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPaymentMethodScreen(),
      ),
    );

    if (result != null && result != false) {
      await _loadPaymentMethods();

      if (result is String) {
        await _setDefaultPaymentMethod(result);
      }
    }
  }
}
