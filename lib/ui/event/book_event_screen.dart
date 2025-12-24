import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'order_complete_screen.dart';
import '../../redux/app/app_state.dart';
import '../../.env.dart';
import 'package:built_collection/built_collection.dart';
import '../../redux/event/event_actions.dart';
import '../../data/models/models.dart';
import '../../data/models/event_model_helper.dart';
import '../../ui/app/shared.dart';
import '../../services/analytics_manager.dart';
import '../../services/stripe_service.dart';
import '../../project_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../payment/stripe/web_stripe_elements.dart'
    if (dart.library.io) '../payment/stripe/web_stripe_elements_stub.dart';

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
  bool _isLoadingStripe = true;
  String? _stripeCustomerId;
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _stripeError;

  bool _useStripeElements = !kIsWeb;
  bool _webElementsReady = false;
  CardFieldInputDetails? _cardFieldDetails;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeStripe();
    _initializeUserData();

    _nameController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeStripeCustomer();
      }
    });
  }

  Future<void> _initializeStripe() async {
    if (kIsWeb) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final initResult = WebStripeElements.initializeStripeForWeb(
            Config.STRIPE_PUBLISHABLE_KEY);
        if (initResult == true) {
          setState(() {
            _useStripeElements = true;
          });

          await Future.delayed(const Duration(milliseconds: 1500));

          if (mounted) {
            setState(() {
              _webElementsReady = true;
            });
          }
        } else {
          logError('DEBUG: Failed to initialize Stripe for web');
          setState(() {
            _stripeError = _getFriendlyErrorMessage(
                'Failed to initialize Stripe for web payments');
          });
        }
      } catch (e) {
        logError('Error initializing Stripe for web: $e');
        setState(() {
          _stripeError =
              _getFriendlyErrorMessage('Stripe initialization failed for web');
        });
      }
      return;
    }

    if (Stripe.publishableKey.isEmpty) {
      logError('DEBUG: Stripe publishable key is not set or empty');
      if (mounted) {
        setState(() {
          _useStripeElements = false;
          _stripeError =
              _getFriendlyErrorMessage('Stripe publishable key not configured');
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _useStripeElements = true;
      });
    }
  }

  String _getFriendlyErrorMessage(String technicalError) {
    if (technicalError.contains('firebase_functions/not-found') ||
        technicalError.contains('NOT_FOUND')) {
      return 'Payment service temporarily unavailable. Please try again later.';
    } else if (technicalError.contains('network') ||
        technicalError.contains('connection') ||
        technicalError.contains('timeout')) {
      return 'Network connection issue. Please check your internet and try again.';
    } else if (technicalError.contains('permission') ||
        technicalError.contains('unauthorized')) {
      return 'Payment authentication failed. Please try again.';
    } else if (technicalError.contains('Stripe not available') ||
        technicalError.contains('initialization failed')) {
      return 'Payment system is initializing. Please wait a moment and try again.';
    } else if (technicalError.contains('invalid') ||
        technicalError.contains('validation')) {
      return 'Invalid payment information. Please check your details.';
    } else {
      return 'Payment system temporarily unavailable. Please try again later.';
    }
  }

  Future<void> _initializeUserData() async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final authState = store.state.authState;
    _nameController.text =
        authState.currentUserName.isNotEmpty ? authState.currentUserName : '';
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
        String technicalError = customerResult['error']?.toString() ??
            'Failed to create Stripe customer';
        _stripeError = _getFriendlyErrorMessage(technicalError);
        logError('DEBUG: Failed to create Stripe customer: $technicalError');
      }
    } catch (error) {
      String technicalError = error.toString();
      _stripeError = _getFriendlyErrorMessage(technicalError);
      logError('DEBUG: Error initializing Stripe customer: $technicalError');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStripe = false;
        });
      }
    }
  }

  Future<void> _loadPaymentMethods() async {
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
      }
    
  }

  bool _canProcessPayment() {
    if (_isLoadingStripe || _stripeError != null) {
      return false;
    }

    if (selectedPayment == 'Credit Card') {
      if (_stripeCustomerId == null || _nameController.text.trim().isEmpty) {
        return false;
      }

      if (kIsWeb) {
        return _useStripeElements && _webElementsReady;
      } else {
        return _useStripeElements
            ? (_cardFieldDetails != null && _cardFieldDetails!.complete)
            : false;
      }
    }
    return false;
  }

  String _getPaymentButtonText(double total) {
    if (_isLoadingStripe) {
      return 'LOADING...';
    }

    if (_stripeError != null) {
      return 'PAYMENT UNAVAILABLE';
    }

    if (_stripeCustomerId == null) {
      return 'SETTING UP PAYMENT...';
    }

    if (_nameController.text.trim().isEmpty) {
      return 'ENTER NAME TO PAY';
    }

    if (kIsWeb && !_webElementsReady) {
      return 'LOADING PAYMENT FORM...';
    }

    if (!kIsWeb &&
        _useStripeElements &&
        (_cardFieldDetails == null || !_cardFieldDetails!.complete)) {
      return 'ENTER CARD DETAILS';
    }
    return 'PAY \$${total.toStringAsFixed(0)}';
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
      ..total = (_getEventPrice(widget.event) * quantity).round()
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
      completer.complete(updatedEvent);
    }).catchError((error) {
      completer.completeError(error);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatEventDateTime() {
    return DateFormat('HH:mm EEEE dd MMMM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(widget.event.start * 1000));
  }

  @override
  Widget build(BuildContext context) {
    final ticketPrice = _getEventPrice(widget.event);
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.authState.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                            'Unable to connect to payment system',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _stripeError!,
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _initializeStripeCustomer,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text(
                                  'Try Again',
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
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
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_useStripeElements && !kIsWeb) ...[
                      const Text(
                        'Card Information',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                    ] else if (!_useStripeElements && !kIsWeb) ...[
                      const Text(
                        'Card Information',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          border: Border.all(color: Colors.orange[200]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning,
                                color: Colors.orange[700], size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Stripe Elements unavailable. Please try manual input or contact support.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Card Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.credit_card),
                              hintText: '1234 5678 9012 3456',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'MM/YY',
                                    border: OutlineInputBorder(),
                                    hintText: '12/25',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'CVC',
                                    border: OutlineInputBorder(),
                                    hintText: '123',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else if (kIsWeb) ...[
                      const Text(
                        'Card Information',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                            Icon(Icons.security,
                                color: Colors.blue[700], size: 16),
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
                    ],
                    const SizedBox(height: 16),
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
                      _getPaymentButtonText(total),
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

    if (!_canProcessPayment()) {
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
                        ? 'Processing with your card ending in ****'
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

      final stripeAccount = ProjectConfig.appType == AppType.opw
          ? 'OfSNdPFlQ9XgR6OtVXHjugY7rY42'
          : null;

      final metadata = {
        'event_id': widget.event.id,
        'event_name': widget.event.name,
        'event_description': widget.event.description,
        'event_location': widget.event.location,
        'event_start':
            DateTime.fromMillisecondsSinceEpoch(widget.event.start * 1000).toString(),
        'event_end':
            DateTime.fromMillisecondsSinceEpoch(widget.event.end * 1000).toString(),
        'quantity': quantity.toString(),
        'payment_method': selectedPayment,
        'customer_email': store.state.authState.email,
        'customer_phone': '',
        'ticket_price': ticketPrice.toString(),
        'total_amount': total.toString(),
        'app_type': 'opw',
        'payment_type': 'event_ticket',
        if (stripeAccount != null) 'stripe_account': stripeAccount,
        if (_stripeCustomerId != null) 'stripe_customer_id': _stripeCustomerId!,
      };

      String? paymentMethodId;
      if (selectedPayment == 'Credit Card') {
        if (_stripeCustomerId != null) {
          try {
            if (kIsWeb) {
              if (!_webElementsReady) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Payment form is still loading. Please wait a moment and try again.'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final billingDetails = {
                'name': _nameController.text.trim(),
                'email': store.state.authState.email,
              };

              final extractResult =
                  await WebStripeElements.extractCardDataForCloudFunction(
                      billingDetails);

              final bool success = extractResult['success'] == true;
              final String? error = extractResult['error'];
              final dynamic token = extractResult['token'];
              final dynamic paymentMethod = extractResult['paymentMethod'];

              if (!success) {
                Navigator.of(context).pop(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(error ?? 'Failed to process card information'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Map<String, dynamic> paymentData = {
                'billingDetails': billingDetails,
              };

              if (paymentMethod != null) {
                paymentData['paymentMethodId'] = paymentMethod['id'];
              } else if (token != null) {
                final String? tokenId = token['id']?.toString();
                if (tokenId != null && tokenId.isNotEmpty) {
                  paymentData['token'] = tokenId;
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid payment data received'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No valid payment data received'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final cloudResult =
                  await stripeService.createPaymentMethod(paymentData);

              if (cloudResult['success'] == true) {
                paymentMethodId = cloudResult['data']?['id'] ??
                    cloudResult['data']?['paymentMethodId'];
              } else {
                String technicalError =
                    cloudResult['error']?.toString() ?? 'Unknown error';
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_getFriendlyErrorMessage(
                        'Failed to create payment method: $technicalError')),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            } else {
              if (_cardFieldDetails == null || !_cardFieldDetails!.complete) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter complete card information'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final paymentMethod = await Stripe.instance.createPaymentMethod(
                params: PaymentMethodParams.card(
                  paymentMethodData: PaymentMethodData(
                    billingDetails: BillingDetails(
                      name: _nameController.text.trim(),
                      email: store.state.authState.email,
                    ),
                  ),
                ),
              );

              final result = await stripeService.createPaymentMethod({
                'paymentMethodId': paymentMethod.id,
                'billingDetails': {
                  'name': _nameController.text.trim(),
                  'email': store.state.authState.email,
                },
              });

              if (result['success'] == true) {
                paymentMethodId =
                    result['data']?['paymentMethodId'] ?? paymentMethod.id;
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed to attach payment method: ${result['error']?.toString() ?? 'Unknown error'}'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            }
          } catch (error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Payment method creation failed: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please ensure customer is set up'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (paymentMethodId == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _getFriendlyErrorMessage('Failed to create payment method')),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final result = await stripeService.processOneTimePayment(
        amount: amountInCents,
        currency: 'usd',
        paymentMethod: paymentMethodId,
        description: 'Event Ticket - ${widget.event.name}',
        metadata: metadata,
        stripeAccount: stripeAccount,
        applicationFeePercent: stripeAccount != null ? 10.0 : null,
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
                DateTime.fromMillisecondsSinceEpoch(widget.event.start * 1000)
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
      String technicalError = error.toString();
      logError('DEBUG: Exception in _processOneTimePayment: $technicalError');
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(_getFriendlyErrorMessage('Payment error: $technicalError')),
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

  double _getEventPrice(EventEntity event) {
    final priceFromGetter = event.price;
    final priceFromDynamicFields = event.dynamicFields['price'];
    
    final price = priceFromGetter ?? priceFromDynamicFields;
    
    if (price == null) return 0.0;
    
    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else {
      return 0.0;
    }
  }
}
