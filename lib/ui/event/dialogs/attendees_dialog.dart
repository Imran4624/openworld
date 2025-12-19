import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/services/email_service/get_email_templates.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/notification_model.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/event/dialogs/create_attendee_dialog.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'dart:async';
import 'package:built_collection/built_collection.dart';

class AttendeesDialog extends StatefulWidget {
  const AttendeesDialog({
    Key? key,
    required this.attendees,
    required this.eventId,
    required this.eventName,
    this.event,
  }) : super(key: key);

  final List<BuyerDetails> attendees;
  final String eventId;
  final String eventName;
  final EventEntity? event;

  @override
  State<AttendeesDialog> createState() => _AttendeesDialogState();
}

class _AttendeesDialogState extends State<AttendeesDialog> {
  List<BuyerDetails> _attendees = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendees = List.from(widget.attendees);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentAttendees = List<BuyerDetails>.from(widget.attendees);
    if (_attendees.length != currentAttendees.length) {
      _attendees = currentAttendees;
    }

    if (_attendees.isNotEmpty && !_isLoading) {
      _fetchAttendeeProfiles();
    }
  }

  void _fetchAttendeeProfiles() {
    if (_attendees.isEmpty) return;

    final store = StoreProvider.of<AppState>(context);
    final completer = Completer<void>();

    store.dispatch(FetchAttendeeProfilesRequest(
      attendees: _attendees,
      completer: completer,
    ));

    setState(() {
      _isLoading = true;
    });

    completer.future.then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _addAttendee() async {
    final store = StoreProvider.of<AppState>(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return const CreateAttendeeDialog();
      },
    );

    if (result != null) {
      final newAttendee = BuyerDetails((b) => b
        ..firstName = result['name'] ?? ''
        ..lastName = ''
        ..email = result['email'] ?? ''
        ..name = result['name'] ?? ''
        ..attendeeStatus = AttendeeStatus.main
        ..phone = '');

      final htmlTemplate = await getInviteEmailTemplate(
        attendeeName: result['name'] ?? 'Guest',
        hostName: store.state.authState.currentUserName,
        eventName: widget.eventName,
        joinEventLink: ProjectConfig.getEntityDetailUrl(EntityType.event, widget.eventId),
      );

      final emailMessage = EmailMessage(
        to: result['email'],
        body: htmlTemplate,
        subject: '${store.state.authState.currentUserName} invited you to ${widget.eventName}',
      );
      store.dispatch(SendEmailAction(emailMessage: emailMessage));
      setState(() {
        _attendees.add(newAttendee);
      });

      _updateEventWithNewAttendee(newAttendee);
    }
  }

  void _updateEventWithNewAttendee(BuyerDetails newAttendee) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final currentEvent = state.eventState.map[widget.eventId];
    if (currentEvent == null) return;

    final newOrder = OrderEntity((b) => b
      ..id = BaseEntity.nextId
      ..status = 'completed'
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..total = 0
      ..currency = 'USD'
      ..buyerDetails.replace(newAttendee)
      ..issuedTickets = ListBuilder<IssuedTicket>()
      ..lineItems = ListBuilder<LineItem>());

    final updatedEvent = currentEvent.rebuild((b) => b
      ..orders.add(newOrder)
      ..totalOrders = currentEvent.totalOrders + 1);

    store.dispatch(SaveEventRequest(
      event: updatedEvent,
      completer: null, 
    ));
  }

  bool _isEventAuthor() {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    
    if (widget.event != null) {
      final isAuthor = widget.event!.createdUserId == getLoggedInUserId(store);
      return isAuthor;
    }
    
    final currentEvent = state.eventState.map[widget.eventId];
    if (currentEvent != null) {
      final isAuthor = currentEvent.createdUserId == getLoggedInUserId(store);
      return isAuthor;
    }
    
    return false;
  }

  void _acceptRequest(BuyerDetails attendee) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    
    final currentEvent = state.eventState.map[widget.eventId];
    if (currentEvent == null) return;
    
    final orderIndex = currentEvent.orders.indexWhere((order) =>
        order.buyerDetails.email.toLowerCase() == attendee.email.toLowerCase());
    
    if (orderIndex != -1) {
      final updatedOrders = List<OrderEntity>.from(currentEvent.orders);
      final updatedOrder = updatedOrders[orderIndex].rebuild((b) => b
        ..buyerDetails.replace(attendee.rebuild((a) => a
          ..attendeeStatus = AttendeeStatus.approved
          ..rspv = RSPV.yes
        ))
      );
      
      updatedOrders[orderIndex] = updatedOrder;
      
      final updatedEvent = currentEvent.rebuild((b) => b
        ..orders.replace(updatedOrders)
      );

      store.dispatch(SaveEventRequest(
        event: updatedEvent,
        completer: null,
      ));

      setState(() {
        final attendeeIndex = _attendees.indexWhere((a) => 
          a.email.toLowerCase() == attendee.email.toLowerCase());
        if (attendeeIndex != -1) {
          _attendees[attendeeIndex] = attendee.rebuild((a) => a
            ..attendeeStatus = AttendeeStatus.approved
            ..rspv = RSPV.yes
          );
        }
      });
    }
  }

  void _removeAttendee(BuyerDetails attendeeToRemove) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final currentEvent = state.eventState.map[widget.eventId];
    if (currentEvent == null) return;

    final orderToRemove = currentEvent.orders.firstWhere(
      (order) =>
          order.buyerDetails.email.toLowerCase() ==
          attendeeToRemove.email.toLowerCase(),
      orElse: () => throw Exception('Attendee not found in event'),
    );

    final updatedEvent = currentEvent.rebuild((b) => b
      ..orders.remove(orderToRemove)
      ..totalOrders = currentEvent.totalOrders - 1);

    store.dispatch(SaveEventRequest(
      event: updatedEvent,
      completer: null, 
    ));

    setState(() {
      _attendees.removeWhere((attendee) =>
          attendee.email.toLowerCase() == attendeeToRemove.email.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final isGuest = !isAuthenticated(state);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _attendees.isEmpty
                      ? (ProjectConfig.appType == AppType.opw ? 'Attendees' : 'Add Attendees')
                      : 'Attendees (${_attendees.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Row(
                  children: [
                    if (!isGuest && _attendees.isNotEmpty && ProjectConfig.appType != AppType.opw)
                      IconButton(
                        onPressed: _addAttendee,
                        icon: const Icon(Icons.person_add),
                        tooltip: 'Add Attendee',
                      ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _attendees.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                ProjectConfig.appType == AppType.opw 
                                    ? 'No attendees yet'
                                    : 'No attendees yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ProjectConfig.appType == AppType.opw
                                    ? 'Attendees will appear here once they join the event'
                                    : 'Add attendees to this event',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                              ),
                              if (!isGuest && ProjectConfig.appType != AppType.opw) ...[
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _addAttendee,
                                  icon: const Icon(Icons.person_add),
                                  label: const Text('Add Attendee'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _attendees.length,
                          itemBuilder: (context, index) {
                            final attendee = _attendees[index];
                            final isAuthor = _isEventAuthor();
                            final hasProfile = state
                                .profileState.attendeeProfileMap
                                .containsKey(attendee.email.toLowerCase());

                            if (hasProfile) {
                              final profileId =
                                  state.profileState.attendeeProfileMap[
                                          attendee.email.toLowerCase()] ??
                                      '';
                              final profile = state.profileState.map[profileId];

                              if (profile != null) {
                                return _ProfileListItem(
                                  profile: profile,
                                  attendee: attendee,
                                  isAuthor: isAuthor,
                                  onTap: () {
                                    //  selectEntity(entity: profile);
                                    //  Navigator.of(context).pop();
                                  },
                                  onAccept: () => _acceptRequest(attendee),
                                  onRemove: () => _removeAttendee(attendee),
                                  isPaidEvent: widget.event?.price != null && widget.event!.price! > 0,
                                );
                              }
                            }

                            return _AttendeeListItem(
                              attendee: attendee,
                              isAuthor: isAuthor,
                              onTap: () {
                                //  _showAttendeeDetails(attendee);
                              },
                              onAccept: () => _acceptRequest(attendee),
                              onRemove: () => _removeAttendee(attendee),
                              isPaidEvent: widget.event?.price != null && widget.event!.price! > 0,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }


}

class _ProfileListItem extends StatelessWidget {
  const _ProfileListItem({
    Key? key,
    required this.profile,
    required this.attendee,
    required this.isAuthor,
    required this.onTap,
    required this.onAccept,
    required this.onRemove,
    this.isPaidEvent = false,
  }) : super(key: key);

  final ProfileEntity profile;
  final BuyerDetails attendee;
  final bool isAuthor;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onRemove;
  final bool isPaidEvent;

  @override
  Widget build(BuildContext context) {
    final isRequestPending = attendee.attendeeStatus == AttendeeStatus.pending || 
                             attendee.rspv?.toLowerCase() == RSPV.request.toLowerCase();
    final isAccepted = attendee.attendeeStatus == AttendeeStatus.approved || 
                      attendee.rspv?.toLowerCase() == RSPV.yes.toLowerCase();
    final isOwner = attendee.attendeeStatus == AttendeeStatus.owner;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'P',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(profile.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile.email),
            if (isOwner)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Owner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (isRequestPending)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Pending Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (isAccepted)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Accepted',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: isAuthor && !isOwner
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isRequestPending) ...[
                    IconButton(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Accept Request',
                    ),
                  ],
                  if (!isPaidEvent) ...[
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      tooltip: 'Remove Attendee',
                    ),
                  ],
                ],
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Colors.green),
                ],
              ),
        onTap: onTap,
      ),
    );
  }
}

