import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/app_border.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_main_banner.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/photo/photo_screen_vm.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

class EventOverview extends StatelessWidget {
  const EventOverview({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final EventViewVM viewModel;
  final bool isFilter;

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
    final event = viewModel.event;
    final fields = <String?, String?>{};

    final isEventPassed = isEventInPast(event.end);
    final eventStatus = isEventPassed ? 'Completed' : 'Upcoming';

    if (event.venue != null) {
      fields['Venue'] = event.venue!.name;
      if (event.venue!.name?.isNotEmpty == true) {
        fields['Address'] = event.venue!.name;
      }
      if (event.venue!.postalCode?.isNotEmpty == true) {
        fields['Postal Code'] = event.venue!.postalCode;
      }
    }

    fields['Status'] = eventStatus;
    fields['Start Date'] = formatDateTime(event.start);
    fields['End Date'] = formatDateTime(event.end);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 345,
          child: AppBorder(
            isTop: true,
            isBottom: true,
            child: EventViewMainBanner(
                key: ValueKey(viewModel.event.id), viewModel: viewModel),
          ),
        ),
        Expanded(
          child: ScrollableListView(
            children: <Widget>[
              EventPhotosWidget(event: event, isFilter: isFilter),
            ],
          ),
        ),
      ],
    );
  }
}

class EventPhotosWidget extends StatefulWidget {
  const EventPhotosWidget({
    super.key,
    required this.event,
    required this.isFilter,
  });

  final EventEntity event;
  final bool isFilter;

  @override
  _EventPhotosWidgetState createState() => _EventPhotosWidgetState();
}

class _EventPhotosWidgetState extends State<EventPhotosWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupEventPhotoFilter();
    });
  }

  void _setupEventPhotoFilter() {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;

    if (uiState.filterEntityType != EntityType.event ||
        uiState.filterEntityId != widget.event.id) {
      store.dispatch(ClearEntitySelection(entityType: EntityType.photo));
      store.dispatch(FilterByEntity(entity: widget.event));
      store.dispatch(LoadPhotos());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: PhotoScreenBuilder(),
    );
  }
}
