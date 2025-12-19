import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/payment_method_manager_screen.dart';

class PaymentMethodSelector extends StatefulWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final Map<String, dynamic>? selectedPaymentMethod;
  final Function(Map<String, dynamic>?) onSelectionChanged;
  final VoidCallback onRefreshRequested;
  final bool isLoading;

  const PaymentMethodSelector({
    Key? key,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.onSelectionChanged,
    required this.onRefreshRequested,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: widget.isLoading ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodManagerScreen(),
                      ),
                    ).then((_) => widget.onRefreshRequested());
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Card'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (widget.paymentMethods.isNotEmpty) ...[
              ...widget.paymentMethods.map(
                (method) => Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  color: widget.selectedPaymentMethod?['paymentMethodId'] ==
                          method['paymentMethodId']
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.credit_card,
                      color: widget.selectedPaymentMethod?['paymentMethodId'] ==
                              method['paymentMethodId']
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text('•••• •••• •••• ${method['last4'] ?? ''}'),
                    subtitle: Text(
                        '${method['brand']?.toString().toUpperCase() ?? 'Card'} • Expires ${method['expMonth']}/${method['expYear']}'),
                    trailing: widget.selectedPaymentMethod?['paymentMethodId'] ==
                            method['paymentMethodId']
                        ? Icon(
                            Icons.check_circle, 
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      widget.onSelectionChanged(method);
                    },
                  ),
                ),
              ),
            ] else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.credit_card_off,
                      color: Colors.orange,
                      size: 48,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No payment methods available',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Please add a card to continue with the payment',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.center,
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
