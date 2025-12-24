import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import '../book_event_screen.dart';

import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

import 'package:flutter_boilerplate/ui/app/dialogs/barcode_dialog.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/request_sent_dialog.dart';
import 'package:flutter_boilerplate/ui/event/dialogs/attendees_dialog.dart';
import 'package:flutter_boilerplate/utils/files.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart' as appView;
// STARTER: import - do not remove comment
import 'package:webview_flutter/webview_flutter.dart';

class EventViewOpw extends StatefulWidget {
  const EventViewOpw({
    super.key,
    required this.viewModel,
    required this.isFilter,
    required this.isTopFilter,
    this.tabIndex = 0,
  });

  final EventViewVM viewModel;
  final bool isFilter;
  final bool isTopFilter;
  final int tabIndex;

  @override
  EventViewOpwState createState() => EventViewOpwState();
}

class EventViewOpwState extends State<EventViewOpw>
    with SingleTickerProviderStateMixin {
  late final WebViewController controller;
  final ScrollController _scrollController = ScrollController();
  TabController? _controller;
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
      keepPage: true,
    );

    if (!isWeb() &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
      
      final eventUrl = widget.viewModel.event.url;
      if (eventUrl.isNotEmpty) {
        String validUrl = eventUrl;
        if (!eventUrl.startsWith('http://') && !eventUrl.startsWith('https://')) {
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
      const tabCount = 1;

      _controller = TabController(
        vsync: this,
        length: tabCount,
        initialIndex: widget.isFilter ? 0 : widget.tabIndex,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleEventInteraction(EventOperationType.viewed);
    });
  }

  @override
  void didUpdateWidget(EventViewOpw oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabIndex != widget.tabIndex) {
      _controller?.index = widget.tabIndex;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MMMM d, yyyy').format(date);
  }

  String formatDateTimeWithRange(int startTimestamp, int? endTimestamp) {
    final startDate =
        DateTime.fromMillisecondsSinceEpoch(startTimestamp * 1000);
    final dateStr = DateFormat('MMMM d, yyyy').format(startDate);
    final startTimeStr = DateFormat('HH:mm').format(startDate);

    if (endTimestamp != null && endTimestamp > 0) {
      final endDate = DateTime.fromMillisecondsSinceEpoch(endTimestamp * 1000);
      final endTimeStr = DateFormat('HH:mm').format(endDate);
      return '$dateStr ($startTimeStr - $endTimeStr)';
    } else {
      return '$dateStr ($startTimeStr)';
    }
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

    final List<BuyerDetails> attendees =
        event.orders.map((order) => order.buyerDetails).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 160,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 12, top: 8, right: 2, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[600]?.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.back,
                          color: Colors.white70, size: 16),
                      onPressed: () {
                        viewEntitiesByType(entityType: EntityType.event);
                      },
                      splashRadius: 16,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'Event Detail',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageSlider(event),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.02),
                    Colors.black.withOpacity(0.0),
                  ],
                  stops: const [
                    0.0,
                    0.1,
                    0.2,
                    0.3,
                    0.4,
                    0.5,
                    0.65,
                    0.75,
                    0.85,
                    0.95,
                    1.0
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.eventType ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.visibility_outlined,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatViewsCount(
                                          event.views?.length ?? 0),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                height: 16,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () {
                                  _handleEventInteraction(
                                      EventOperationType.saved);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    _isUserInFavourites(event.favourites,
                                            viewModel.state.authState.email)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: _isUserInFavourites(event.favourites,
                                            viewModel.state.authState.email)
                                        ? Colors.red
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 16,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  final shareUrl = event.url.isNotEmpty
                                      ? event.url
                                      : ProjectConfig.getEntityDetailUrl(
                                          EntityType.event, event.id, originator: OriginatorType.guest);

                                  shareContent(
                                    context,
                                    shareUrl,
                                    subject:
                                        'Check out this event: ${event.name}',
                                  );
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.ios_share,
                                    size: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (event.description.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: _isDescriptionExpanded
                                          ? event.description
                                          : event.description.length > 150
                                              ? '${event.description.substring(0, 150)}... '
                                              : event.description,
                                    ),
                                    if (event.description.length > 150 &&
                                        !_isDescriptionExpanded)
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isDescriptionExpanded = true;
                                            });
                                          },
                                          child: Text(
                                            'Read more',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 12,
                                              height: 1.4,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                maxLines: _isDescriptionExpanded ? null : 3,
                                overflow: _isDescriptionExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.visible,
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        _buildEventDetailRow(
                          Icons.calendar_month,
                          formatDateTimeWithRange(
                              event.start, event.end > 0 ? event.end : null),
                        ),
                        const SizedBox(height: 4),
                        _buildEventDetailRowWithDropdown(
                          Icons.location_on,
                          event.location ?? '',
                          onTap: (event.location?.isNotEmpty == true || _getEventLocation(event) != null) 
                            ? () => _openInMaps(event) 
                            : null,
                        ),
                        const SizedBox(height: 4),
                        _buildEventDetailRow(
                          Icons.confirmation_number_outlined,
                          event.ticketType ?? 'Free',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.15),
                                  width: 0.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: _getCreatorThumbnail(event) !=
                                        null
                                    ? NetworkImage(_getCreatorThumbnail(event)!)
                                    : null,
                                backgroundColor: Colors.grey[300],
                                child: _getCreatorThumbnail(event) == null
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                        size: 24,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getCreatorName(event),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Organizer',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (_getCreatorEmail(event) != null)
                                    Text(
                                      _getCreatorEmail(event)!,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            if (_getCreatorEmail(event) != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showAttendeesDialog(
                                  context, event, attendees),
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.15),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.people,
                                          size: 16, color: Colors.black87),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${attendees.length} participants',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (attendees.isNotEmpty)
                                  SizedBox(
                                    width: attendees.length == 1
                                        ? 24
                                        : attendees.length > 3
                                            ? 80
                                            : (attendees.length * 16 + 8)
                                                .toDouble(),
                                    height: 24,
                                    child: attendees.length == 1
                                        ? CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.grey[600],
                                            child: Text(
                                              attendees.first.firstName
                                                      .isNotEmpty
                                                  ? attendees.first.firstName[0]
                                                      .toUpperCase()
                                                  : (attendees.first.email
                                                          .isNotEmpty
                                                      ? attendees.first.email[0]
                                                          .toUpperCase()
                                                      : 'A'),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              ...attendees
                                                  .take(3)
                                                  .toList()
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                final index = entry.key;
                                                final attendee = entry.value;
                                                final rightPosition =
                                                    (index * 16).toDouble();

                                                return Positioned(
                                                  right: rightPosition,
                                                  child: CircleAvatar(
                                                    radius: 12,
                                                    backgroundColor:
                                                        Colors.grey[600],
                                                    child: Text(
                                                      attendee.firstName
                                                              .isNotEmpty
                                                          ? attendee
                                                              .firstName[0]
                                                              .toUpperCase()
                                                          : (attendee.email
                                                                  .isNotEmpty
                                                              ? attendee
                                                                  .email[0]
                                                                  .toUpperCase()
                                                              : 'A'),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              if (attendees.length > 3)
                                                Positioned(
                                                  right: 48,
                                                  child: CircleAvatar(
                                                    radius: 12,
                                                    backgroundColor:
                                                        Colors.grey[600],
                                                    child: Text(
                                                      '+${attendees.length - 3}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'CHAT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _canUserJoin(widget.viewModel, event)
                                  ? () async {
                                      if (!widget.viewModel.state.authState
                                          .isAuthenticated) {
                                        viewEntitiesByType(
                                            entityType: EntityType.auth);
                                        return;
                                      }

                                      if (_isEventPaid(event)) {
                                        _navigateToBookEvent(event);
                                        return;
                                      }

                                      final userEmail = widget
                                          .viewModel.state.authState.email
                                          .toLowerCase();
                                      final userOrder = event.orders
                                          .where((order) =>
                                              order.buyerDetails.email
                                                  .toLowerCase() ==
                                              userEmail)
                                          .firstOrNull;

                                      final completer = Completer<void>();

                                      if (userOrder != null &&
                                          userOrder.buyerDetails.rspv
                                                  ?.toLowerCase() ==
                                              RSPV.request.toLowerCase()) {
                                        _removeCurrentUserFromEvent(
                                            widget.viewModel, event, completer);
                                      } else {
                                        _addCurrentUserAsAttendee(
                                            widget.viewModel, event, completer);
                                      }

                                      try {
                                        await completer.future;
                                        if (mounted) {
                                          if (userOrder != null &&
                                              userOrder.buyerDetails.rspv
                                                      ?.toLowerCase() ==
                                                  RSPV.request.toLowerCase()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Event request cancelled successfully'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } else {
                                            RequestSentDialog.show(context);
                                          }
                                        }
                                      } catch (e) {
                                        logError('Event operation failed: $e');
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getButtonBackgroundColor(
                                    widget.viewModel, event),
                                foregroundColor: widget.viewModel.state
                                        .authState.isAuthenticated
                                    ? Colors.white
                                    : Colors.grey[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _getJoinButtonText(widget.viewModel, event),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () {
                              final shareUrl = event.url.isNotEmpty
                                  ? event.url
                                  : ProjectConfig.getEntityDetailUrl(
                                      EntityType.event, event.id, originator: OriginatorType.guest);

                              shareContent(
                                context,
                                shareUrl,
                                subject: 'Check out this event: ${event.name}',
                              );
                            },
                            icon: const Icon(
                              Icons.ios_share,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: InkWell(
                        onTap: () => _showReportDialog(context, event),
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Report Event',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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

                      if (now >= fiveHoursBefore &&
                          now <= fourHoursAfter &&
                          qrCodeUrl != null) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                BarcodeDialog.show(
                                  context,
                                  title: 'Barcode ticket',
                                  url: qrCodeUrl!,
                                );
                              },
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Show barcode'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: 
                                    AppTheme.light.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(EventEntity event) {
    final List<String> sliderImages = [];

    if (event.images?.header != null && event.images!.header.isNotEmpty) {
      sliderImages.add(event.images!.header);
    }

    if (event.images?.thumbnail != null &&
        event.images!.thumbnail.isNotEmpty &&
        event.images!.thumbnail != event.images!.header) {
      sliderImages.add(event.images!.thumbnail);
    }

    if (sliderImages.isEmpty) {
      sliderImages.add('gradient1');
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          onPageChanged: (index) {
            if (mounted) {
              setState(() {
                _currentPageIndex = index;
              });
            }
          },
          itemCount: sliderImages.length,
          itemBuilder: (context, index) {
            final imageUrl = sliderImages[index];

            return Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl.startsWith('gradient'))
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: index == 0
                            ? [const Color(0xFF00BCD4), const Color(0xFF8BC34A)]
                            : index == 1
                                ? [
                                    const Color(0xFFFF6B6B),
                                    const Color(0xFFFFE66D)
                                  ]
                                : [
                                    const Color(0xFF667eea),
                                    const Color(0xFF764ba2)
                                  ],
                      ),
                    ),
                  )
                else
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00BCD4),
                              Color(0xFF8BC34A),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.0, 0.6, 0.75, 0.9, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.18),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.02),
                  Colors.black.withOpacity(0.0),
                ],
                stops: const [
                  0.0,
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.65,
                  0.75,
                  0.85,
                  0.95,
                  1.0
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  sliderImages.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPageIndex == index ? 34 : 12,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPageIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 80,
          child: GestureDetector(
            onTap: () {
              if (_currentPageIndex > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 80,
          child: GestureDetector(
            onTap: () {
              if (_currentPageIndex < sliderImages.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 0.5,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetailRowWithDropdown(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Transform.rotate(
                angle: 30 * 3.14159 / 180,
                child: Icon(
                  Icons.navigation,
                  color: onTap != null ? Colors.black87 : Colors.grey.withOpacity(0.5),
                  size: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEventInteraction(int eventOperationType) {
    final viewModel = widget.viewModel;
    final userId = viewModel.state.authState.email;

    if (userId.isEmpty) {
      return;
    }

    viewModel.onEventOperation(
      viewModel.event.id,
      userId,
      eventOperationType,
    );
  }

  String _formatViewsCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      double k = count / 1000.0;
      return k % 1 == 0 ? '${k.toInt()}k' : '${k.toStringAsFixed(1)}k';
    } else {
      double m = count / 1000000.0;
      return m % 1 == 0 ? '${m.toInt()}m' : '${m.toStringAsFixed(1)}m';
    }
  }

  bool _isUserInFavourites(List<EventInteraction>? favourites, String userId) {
    if (favourites == null || favourites.isEmpty || userId.isEmpty) {
      return false;
    }

    return favourites.any((favourite) => favourite.userId == userId);
  }

  String _getJoinButtonText(EventViewVM viewModel, EventEntity event) {
    if (!viewModel.state.authState.isAuthenticated) {
      return 'LOGIN TO JOIN';
    }

    final userEmail = viewModel.state.authState.email.toLowerCase();
    final userOrder = event.orders
        .where((order) => order.buyerDetails.email.toLowerCase() == userEmail)
        .firstOrNull;

    if (userOrder != null) {
      final rsvp = userOrder.buyerDetails.rspv?.toLowerCase() ?? '';

      if (rsvp == RSPV.yes.toLowerCase()) {
        return 'ALREADY JOINED';
      } else if (rsvp == RSPV.request.toLowerCase()) {
        return 'CANCEL REQUEST';
      }
    }

    if (_isEventPaid(event)) {
      return 'PURCHASE TICKET';
    }

    return 'REQUEST TO JOIN';
  }

  Color _getButtonBackgroundColor(EventViewVM viewModel, EventEntity event) {
    if (!viewModel.state.authState.isAuthenticated) {
      return Colors.grey[400]!;
    }

    final userEmail = viewModel.state.authState.email.toLowerCase();
    final userOrder = event.orders
        .where((order) => order.buyerDetails.email.toLowerCase() == userEmail)
        .firstOrNull;

    if (userOrder != null &&
        userOrder.buyerDetails.rspv?.toLowerCase() ==
            RSPV.request.toLowerCase()) {
      return Colors.red;
    }

    return Colors.black;
  }

  bool _canUserJoin(EventViewVM viewModel, EventEntity event) {
    if (!viewModel.state.authState.isAuthenticated) {
      return true;
    }

    final userEmail = viewModel.state.authState.email.toLowerCase();
    final userOrder = event.orders
        .where((order) => order.buyerDetails.email.toLowerCase() == userEmail)
        .firstOrNull;

    if (userOrder != null) {
      final rsvp = userOrder.buyerDetails.rspv?.toLowerCase() ?? '';

      if (rsvp == RSPV.request.toLowerCase()) {
        return true;
      }

      if (rsvp == RSPV.yes.toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  String _getCreatorName(EventEntity event) {
    final Map<String, dynamic>? createdByObj = event.createdByObj;
    if (createdByObj != null) {
      final String username = createdByObj['username']?.toString() ?? '';
      final String email = createdByObj['email']?.toString() ?? '';

      if (username.isNotEmpty) {
        return username;
      } else if (email.isNotEmpty) {
        final String emailName = email.split('@')[0];
        return emailName.replaceAll('.', ' ').replaceAll('_', ' ');
      }
    }

    return 'Unknown Organizer';
  }

  String? _getCreatorEmail(EventEntity event) {
    final String? createdUserId = event.createdUserId;
    if (createdUserId?.isNotEmpty == true) {
      final ProfileEntity? creatorProfile =
          widget.viewModel.state.profileState.map[createdUserId];
      if (creatorProfile != null) {
        return creatorProfile.email.isNotEmpty ? creatorProfile.email : null;
      }
    }

    final Map<String, dynamic>? createdByObj = event.createdByObj;
    if (createdByObj != null) {
      final String? email = createdByObj['email']?.toString();
      return email?.isNotEmpty == true ? email : null;
    }

    return null;
  }

  String? _getCreatorThumbnail(EventEntity event) {
    final String? createdUserId = event.createdUserId;
    if (createdUserId?.isNotEmpty == true) {
      final ProfileEntity? creatorProfile =
          widget.viewModel.state.profileState.map[createdUserId];
      if (creatorProfile != null) {
        final List<String> imageUrls =
            creatorProfile.dynamicFields.getImages('images');
        if (imageUrls.isNotEmpty && _isValidUrl(imageUrls.first)) {
          return imageUrls.first;
        }
      }
    }

    final Map<String, dynamic>? createdByObj = event.createdByObj;
    if (createdByObj != null) {
      final String? thumbnail = createdByObj['thumbnail']?.toString();
      if (thumbnail?.isNotEmpty == true && _isValidUrl(thumbnail!)) {
        return thumbnail;
      }
    }

    return null;
  }

  void _addCurrentUserAsAttendee(
      EventViewVM viewModel, EventEntity event, Completer<void> completer) {
    final authState = viewModel.state.authState;

    final isAlreadyAttendee = event.orders.any((order) =>
        order.buyerDetails.email.toLowerCase() ==
        authState.email.toLowerCase());

    if (isAlreadyAttendee) {
      completer.complete();
      return;
    }

    final currentUserAttendee = BuyerDetails((b) => b
      ..email = authState.email
      ..firstName = authState.currentUserName
      ..lastName = ''
      ..name = '${authState.currentUserName} '.trim()
      ..phone = ''
      ..rspv = RSPV.request);

    final newOrder = OrderEntity((b) => b
      ..id = BaseEntity.nextId
      ..status = 'completed'
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..total = 0
      ..currency = 'USD'
      ..buyerDetails.replace(currentUserAttendee)
      ..issuedTickets = ListBuilder<IssuedTicket>()
      ..lineItems = ListBuilder<LineItem>());

    final updatedEvent = event.rebuild((b) => b
      ..orders.add(newOrder)
      ..totalOrders = event.totalOrders + 1);

    StoreProvider.of<AppState>(context).dispatch(SaveEventRequest(
      event: updatedEvent,
      completer: completer,
    ));
  }

  void _removeCurrentUserFromEvent(
      EventViewVM viewModel, EventEntity event, Completer<void> completer) {
    final authState = viewModel.state.authState;
    final userEmail = authState.email.toLowerCase();

    final updatedOrders = event.orders
        .where((order) => order.buyerDetails.email.toLowerCase() != userEmail)
        .toList();

    final updatedEvent = event.rebuild((b) => b
      ..orders.replace(updatedOrders)
      ..totalOrders = updatedOrders.length);

    StoreProvider.of<AppState>(context).dispatch(SaveEventRequest(
      event: updatedEvent,
      completer: completer,
    ));
  }

  void _showAttendeesDialog(
      BuildContext context, EventEntity event, List<BuyerDetails> attendees) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AttendeesDialog(
          attendees: attendees,
          eventId: event.id,
          eventName: event.name,
          event: event,
        );
      },
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _navigateToBookEvent(EventEntity event) async {
    final eventPrice = _getEventPrice(event);
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookEventScreen(
          event: event,
          ticketPrice: eventPrice,
        ),
      ),
    );
  }

  double _getEventPrice(EventEntity event) {
    final priceFromGetter = event.price;
    final priceFromDynamicFields = event.dynamicFields['price'];
    
    final price = priceFromGetter ?? priceFromDynamicFields;
    
    if (price == null) {
      return 0.0;
    }
    
    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    
    return 0.0;
  }

  void _showReportDialog(BuildContext context, EventEntity event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final reportController = TextEditingController();
        return AlertDialog(
          title: const Text('Report Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please describe why you are reporting this event:'),
              const SizedBox(height: 16),
              TextField(
                controller: reportController,
                decoration: const InputDecoration(
                  hintText: 'Reason for reporting...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (reportController.text.trim().isNotEmpty) {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(ReportEntityRequest(
                    entityId: event.id,
                    entityType: EntityType.event,
                    comment: reportController.text.trim(),
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  Map<String, double>? _getEventLocation(EventEntity event) {
    try {
      if (event.locationData != null) {
        final lat = event.locationData!.lat;
        final lng = event.locationData!.lng;
        if (lat != 0.0 || lng != 0.0) {
          return {'lat': lat, 'lng': lng};
        }
      }
    } catch (e) {
      logError('Error parsing locationData from event.locationData: $e');
    }

    try {
      final locationDataField = event.dynamicFields['locationData'];
      if (locationDataField is Map<String, dynamic>) {
        final lat = locationDataField['lat'];
        final lng = locationDataField['lng'] ?? locationDataField['long'];
        if (lat is num && lng is num) {
          return {'lat': lat.toDouble(), 'lng': lng.toDouble()};
        }
      }
    } catch (e) {
      logError('Error parsing locationData from dynamicFields: $e');
    }

    return null;
  }

  Future<void> _openInMaps(EventEntity event) async {
    final location = _getEventLocation(event);
    if (location != null) {
      final lat = location['lat'];
      final lng = location['lng'];

      try {
        String url;

        if (kIsWeb) {
          url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        } else {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            url = 'https://maps.apple.com/?q=$lat,$lng';
          } else {
            url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
          }
        }

        appView.openUrl(context, url, 'Open in Maps');
      } catch (e) {
        logError('Error opening maps: $e');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open maps application'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      final locationText = event.location;
      if (locationText != null && locationText.isNotEmpty) {
        try {
          String url;
          final query = Uri.encodeComponent(locationText);

          if (kIsWeb) {
            url = 'https://www.google.com/maps/search/?api=1&query=$query';
          } else {
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              url = 'http://maps.apple.com/?q=$query';
            } else {
              url = 'https://www.google.com/maps/search/?api=1&query=$query';
            }
          }

          appView.openUrl(context, url, 'Open in Maps');
        } catch (e) {
          logError('Error opening maps with location text: $e');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open maps application'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No location information available'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  bool _isEventPaid(EventEntity event) {
    final priceFromGetter = event.price;
    final priceFromDynamicFields = event.dynamicFields['price'];
    
    final price = priceFromGetter ?? priceFromDynamicFields;
    
    if (price == null) {
      return false;
    }
    
    double priceValue;
    if (price is int) {
      priceValue = price.toDouble();
    } else if (price is double) {
      priceValue = price;
    } else if (price is String) {
      priceValue = double.tryParse(price) ?? 0.0;
    } else {
      return false;
    }
    
    return priceValue > 0;
  }
}
