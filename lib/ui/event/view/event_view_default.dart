import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';

import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/ui/event/view/attendee_grid_view.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart' as appView;
import 'package:flutter_boilerplate/ui/app/dialogs/barcode_dialog.dart';
// STARTER: import - do not remove comment
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_boilerplate/services/analytics_manager.dart';

class EventViewDefault extends StatefulWidget {
  const EventViewDefault({
    Key? key,
    required this.viewModel,
    required this.isFilter,
    required this.isTopFilter,
    this.tabIndex = 0,
  }) : super(key: key);

  final EventViewVM viewModel;
  final bool isFilter;
  final bool isTopFilter;
  final int tabIndex;

  @override
  EventViewDefaultState createState() => EventViewDefaultState();
}

class EventViewDefaultState extends State<EventViewDefault>
    with SingleTickerProviderStateMixin {
  late final WebViewController controller;
  final ScrollController _scrollController = ScrollController();
  TabController? _controller;

  final _analytics = AnalyticsManager();

  @override
  void initState() {
    super.initState();

    if (!isWeb() &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);

      final eventUrl = widget.viewModel.event.url;
      if (eventUrl.isNotEmpty) {
        String validUrl = eventUrl;
        if (!eventUrl.startsWith('http://') &&
            !eventUrl.startsWith('https://')) {
          validUrl = 'https://$eventUrl';
        }
        try {
          controller.loadRequest(Uri.parse(validUrl));
        } catch (e) {
          logError('Error loading event URL: $e');
        }
      }
    }

    if (ProjectConfig.fullWidthEntities().contains(EntityType.event)) {
      // For mobile, show only photos tab; for desktop, show all related entities
      final tabCount = 1;

      _controller = TabController(
        vsync: this,
        length: tabCount,
        initialIndex: widget.isFilter ? 0 : widget.tabIndex,
      );
    }
  }

  @override
  void didUpdateWidget(EventViewDefault oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabIndex != widget.tabIndex) {
      _controller?.index = widget.tabIndex;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  bool isEventInPast(int endTimestamp) {
    final now = DateTime.now();
    final eventEndDate =
        DateTime.fromMillisecondsSinceEpoch(endTimestamp * 1000);
    return now.isAfter(eventEndDate);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final event = viewModel.event;
    final hasUserBoughtTicket = event.orders.any(
        (order) => order.buyerDetails.email == viewModel.state.authState.email);
    final isEventPassed = isEventInPast(event.end);
    final store = StoreProvider.of<AppState>(context);

    final List<BuyerDetails> attendees =
        event.orders.map((order) => order.buyerDetails).toList();

    return DefaultTabController(
      length: 2,
      child: ViewScaffold(
        isFilter: widget.isFilter,
        entity: event,
        title: event.name,
        onBackPressed: () => viewModel.onBackPressed(),
        appBarBottom: const TabBar(
          tabs: [
            Tab(text: 'Event Details'),
            Tab(text: 'Attendees'),
          ],
        ),
        body: TabBarView(
          children: [
            Builder(
              builder: (context) {
                final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                final start = event.start;
                final fiveHoursBefore = start - 5 * 3600;
                final fourHoursAfter = start + 4 * 3600;
                String? qrCodeUrl;
                for (final order in event.orders) {
                  for (final ticket in order.issuedTickets) {
                    if (ticket.qrCodeUrl.isNotEmpty &&
                        order.buyerDetails.email ==
                            viewModel.state.authState.email) {
                      qrCodeUrl = ticket.qrCodeUrl;
                      break;
                    }
                  }
                  if (qrCodeUrl != null) break;
                }
                return Stack(
                  children: [
                    ScrollableListView(
                      children: <Widget>[
                        if (event.images?.header != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              event.images!.header,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            event.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.calendar_today),
                                    title: Text(
                                      '${formatDateTime(event.start)} - ${formatDateTime(event.end)}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  if (event.venue != null)
                                    ListTile(
                                      leading: const Icon(Icons.location_on),
                                      title: Text(
                                        '${event.venue!.name}\n${event.venue!.postalCode}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 18.0),
                              Html(data: event.description),
                            ],
                          ),
                        ),
                        // Ticket Information
                        if (event.ticketTypes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tickets',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8.0),
                                ...event.ticketTypes!.map((ticket) => Card(
                                      child: ListTile(
                                        title: Text(ticket.name),
                                        subtitle:
                                            Text(ticket.description ?? ''),
                                        trailing: Text(
                                          '£${(ticket.price / 100).toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        if (!hasUserBoughtTicket &&
                            !isEventPassed &&
                            isAuthenticated(store.state))
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  _analytics.trackPurchaseButtonClicked(
                                    eventId: widget.viewModel.event.id,
                                    price: event.ticketTypes!.isNotEmpty
                                        ? (event.ticketTypes!.first.price / 100)
                                            .toDouble()
                                        : 0.0,
                                    currency: "GBP",
                                    additionalParameters: {
                                      'event_name': event.name,
                                      'event_start':
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  event.start)
                                              .toIso8601String(),
                                      'venue_name':
                                          event.venue?.name ?? 'Unknown',
                                      'user_email':
                                          viewModel.state.authState.email,
                                      'event_status': event.status,
                                      'ticket_count':
                                          event.ticketTypes?.length ?? 0,
                                      'is_online_event': event.onlineEvent,
                                      'is_private_event': event.privateEvent,
                                    },
                                  );

                                  appView.openUrl(context,
                                      widget.viewModel.event.url, 'Buy Ticket');
                                },
                                child: const Text('Buy Ticket'),
                              ),
                            ),
                          ),
                        const SizedBox(height: 80.0),
                      ],
                    ),
                    if (!isAuthenticated(store.state))
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 24,
                        child: Center(
                          child: SizedBox(
                            width: 150,
                            height: 40,
                            child: FloatingActionButton.extended(
                              heroTag: 'loginBtn',
                              label: Text('Login',
                                  style: TextStyle(
                                    color: AppTheme.dark.text,
                                  )),
                              backgroundColor: event.themeObject?.accentColor ??
                                  AppTheme.light.primary,
                              onPressed: () {
                                store.dispatch(
                                    UpdateCurrentRoute(LoginScreen.route));
                                if (store.state.prefState.isMobile) {
                                  navigatorKey.currentState!
                                      .pushNamedAndRemoveUntil(
                                          LoginScreen.route,
                                          (Route<dynamic> route) => false);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    if (now >= fiveHoursBefore &&
                        now <= fourHoursAfter &&
                        qrCodeUrl != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 24,
                        child: Center(
                          child: SizedBox(
                            width: 180,
                            height: 44,
                            child: FloatingActionButton.extended(
                              heroTag: 'barcodeBtn',
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Show barcode'),
                              backgroundColor: event.themeObject?.accentColor ??
                                  AppTheme.light.primary,
                              onPressed: () {
                                BarcodeDialog.show(
                                  context,
                                  title: 'Barcode ticket',
                                  url: qrCodeUrl!,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            // Attendees Tab
            Builder(
              builder: (context) {
                final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                final start = event.start;
                final twentyfourHoursBefore = start - 24 * 3600;
                // Check for attendee visibility conditions
                if (!isAuthenticated(store.state)) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Please Login to view attendees",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                store.dispatch(
                                    UpdateCurrentRoute(LoginScreen.route));

                                if (store.state.prefState.isMobile) {
                                  navigatorKey.currentState!
                                      .pushNamedAndRemoveUntil(
                                          LoginScreen.route,
                                          (Route<dynamic> route) => false);
                                }
                              },
                              child: Text('Login',
                                  style: TextStyle(
                                    color: AppTheme.dark.text,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!hasUserBoughtTicket &&
                    !isEventPassed &&
                    !ProjectConfig.isTesting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Attendees become visible to ticket holders 24h before event start time",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (hasUserBoughtTicket &&
                    now < twentyfourHoursBefore &&
                    !isEventPassed &&
                    !ProjectConfig.isTesting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Attendees become visible to ticket holders 24h before event start time",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // This LayoutBuilder will provide constraints to fix the sizing issue
                  return LayoutBuilder(builder: (context, constraints) {
                    // We create a container with explicit dimensions based on the constraints
                    return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: AttendeeGridView(
                        attendees: attendees,
                        scrollController: _scrollController,
                        isEventPassed: isEventPassed,
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
