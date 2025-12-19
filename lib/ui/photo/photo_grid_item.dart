import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/photo/photo_preview_dialog.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'dart:ui';

class PhotoGridItem extends StatefulWidget {
  const PhotoGridItem({
    super.key,
    required this.photo,
    this.onTap,
    this.onLongPress,
  });

  final PhotoEntity photo;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<PhotoGridItem> createState() => _PhotoGridItemState();
}

class _PhotoGridItemState extends State<PhotoGridItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final photoUIState = uiState.photoUIState;

    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
    final isSelected = widget.photo.id ==
        (uiState.isEditing
            ? photoUIState.editing?.id
            : photoUIState.selectedId);

    final isInMultiselect = state.photoListState.isInMultiselect();
    final isMultiSelected = state.photoListState.isSelected(widget.photo.id);

    final isGuest = isGuestUser(state);

    bool shouldBlurImage = false;
    if (ProjectConfig.appType == AppType.loopjam) {
      final currentUserId = state.authState.currentUserId;
      final isPhotoOwner = widget.photo.createdUserId != null &&
          widget.photo.createdUserId == currentUserId &&
          currentUserId.isNotEmpty &&
          widget.photo.createdUserId!.isNotEmpty;

      if (isPhotoOwner) {
        shouldBlurImage = false;
      } else if (!state.authState.isAuthenticated) {
        shouldBlurImage = true;
      } else {
        final selectedEventId = state.eventUIState.selectedId;
        if (selectedEventId != null) {
          final selectedEvent = state.eventState.map[selectedEventId];
          if (selectedEvent != null) {
            if (selectedEvent.privateEvent) {
              final isAuthor = selectedEvent.createdUserId == currentUserId;

              bool isApprovedAttendee = false;
              if (selectedEvent.orders.isNotEmpty && currentUserId.isNotEmpty) {
                final currentUserEmail = state.authState.email;

                for (final order in selectedEvent.orders) {
                  final buyerDetails = order.buyerDetails;
                  final isCurrentUserOrder = buyerDetails.email.toLowerCase() ==
                      currentUserEmail.toLowerCase();
                  final isApproved =
                      buyerDetails.attendeeStatus == AttendeeStatus.approved;

                  if (isCurrentUserOrder && isApproved) {
                    isApprovedAttendee = true;
                    break;
                  }
                }
              }

              if (!isAuthor && !isApprovedAttendee) {
                shouldBlurImage = true;
              }
            }
          }
        }
      }
    }

    return Card(
      elevation: isSelected || isMultiSelected ? 6 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected || isMultiSelected
            ? BorderSide(color: appTheme.primary, width: 2.5)
            : BorderSide.none,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap ??
              () => PhotoPreviewDialog.show(
                    context,
                    widget.photo,
                    creatorDetails: _getCreatorDetails(state),
                  ),
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.photo.url.isNotEmpty
                    ? shouldBlurImage
                        ? ClipRect(
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: widget.photo.url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      _buildDefaultImage(),
                                ),
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15.0, sigmaY: 15.0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: widget.photo.url,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildDefaultImage(),
                          )
                    : _buildDefaultImage(),
                if (widget.photo.category.isNotEmpty ||
                    widget.photo.tags.isNotEmpty ||
                    (ProjectConfig.appType == AppType.loopjam && _isHovered))
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
                if (!isGuest && !isInMultiselect)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        if (!widget.photo.isArchived &&
                            !widget.photo.isDeleted! &&
                            ProjectConfig.showTickOnEntity(EntityType.photo))
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: appTheme.success,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: appTheme.iconLight,
                            ),
                          ),
                        if (widget.photo.isArchived)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: appTheme.warning,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.hourglass_empty,
                              size: 14,
                              color: appTheme.iconLight,
                            ),
                          ),
                        if (widget.photo.isDeleted!)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: appTheme.danger,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete,
                              size: 14,
                              color: appTheme.iconLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (!isGuest && isInMultiselect)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Checkbox(
                        value: isMultiSelected,
                        side: BorderSide(color: appTheme.iconLight),
                        onChanged: (bool? value) {
                          if (value == true) {
                            store.dispatch(
                                AddToPhotoMultiselect(entity: widget.photo));
                          } else {
                            store.dispatch(RemoveFromPhotoMultiselect(
                                entity: widget.photo));
                          }
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                if (!shouldBlurImage &&
                    _isHovered &&
                    ProjectConfig.appType == AppType.loopjam &&
                    _hasValidAttendeeDetails(state))
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (context) {
                            return _buildCreatorAvatar(state);
                          },
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Builder(
                              builder: (context) {
                                return _buildCreatorName(state);
                              },
                            ),
                            const SizedBox(height: 2),
                            _buildCreationTime(),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ProfileEntity? _findCreatorProfile(AppState state, String createdUserId) {
    ProfileEntity? profile;

    profile = state.profileState.map[createdUserId];
    if (profile == null) {
      for (final profileEntry in state.profileState.map.entries) {
        final p = profileEntry.value;
        if (p.id == createdUserId) {
          profile = p;
          break;
        }
      }
    }

    if (profile == null) {
      final selectedEventId = state.eventUIState.selectedId;
      if (selectedEventId != null) {
        final selectedEvent = state.eventState.map[selectedEventId];
        if (selectedEvent != null) {
          for (final order in selectedEvent.orders) {
            final attendee = order.buyerDetails;

            final attendeeProfileId = state
                .profileState.attendeeProfileMap[attendee.email.toLowerCase()];
            if (attendeeProfileId != null) {
              final attendeeProfile = state.profileState.map[attendeeProfileId];

              if (attendeeProfile != null &&
                  attendeeProfile.id == createdUserId) {
                profile = attendeeProfile;
                break;
              }
            }

            if (attendee.firstName.isNotEmpty && createdUserId.isNotEmpty) {
              continue;
            }
          }
        }
      }
    }

    if (profile == null) {
      for (final profileEntry in state.profileState.map.entries) {
        final p = profileEntry.value;
        final dynamicFields = p.dynamicFields;
        if (dynamicFields.containsKey('userId') &&
            dynamicFields['userId'].toString() == createdUserId) {
          profile = p;
          break;
        }
      }
    }

    return profile;
  }

  bool _hasValidAttendeeDetails(AppState state) {
    final createdUserId = widget.photo.createdUserId;

    if (createdUserId == null || createdUserId.isEmpty) {
      return false;
    }

    final profile = _findCreatorProfile(state, createdUserId);
    return profile != null && profile.name.isNotEmpty;
  }

  Widget _buildDefaultImage() {
    return const Center(
      child: Icon(
        Icons.person,
        size: 64,
      ),
    );
  }

  Widget _buildCreatorAvatar(AppState state) {
    final createdUserId = widget.photo.createdUserId;

    if (createdUserId != null && createdUserId.isNotEmpty) {
      ProfileEntity? profile = _findCreatorProfile(state, createdUserId);

      if (profile != null && profile.name.isNotEmpty) {
        String? profileImageUrl;
        final images = profile.dynamicFields['images'];
        if (images != null && images.isNotEmpty) {
          profileImageUrl = images.first.toString();
        }

        if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
          return CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(profileImageUrl),
            backgroundColor: Colors.grey[300],
          );
        } else {
          return CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue,
            child: Text(
              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      }
    }

    return const CircleAvatar(
      radius: 12,
      backgroundColor: Colors.grey,
      child: Text(
        'U',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCreatorName(AppState state) {
    final createdUserId = widget.photo.createdUserId;

    if (createdUserId != null && createdUserId.isNotEmpty) {
      ProfileEntity? profile = _findCreatorProfile(state, createdUserId);

      if (profile != null && profile.name.isNotEmpty) {
        return Text(
          profile.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      }
    }
    return const Text(
      'Unknown User',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCreationTime() {
    if (widget.photo.createdAt == 0) {
      return const SizedBox.shrink();
    }

    final createdDate =
        DateTime.fromMillisecondsSinceEpoch(widget.photo.createdAt);
    final now = DateTime.now();
    final difference = now.difference(createdDate);

    String timeText;
    if (difference.inDays > 0) {
      timeText = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeText = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeText = '${difference.inMinutes}m ago';
    } else {
      timeText = 'Just now';
    }

    return Text(
      timeText,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  PhotoCreatorDetails? _getCreatorDetails(AppState state) {
    if (!_hasValidAttendeeDetails(state)) {
      return null;
    }

    final createdUserId = widget.photo.createdUserId;
    if (createdUserId == null || createdUserId.isEmpty) {
      return null;
    }

    final profile = _findCreatorProfile(state, createdUserId);
    if (profile == null || profile.name.isEmpty) {
      return null;
    }

    String? avatarUrl;
    final images = profile.dynamicFields['images'];
    if (images != null && images.isNotEmpty) {
      avatarUrl = images.first.toString();
    }

    String? timeAgo;
    if (widget.photo.createdAt != 0) {
      final createdDate =
          DateTime.fromMillisecondsSinceEpoch(widget.photo.createdAt);
      final now = DateTime.now();
      final difference = now.difference(createdDate);

      if (difference.inDays > 0) {
        timeAgo = '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        timeAgo = '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        timeAgo = '${difference.inMinutes}m ago';
      } else {
        timeAgo = 'Just now';
      }
    }

    return PhotoCreatorDetails(
      creatorName: profile.name,
      avatarUrl: avatarUrl,
      creatorInitial:
          profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
      timeAgo: timeAgo,
      hasValidDetails: true,
    );
  }
}