class _AttendeeListItem extends StatelessWidget {
  const _AttendeeListItem({
    Key? key,
    required this.attendee,
    required this.isAuthor,
    required this.onTap,
    required this.onAccept,
    required this.onRemove,
    this.isPaidEvent = false,
  }) : super(key: key);

  final BuyerDetails attendee;
  final bool isAuthor;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onRemove;
  final bool isPaidEvent;

  @override
  Widget build(BuildContext context) {
    final String fullName = '${attendee.firstName} ${attendee.lastName}';
    
    String statusText = '';
    Color statusColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    
    if (attendee.attendeeStatus == AttendeeStatus.pending) {
      statusText = 'Pending';
      statusColor = Colors.orange;
    } else if (attendee.attendeeStatus == AttendeeStatus.approved) {
      statusText = 'Approved';
      statusColor = Colors.green;
    } else if (attendee.attendeeStatus == AttendeeStatus.rejected) {
      statusText = 'Rejected';
      statusColor = Colors.red;
    } else if (attendee.attendeeStatus == AttendeeStatus.owner) {
      statusText = 'Owner';
      statusColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(child: Text(fullName)),
            if (statusText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(attendee.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (attendee.attendeeStatus != AttendeeStatus.owner) ...[
              if (isAuthor && attendee.attendeeStatus == AttendeeStatus.pending)
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: onAccept,
                  tooltip: 'Accept Request',
                ),
              const SizedBox(width: 8),
              if (!isPaidEvent) ...[
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    attendee.attendeeStatus == AttendeeStatus.pending && isAuthor 
                        ? Icons.cancel 
                        : Icons.remove_circle_outline, 
                    color: Colors.red
                  ),
                  tooltip: attendee.attendeeStatus == AttendeeStatus.pending && isAuthor ? 'Reject Request' : 'Remove Attendee',
                ),
              ],
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}


