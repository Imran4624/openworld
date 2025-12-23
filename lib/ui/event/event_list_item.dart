import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/entity_state_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dismissible_entity.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    required this.user,
    required this.event,
    required this.filter,
    this.onTap,
    this.onLongPress,
    this.onCheckboxChanged,
    this.isChecked = false,
  });

  final UserEntity? user;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final EventEntity event;
  final String? filter;
  final Function(bool?)? onCheckboxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final eventUIState = uiState.eventUIState;
    final listUIState = eventUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final showCheckbox = onCheckboxChanged != null || isInMultiselect;

    final filterMatch =
        filter?.isNotEmpty == true ? event.matchesFilterValue(filter!) : null;

    return DismissibleEntity(
      userCompany: state.userCompany,
      entity: event,
      isSelected: isDesktop(context) && event.id ==
          (uiState.isEditing
              ? eventUIState.editing?.id
              : eventUIState.selectedId),
      child: ListTile(
         onTap: () =>
                    onTap != null ? onTap!() : selectEntity(entity: event),
         onLongPress: () => onLongPress != null
            ? onLongPress!()
            : selectEntity(entity: event, longPress: true),
        leading: showCheckbox
            ? IgnorePointer(
                ignoring: listUIState.isInMultiselect(),
                child: Checkbox(
                  value: isChecked,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) => onCheckboxChanged?.call(value),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              CardView(context, event),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (filterMatch != null && filterMatch.isNotEmpty)
              Text(
                filterMatch,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            EntityStateLabel(event),
          ],
        ),
      ),
    );
  }

  String formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget CardView(BuildContext context, EventEntity event) {
    return Expanded(
      // Wrap Card with Expanded to prevent overflow
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail image with date overlay
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  if (event.images?.header != null)
                    SizedBox.expand(
                      child: Image.network(
                        event.images!.header,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/boilerplate/images/defaultEventPhoto.webp',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    )
                  else
                    SizedBox.expand(
                      child: Image.asset(
                        'assets/boilerplate/images/defaultEventPhoto.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        formatDateTime(event.start),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Venue and Attendees info
                  Row(
                    children: [
                      if (event.venue != null && event.venue!.name != null) ...[
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.venue!.name!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],

                      // Attendees count
                      if (event.venue != null && event.venue!.name != null)
                        const SizedBox(width: 16),
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${event.totalIssuedTickets} attending',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
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
