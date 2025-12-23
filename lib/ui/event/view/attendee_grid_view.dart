import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/tables/profile_grid_item.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/data/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class AttendeeGridView extends StatefulWidget {
  const AttendeeGridView({
    Key? key,
    required this.attendees,
    required this.scrollController,
    this.isEventPassed = false,
  }) : super(key: key);

  final List<BuyerDetails> attendees;
  final ScrollController scrollController;
  final bool isEventPassed;

  @override
  State<AttendeeGridView> createState() => _AttendeeGridViewState();
}

class _AttendeeGridViewState extends State<AttendeeGridView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchAttendeeProfiles();
      }
    });
  }

  void _fetchAttendeeProfiles() {
    if (!mounted) return;

    final store = StoreProvider.of<AppState>(context);
    final completer = Completer<void>();

    store.dispatch(FetchAttendeeProfilesRequest(
      attendees: widget.attendees,
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
        showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AttendeeGridViewModel>(
      converter: (store) => _AttendeeGridViewModel.fromStore(
          store, widget.attendees, widget.isEventPassed, context),
      builder: (context, viewModel) {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = screenWidth > kTabletLayoutWidth
            ? 3
            : screenWidth > kMobileLayoutWidth
                ? 3
                : 2;

        if (widget.attendees.isEmpty) {
          return Center(
            child: Text(
              viewModel.localization.noRecordsFound,
              textAlign: TextAlign.center,
            ),
          );
        }

        return GridView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: widget.attendees.length,
          itemBuilder: (context, index) {
            final attendee = widget.attendees[index];
            final hasProfile = viewModel.hasProfile(attendee.email);

            if (hasProfile) {
              final profileId = viewModel.getProfileId(attendee.email);
              final profile = viewModel.getProfile(profileId);

              if (profile != null) {
                return ProfileGridItem(
                  profile: profile,
                  onTap: () => viewModel.onProfileTap(profile),
                  isInMultiselect: false,
                  isChecked: false,
                );
              }
            }

            return AttendeeGridItem(
              attendee: attendee,
              isEventPassed: widget.isEventPassed,
              onTap: () => viewModel.onAttendeeWithoutProfileTap(attendee),
              onMessageTap: widget.isEventPassed
                  ? () =>
                      ChatRepository.createOrOpenChat(context, attendee.email)
                  : null,
            );
          },
        );
      },
    );
  }
}

class _AttendeeGridViewModel {
  final AppState state;
  final List<BuyerDetails> attendees;
  final bool isEventPassed;
  final AppLocalization localization;
  final Function(ProfileEntity) onProfileTap;
  final Function(BuyerDetails) onAttendeeWithoutProfileTap;

  _AttendeeGridViewModel({
    required this.state,
    required this.attendees,
    required this.isEventPassed,
    required this.localization,
    required this.onProfileTap,
    required this.onAttendeeWithoutProfileTap,
  });

  static _AttendeeGridViewModel fromStore(
    Store<AppState> store,
    List<BuyerDetails> attendees,
    bool isEventPassed,
    BuildContext context,
  ) {
    final state = store.state;
    final localization = AppLocalization.of(context)!;

    return _AttendeeGridViewModel(
      state: state,
      attendees: attendees,
      isEventPassed: isEventPassed,
      localization: localization,
      onProfileTap: (profile) {
        selectEntity(entity: profile);
      },
      onAttendeeWithoutProfileTap: (attendee) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('No Profile'),
                content: Text('This attendee has not created a profile yet.'),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
    );
  }

  bool hasProfile(String email) {
    return state.profileState.attendeeProfileMap
        .containsKey(email.toLowerCase());
  }

  String getProfileId(String email) {
    return state.profileState.attendeeProfileMap[email.toLowerCase()] ?? '';
  }

  ProfileEntity? getProfile(String profileId) {
    if (profileId.isEmpty) return null;
    return state.profileState.map[profileId];
  }
}

class AttendeeGridItem extends StatelessWidget {
  const AttendeeGridItem({
    Key? key,
    required this.attendee,
    this.isEventPassed = false,
    this.onTap,
    this.onMessageTap,
  }) : super(key: key);

  final BuyerDetails attendee;
  final bool isEventPassed;
  final VoidCallback? onTap;
  final VoidCallback? onMessageTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildProfileImage(),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Expanded(
                          //   child: Text(
                          //     fullName,
                          //     style: const TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 22,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No profile',
                        style: TextStyle(
                          color: Colors.orange.shade300,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final avatarColor = _getAvatarColor(attendee.firstName);

    return Container(
      color: avatarColor.withOpacity(0.3),
      child: Center(
        child: Icon(
          Icons.person,
          size: 64,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  Color _getAvatarColor(String seed) {
    final List<Color> predefinedColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.red,
    ];

    if (seed.isEmpty) {
      return predefinedColors[0];
    }

    final int index = seed.codeUnitAt(0) % predefinedColors.length;
    return predefinedColors[index];
  }
}
