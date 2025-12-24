import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_model_helper.dart';
import '../../data/models/entities.dart';
import '../../project_config.dart';

class TicketData {
  final EventEntity event;
  final OrderEntity? order;

  TicketData({
    required this.event,
    this.order,
  });
}

class TicketScreen extends StatefulWidget {
  static const String route = '/ticket_screen';
  
  final List<EventEntity> events;
  final String currentUserEmail;

  const TicketScreen({
    super.key,
    required this.events,
    required this.currentUserEmail,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late PageController _pageController;
  late ScrollController _dotScrollController;
  final List<TicketData> _tickets = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _dotScrollController = ScrollController();
    _loadTickets();
  }

  void _scrollDotIntoView(int index) {
    if (_dotScrollController.hasClients) {
      const double dotSize = 12.0;
      const double dotSpacing = 8.0;
      final double dotPosition = index * (dotSize + dotSpacing);
      
      _dotScrollController.animateTo(
        dotPosition - 50, 
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _loadTickets() {
    _tickets.clear();
    
    for (final event in widget.events) {
      try {
        if (event.orders.isNotEmpty) {
          final userOrders = event.orders.where((order) =>
              order.buyerDetails.email.toLowerCase() == widget.currentUserEmail.toLowerCase());
          
          for (final order in userOrders) {
            _tickets.add(TicketData(event: event, order: order));
          }
        }
      } catch (e) {
        logError('Error processing event ${event.id}: $e');
        continue;
      }
    }
    
    try {
      _tickets.sort((a, b) => b.event.start.compareTo(a.event.start));
    } catch (e) {
      logError('Error sorting tickets: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dotScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTicketScaffold();
  }

  Widget _buildTicketScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _tickets.length > 1 ? 'My Tickets' : 'My Ticket',
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 30),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.pop(context),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _tickets.isEmpty
          ? _buildEmptyState()
          : _tickets.length == 1
              ? _buildSingleTicket(_tickets.first)
              : _buildMultipleTickets(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Tickets Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You don\'t have any tickets yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleTicket(TicketData ticketData) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
          vertical: 20.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
            ),
            child: _buildTicketCard(ticketData),
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleTickets() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _scrollDotIntoView(index);
            },
            itemCount: _tickets.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildTicketCard(_tickets[index]),
              );
            },
          ),
        ),
        if (_tickets.length > 1)
          Container(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardMaxWidth = constraints.maxWidth - 40.0; 
                const dotWidth = 12.0;
                const dotSpacing = 8.0; 
                final totalDotsWidth = (_tickets.length * dotWidth) + 
                                     ((_tickets.length - 1) * dotSpacing);
                if (totalDotsWidth > cardMaxWidth) {
                  return SizedBox(
                    height: 10.0,
                    width: cardMaxWidth,
                    child: SingleChildScrollView(
                      controller: _dotScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildDotIndicators(),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: cardMaxWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildDotIndicators(),
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  List<Widget> _buildDotIndicators() {
    return List.generate(
      _tickets.length,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width:  4.0,
        height: 4.0,
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Colors.black
              : Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  Widget _buildTicketCard(TicketData ticketData) {
    final buyer = ticketData.order?.buyerDetails;
    final event = ticketData.event;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isSmallScreen ? screenWidth - 32 : 500,
      ),
      decoration: BoxDecoration(
        color: Colors.black, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: isSmallScreen ? 200 : 260, 
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: (event.images != null && event.images!.header.isNotEmpty)
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (event.images != null && event.images!.header.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network(
                          event.images!.header,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    30, 
                    (index) => Expanded(
                      child: Container(
                        height: 2,
                        color: index.isEven ? Colors.grey[800] : Colors.transparent, 
                      ),
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width > 600 ? 32.0 : 20.0,
                ), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (buyer != null && buyer.firstName.isNotEmpty) 
                      _buildTicketDetailRow('NAME:', '${buyer.firstName} ${buyer.lastName}')
                    else
                      _buildTicketDetailRow('NAME:', widget.currentUserEmail.split('@')[0]),
                    const SizedBox(height: 16),
                    
                    _buildTicketDetailRow('QTY:', '1'),
                    const SizedBox(height: 16),
                    
                    _buildTicketDetailRow('EVENT:', event.name, isEventName: true),
                    const SizedBox(height: 16),
                    
                    _buildTicketDetailRow('WHEN:', DateFormat('HH:mm EEEE dd MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(event.start * 1000))),
                    const SizedBox(height: 16),
                    
                    _buildTicketDetailRow('WHERE:', event.location ?? event.venue?.name ?? 'Online Event'),
                    const SizedBox(height: 32),
                    
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width > 600 ? 150 : 120,
                        height: MediaQuery.of(context).size.width > 600 ? 150 : 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: QrImageView(
                          data: ProjectConfig.getEntityDetailUrl(EntityType.event, event.id),
                          version: QrVersions.auto,
                          size: MediaQuery.of(context).size.width > 600 ? 150.0 : 120.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                  ],
                ),
              ),
            ],
          ),
          
          Positioned(
            left: -10,
            top: isSmallScreen ? 260 - 10 : 320 - 10, 
            child: Container(
              width: 20,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Positioned(
            right: -10,
            top: isSmallScreen ? 260 - 10 : 320 - 10, 
            child: Container(
              width: 20,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailRow(String label, String value, {bool isEventName = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width > 600 ? 80 : 60,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white60,
              fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isEventName ? Colors.white : Colors.white60, 
              fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
            ),
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
