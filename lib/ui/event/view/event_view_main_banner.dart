import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/utils/font_utils.dart';

class EventViewMainBanner extends StatelessWidget {
  const EventViewMainBanner({
    super.key,
    required this.viewModel,
  });

  final EventViewVM viewModel;

  String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final event = viewModel.event;
    final theme = Theme.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final imageUrl = event.images?.header != null && event.images?.header != ''
        ? event.images?.header
        : ProjectConfig.defaultEntityImage(EntityType.event);

    final isGuest = state.authState.originator == OriginatorType.guest.value;

    if (isGuest) {
      return _buildGuestLayout(context, event, theme, imageUrl);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      color: Colors.black.withOpacity(0.45),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[300]),
            )
          ] else
            SizedBox.expand(
              child: Image.asset(
                ProjectConfig.defaultEntityImage(EntityType.event),
                fit: BoxFit.cover,
              ),
            ),
          Container(
            color: Colors.black.withOpacity(0.45),
          ),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatDate(event.start),
                          style: FontUtils.getTextStyleWithFont(
                            fontFamily: 'Outfit',
                            baseStyle: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ) ??
                                const TextStyle(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          event.name,
                          style: FontUtils.getTextStyleWithFont(
                            fontFamily:
                                event.themeObject?.fontFamily ?? event.font,
                            theme: event.themeObject,
                            textType: TextFieldType.name,
                            baseStyle: theme.textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 12,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ) ??
                                const TextStyle(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        if (event.venue != null && event.venue!.name != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '${event.venue!.name}${event.venue!.postalCode != null && event.venue!.postalCode!.isNotEmpty ? ',  ${event.venue!.postalCode!}' : ''}',
                                  style: FontUtils.getTextStyleWithFont(
                                    fontFamily: 'Outfit',
                                    baseStyle:
                                        theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 8,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ) ??
                                            const TextStyle(),
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        if ((event.description).isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            event.description,
                            style: FontUtils.getTextStyleWithFont(
                              fontFamily: 'Outfit',
                              baseStyle: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8,
                                        color: Colors.black.withOpacity(0.7),
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ) ??
                                  const TextStyle(),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestLayout(
      BuildContext context, dynamic event, ThemeData theme, String? imageUrl) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              if (isWideScreen) {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildEventImage(imageUrl),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildEventDetails(context, event, theme,
                          isMobile: false),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: (constraints.maxHeight * 0.5),
                      width: double.infinity,
                      child: _buildEventImage(imageUrl),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: (constraints.maxHeight * 0.5),
                        child: Center(
                          child: _buildEventDetails(context, event, theme,
                              isMobile: true),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage(String? imageUrl) {
    return Container(
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            )
          : Image.asset(
              ProjectConfig.defaultEntityImage(EntityType.event),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  Widget _buildEventDetails(
      BuildContext context, EventEntity event, ThemeData theme,
      {bool isMobile = false}) {
    final backgroundColor =
        event.themeObject?.detailBackgroundColor ?? Colors.lightBlue[100]!;

    final textColor =
        event.themeObject?.onDetailBackgroundColor ?? Colors.white;

    final accentColor = event.themeObject?.accentColor ?? Colors.orange;

    return Container(
      padding: EdgeInsets.all(isMobile ? 6.0 : 24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 2,
              right: 2,
              top: 11,
            ),
            child: Text(
              formatDate(event.start),
              style: FontUtils.getTextStyleWithFont(
                fontFamily: 'Outfit',
                baseStyle: theme.textTheme.labelMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: isMobile ? 8 : 10,
                    ) ??
                    const TextStyle(),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 2 : 10),
          Text(
            event.name,
            style: FontUtils.getTextStyleWithFont(
              fontFamily: event.themeObject?.fontFamily ?? event.font,
              theme: event.themeObject,
              textType: TextFieldType.name,
              baseStyle: theme.textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontSize: isMobile ? 38 : 40,
                  ) ??
                  const TextStyle(),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: isMobile ? 2 : 6),
          if (event.venue != null && event.venue!.name != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: isMobile
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: accentColor,
                    size: isMobile ? 14 : 18,
                  ),
                  SizedBox(width: isMobile ? 4 : 8),
                  Flexible(
                    child: Text(
                      '${event.venue!.name}${event.venue!.postalCode != null && event.venue!.postalCode!.isNotEmpty ? ', ${event.venue!.postalCode}' : ''}',
                      style: FontUtils.getTextStyleWithFont(
                        fontFamily: 'Outfit',
                        baseStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w500,
                              fontSize: isMobile ? 8 : 10,
                            ) ??
                            const TextStyle(),
                      ),
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          if (event.description.isNotEmpty) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    event.description,
                    style: FontUtils.getTextStyleWithFont(
                      fontFamily: 'Outfit',
                      baseStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            fontSize: isMobile ? 8 : 10,
                          ) ??
                          const TextStyle(),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                  _buildAttendeesSection(event, textColor, isMobile),
                ],
              ),
            ),
          ] else
            _buildAttendeesSection(event, textColor, isMobile),
        ],
      ),
    );
  }

  Widget _buildAttendeesSection(
      EventEntity event, Color textColor, bool isMobile) {
    final buyers = event.orders
        .where((order) => order.buyerDetails.email.isNotEmpty)
        .map((order) => order.buyerDetails)
        .toList();

    if (buyers.isEmpty) return const SizedBox.shrink();

    final maxAvatars = isMobile ? 5 : 6;
    final displayBuyers = buyers.take(maxAvatars).toList();

    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 2 : 16),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (!isMobile) ...[
            Text(
              '${buyers.length} People shared',
              style: FontUtils.getTextStyleWithFont(
                fontFamily: 'Outfit',
                baseStyle: TextStyle(
                  fontSize: isMobile ? 8 : 10,
                  fontWeight: FontWeight.w400,
                ).copyWith(color: textColor),
              ),
            ),
            const SizedBox(height: 12),
            // Icons row
            _buildAttendeesIcons(
                displayBuyers, buyers.length, maxAvatars, event),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${buyers.length} People shared',
                  style: FontUtils.getTextStyleWithFont(
                    fontFamily: 'Outfit',
                    baseStyle: TextStyle(
                      fontSize: isMobile ? 8 : 10,
                      fontWeight: FontWeight.w400,
                    ).copyWith(color: textColor),
                  ),
                ),
                const SizedBox(width: 8),
                _buildAttendeesIcons(
                    displayBuyers, buyers.length, maxAvatars, event),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendeesIcons(List<dynamic> displayBuyers, int totalBuyers,
      int maxAvatars, EventEntity event) {
    List<Widget> attendeeWidgets = [];

    for (final buyer in displayBuyers) {
      String initial = '?';
      if (buyer.firstName.isNotEmpty) {
        initial = buyer.firstName[0].toUpperCase();
      } else if (buyer.lastName.isNotEmpty) {
        initial = buyer.lastName[0].toUpperCase();
      } else if (buyer.email.isNotEmpty) {
        initial = buyer.email[0].toUpperCase();
      }

      attendeeWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (totalBuyers > maxAvatars) {
      attendeeWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '+${totalBuyers - maxAvatars}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: attendeeWidgets,
    );
  }
}
