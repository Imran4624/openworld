import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'order_complete_screen.dart';
import '../../redux/app/app_state.dart';
import '../../.env.dart';
import '../app/forms/credit_card_input_widget.dart';
import 'package:built_collection/built_collection.dart';
import '../../redux/event/event_actions.dart';
import '../../data/models/models.dart';
import '../../data/models/event_model_helper.dart';
import '../../ui/app/shared.dart';
import '../../services/analytics_manager.dart';
import '../../services/stripe_service.dart';
import '../../project_config.dart';

class BookEventScreen extends StatefulWidget {
  final EventEntity event;
  final double? ticketPrice;

  const BookEventScreen({
    super.key,
    required this.event,
    this.ticketPrice,
  });

  @override
  State<BookEventScreen> createState() => _BookEventScreenState();
}

class _BookEventScreenState extends State<BookEventScreen> {
  final _analytics = AnalyticsManager();
  final _stripeService = StripeService();

  int quantity = 2;
  String selectedPayment = 'Credit Card';
  Map<String, String> cardDetails = {};
  bool isCardValid = false;
  bool _isLoadingStripe = true;
  String? _stripeCustomerId;
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _stripeError;

  @override
  void initState() {
    super.initState();
    _initializeStripeCustomer();
  }

  Future<void> _initializeStripeCustomer() async {
    try {
      setState(() {
        _isLoadingStripe = true;
        _stripeError = null;
      });


      final store = StoreProvider.of<AppState>(context, listen: false);
      final authState = store.state.authState;

      final customerResult = await _stripeService.createStripeCustomer(
        email: authState.email,
        name: authState.currentUserName.isNotEmpty
            ? authState.currentUserName
            : authState.email,
        metadata: {
          'app_type': ProjectConfig.appType.name,
          'user_id': authState.currentUserId,
          'created_from': 'book_event_screen',
        },
      );


      if (customerResult['success'] == true) {
        _stripeCustomerId = customerResult['data']?['customerId'];

        await _loadPaymentMethods();
      } else {
        _stripeError = customerResult['error']?.toString() ??
            'Failed to create Stripe customer';
        logError('DEBUG: Failed to create Stripe customer: $_stripeError');
      }
    } catch (error) {
      _stripeError = error.toString();
      logError('DEBUG: Error initializing Stripe customer: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStripe = false;
        });
      }
    }
  }

  Future<void> _loadPaymentMethods() async {
    try {
      if (_stripeCustomerId == null) {
        return;
      }

      final paymentMethodsResult =
          await _stripeService.getPaymentMethods(_stripeCustomerId);


      if (paymentMethodsResult['success'] == true) {
        final methods =
            paymentMethodsResult['data']?['paymentMethods'] as List<dynamic>? ??
                [];
        _paymentMethods = methods.cast<Map<String, dynamic>>();

      } else {
        logError(
            'DEBUG: Failed to load payment methods: ${paymentMethodsResult['error']}');
      }
    } catch (error) {
      logError('DEBUG: Error loading payment methods: $error');
    }
  }

  bool _canProcessPayment() {
    if (_isLoadingStripe || _stripeError != null) {
      return false;
    }

    if (selectedPayment == 'Credit Card') {
      return isCardValid && cardDetails.isNotEmpty && _stripeCustomerId != null;
    }
    return false;
  }

  void _addCurrentUserAsAttendee(
      BuildContext context, Completer<EventEntity> completer) {
    final store = StoreProvider.of<AppState>(context);
    final authState = store.state.authState;

    final currentUserEmail = authState.email.toLowerCase();
    final isAlreadyAttendee = widget.event.orders.any(
        (order) => order.buyerDetails.email.toLowerCase() == currentUserEmail);

    if (isAlreadyAttendee) {
      completer.complete(widget.event);
      return;
    }

    final currentUserAttendee = BuyerDetails((b) => b
      ..email = authState.email
      ..firstName = authState.currentUserName
      ..lastName = ''
      ..name = authState.currentUserName.trim()
      ..phone = ''
      ..rspv = 'yes');

    final newOrder = OrderEntity((b) => b
      ..id = BaseEntity.nextId
      ..status = 'completed'
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..total = ((widget.event.price ?? 0.0) * quantity).round()
      ..currency = 'USD'
      ..buyerDetails.replace(currentUserAttendee)
      ..issuedTickets = ListBuilder()
      ..lineItems = ListBuilder());

    final updatedEvent = widget.event.rebuild((b) => b..orders.add(newOrder));

    final eventCompleter = Completer<void>();
    store.dispatch(SaveEventRequest(
      event: updatedEvent,
      completer: eventCompleter,
    ));

    eventCompleter.future.then((_) {
      logInfo('Event saved successfully, completing with updated event');
      completer.complete(updatedEvent);
    }).catchError((error) {
      logError('Failed to save event: $error');
      completer.completeError(error);
    });
  }

  String _formatEventDateTime() {
    return DateFormat('HH:mm EEEE dd MMMM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(widget.event.start));
  }

  @override
  Widget build(BuildContext context) {
    final ticketPrice = widget.event.price ?? 30.00;
    final subtotal = ticketPrice * quantity;
    const salesTax = 0.00;
    const fees = 2.00;
    final total = subtotal + salesTax + fees;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(10),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 16),
                  ),
                ),
              ),
            ),
          ),
          title: const Text(
            'Book the event',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(
                                      20)), // Updated to match ticket screen
                              gradient: (widget.event.images == null ||
                                      widget.event.images!.header.isEmpty)
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFF8C00),
                                        Color(0xFFFF6B00)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                            ),
                            child: Stack(
                              children: [
                                if (widget.event.images != null &&
                                    widget.event.images!.header.isNotEmpty)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      child: Image.network(
                                        widget.event.images!.header,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFFF8C00),
                                                  Color(0xFFFF6B00)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: List.generate(
                                30,
                                (index) => Expanded(
                                  child: Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    color: index.isEven
                                        ? Colors.grey[800]
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Event Details
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                    'NAME:', state.authState.currentUserName),
                                const SizedBox(height: 12),
                                _buildDetailRow('QTY:', quantity.toString()),
                                const SizedBox(height: 12),
                                _buildDetailRow('EVENT:', widget.event.name,
                                    isEventName: true),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                    'WHEN:', _formatEventDateTime()),
                                const SizedBox(height: 12),
                                _buildDetailRow('WHERE:',
                                    widget.event.location ?? 'Online Event'),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: -10,
                        top: 180 - 10,
                        child: Container(
                          width: 20,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        top: 180 - 10,
                        child: Container(
                          width: 20,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.withOpacity(0.15),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.12),
                      ],
                      stops: const [0.0, 0.4, 0.6, 1.0],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Event Ticket',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '\$${ticketPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                setState(() => quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Order Summary
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.withOpacity(0.15),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.12),
                      ],
                      stops: const [0.0, 0.4, 0.6, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order summary',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                          'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                          'Sales Tax', '\$${salesTax.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Fees', '\$${fees.toStringAsFixed(2)}',
                          hasInfo: true),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey.withOpacity(0.19),
                              Colors.grey.withOpacity(0.12),
                              Colors.grey.withOpacity(0.12),
                              Colors.grey.withOpacity(0.16),
                            ],
                            stops: const [0.0, 0.4, 0.6, 1.0],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.withOpacity(0.15),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.12),
                      ],
                      stops: const [0.0, 0.4, 0.6, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Your details',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'To receive booking confirmation',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]!),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Edit',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]!)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.authState.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '+880 17597 25080 | California, CA',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.withOpacity(0.15),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.08),
                        Colors.grey.withOpacity(0.12),
                      ],
                      stops: const [0.0, 0.4, 0.6, 1.0],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Choose a Payment',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 0.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.5),
                                  child: Image.asset(
                                    'assets/opw/icons/visa_card.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.credit_card, size: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 0.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.5),
                                  child: Image.asset(
                                    'assets/opw/icons/master_card.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.credit_card, size: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 0.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.5),
                                  child: Image.asset(
                                    'assets/opw/icons/american_express.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.credit_card, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildPaymentOption(
                              icon: Icons.credit_card,
                              label: 'Credit Card',
                              isSelected: selectedPayment == 'Credit Card',
                              onTap: () => setState(
                                  () => selectedPayment = 'Credit Card'),
                            ),
                            _buildDashedDivider(),
                            _buildPaymentOption(
                              assetIcon: 'assets/opw/icons/apple_pay.png',
                              label: 'Apple Pay',
                              isSelected: selectedPayment == 'Apple Pay',
                              onTap: () =>
                                  setState(() => selectedPayment = 'Apple Pay'),
                              isComingSoon: true,
                            ),
                            _buildDashedDivider(),
                            _buildPaymentOption(
                              assetIcon: 'assets/opw/icons/google_pay.png',
                              label: 'Google Pay',
                              isSelected: selectedPayment == 'Google Pay',
                              onTap: () => setState(
                                  () => selectedPayment = 'Google Pay'),
                              isComingSoon: true,
                            ),
                            _buildDashedDivider(),
                            _buildPaymentOption(
                              assetIcon: 'assets/opw/icons/solana.png',
                              label: 'Solana',
                              isSelected: false,
                              isComingSoon: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (selectedPayment != 'Credit Card') ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$selectedPayment integration is coming soon. Please use Credit Card for now.',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (selectedPayment == 'Credit Card') ...[
                  const SizedBox(height: 24),
                  if (_isLoadingStripe) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(strokeWidth: 2),
                          const SizedBox(height: 12),
                          Text(
                            'Initializing payment system...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (_stripeCustomerId != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Customer: ${_stripeCustomerId!.substring(0, 12)}...',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else if (_stripeError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade700,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Payment system error',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _stripeError!,
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _initializeStripeCustomer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Retry',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    if (_paymentMethods.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_paymentMethods.length} saved payment method${_paymentMethods.length == 1 ? '' : 's'} available',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    CreditCardInputWidget(
                      isTestMode: !Config.PAYMENT_ENABLED,
                      onCardDetailsChanged: (details) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              cardDetails = details;
                            });
                          }
                        });
                      },
                      onValidationChanged: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              isCardValid = cardDetails.isNotEmpty &&
                                  cardDetails['number']?.isNotEmpty == true &&
                                  cardDetails['cvc']?.isNotEmpty == true &&
                                  cardDetails['name']?.isNotEmpty == true;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canProcessPayment()
                        ? () {
                            _processPayment(context, total);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canProcessPayment()
                          ? Colors.black
                          : Colors.grey[600]!,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'PAY \$${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double total) {
    final store = StoreProvider.of<AppState>(context);
    final ticketPrice = widget.ticketPrice ?? 30.00;

    if (selectedPayment == 'Credit Card' && !isCardValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid card details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Processing payment of \$${total.toStringAsFixed(2)}...'),
              const SizedBox(height: 8),
              Text(
                selectedPayment == 'Credit Card'
                    ? (Config.PAYMENT_ENABLED
                        ? 'Processing with your card: **** **** **** ${cardDetails['number']?.substring(cardDetails['number']!.length - 4) ?? ''}'
                        : 'Using test card: **** **** **** 4242')
                    : 'Processing with $selectedPayment',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );

    _processOneTimePayment(context, total, ticketPrice, store);
  }

  void _processOneTimePayment(BuildContext context, double total,
      double ticketPrice, Store<AppState> store) async {
    try {
      final stripeService = StripeService();
      final amountInCents = (total * 100).toInt();

      final stripeAccount =
          ProjectConfig.appType == AppType.opw ? 'kIrjKcF0cgZlLM4D1KqCznEioaE3' : null;

      final metadata = {
        'event_id': widget.event.id,
        'event_name': widget.event.name,
        'event_description': widget.event.description,
        'event_location': widget.event.location ?? 'Online Event',
        'event_start':
            DateTime.fromMillisecondsSinceEpoch(widget.event.start).toString(),
        'event_end':
            DateTime.fromMillisecondsSinceEpoch(widget.event.end).toString(),
        'quantity': quantity.toString(),
        'payment_method': selectedPayment,
        'customer_email': store.state.authState.email,
        'customer_phone': '+880 17597 25080',
        'ticket_price': ticketPrice.toString(),
        'total_amount': total.toString(),
        'app_type': 'opw',
        'payment_type': 'event_ticket',
        if (stripeAccount != null) 'stripe_account': stripeAccount,
        if (_stripeCustomerId != null) 'stripe_customer_id': _stripeCustomerId!,
      };

      String? paymentMethodId;
      if (selectedPayment == 'Credit Card') {
        if (Config.PAYMENT_ENABLED && _stripeCustomerId != null) {
          paymentMethodId = cardDetails['payment_method_id'] ??
              'pm_card_visa'; 

          if (cardDetails['payment_method_id'] == null &&
              cardDetails['number']?.isNotEmpty == true) {
            logInfo('DEBUG: Need to create payment method from card details');
            paymentMethodId = 'pm_card_visa';
          }
        } else {
          paymentMethodId = 'pm_card_visa'; 
        }
      }

      final result = await stripeService.processOneTimePayment(
        amount: amountInCents,
        currency: 'usd',
        paymentMethod: paymentMethodId ?? 'pm_card_visa',
        description: 'Event Ticket - ${widget.event.name}',
        metadata: metadata,
        stripeAccount: stripeAccount,
        applicationFeePercent:
            stripeAccount != null ? 10.0 : null, 
      );

      Navigator.of(context).pop(); 

      if (result['success'] == true) {
        final transactionId = result['data']?['paymentIntentId'] ??
            DateTime.now().millisecondsSinceEpoch.toString();

        _analytics.trackTicketPurchaseCompleted(
          eventId: widget.event.id,
          transactionId: transactionId,
          price: total,
          quantity: quantity,
          currency: "USD",
          additionalParameters: {
            'event_name': widget.event.name,
            'payment_method': selectedPayment,
            'venue_name': widget.event.venue?.name ?? 'Unknown',
            'user_email': store.state.authState.email,
            'event_start':
                DateTime.fromMillisecondsSinceEpoch(widget.event.start)
                    .toIso8601String(),
            'payment_provider': 'stripe_direct',
          },
        );

        final attendeeCompleter = Completer<EventEntity>();
        _addCurrentUserAsAttendee(context, attendeeCompleter);

        attendeeCompleter.future.then((updatedEvent) {
          final store = StoreProvider.of<AppState>(context);
          final authState = store.state.authState;
          final buyerName = authState.currentUserName.trim();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderCompleteScreen(
                event: updatedEvent,
                buyerName: buyerName.isNotEmpty ? buyerName : 'Event Attendee',
                quantity: quantity,
                currentUserEmail: authState.email.toLowerCase(),
              ),
            ),
          );
        }).catchError((error) {
          logError('DEBUG: Failed to add attendee: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add attendee: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        logError('DEBUG: Payment failed with result: $result');
        final errorMessage =
            result['error']?.toString() ?? 'Payment failed for unknown reason';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      logError('DEBUG: Exception in _processOneTimePayment: $error');
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value,
      {bool isEventName = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isEventName ? Colors.white : Colors.white60,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool hasInfo = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[600]),
            ),
            if (hasInfo) ...[
              const SizedBox(width: 4),
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
            ],
          ],
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    IconData? icon,
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
    bool isComingSoon = false,
    String? customIcon,
    Color? iconColor,
    String? assetIcon,
    Color? backgroundColor,
  }) {
    return InkWell(
      onTap: isComingSoon ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: assetIcon != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: assetIcon.contains('google_pay')
                          ? Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                assetIcon,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.credit_card,
                                      size: 20, color: Colors.black54),
                                ),
                              ),
                            )
                          : Image.asset(
                              assetIcon,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.credit_card,
                                    size: 20, color: Colors.black54),
                              ),
                            ),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: backgroundColor ?? Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: icon != null
                            ? Icon(icon, size: 20, color: Colors.black54)
                            : customIcon != null
                                ? Text(
                                    customIcon,
                                    style: TextStyle(
                                      color: iconColor ?? Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )
                                : const Icon(Icons.payment, size: 20),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (isComingSoon)
              Text(
                'coming soon',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              )
            else
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: Colors.black,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(
          50,
          (index) => Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              color: index.isEven ? Colors.grey[300] : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
