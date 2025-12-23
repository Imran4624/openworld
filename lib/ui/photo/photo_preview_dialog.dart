import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/files.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:redux/redux.dart';
import 'dart:async';

import 'dart:ui';
import 'package:http/http.dart' as http;

class PhotoCreatorDetails {
  final String? creatorName;
  final String? avatarUrl;
  final String? creatorInitial;
  final String? timeAgo;
  final bool hasValidDetails;

  const PhotoCreatorDetails({
    this.creatorName,
    this.avatarUrl,
    this.creatorInitial,
    this.timeAgo,
    this.hasValidDetails = false,
  });
}

class PhotoPreviewDialog extends StatefulWidget {
  final PhotoEntity photo;
  final PhotoCreatorDetails? creatorDetails;

  const PhotoPreviewDialog({
    super.key,
    required this.photo,
    this.creatorDetails,
  });

  static void show(
    BuildContext context,
    PhotoEntity photo, {
    PhotoCreatorDetails? creatorDetails,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      useRootNavigator: true,
      builder: (context) => PhotoPreviewDialog(
        photo: photo,
        creatorDetails: creatorDetails,
      ),
    );
  }

  @override
  _PhotoPreviewDialogState createState() => _PhotoPreviewDialogState();
}

class _PhotoPreviewDialogState extends State<PhotoPreviewDialog> {
  late PhotoEntity currentPhoto;

  @override
  void initState() {
    super.initState();
    currentPhoto = widget.photo;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    super.dispose();
  }

  void _navigateToPhoto(PhotoEntity photo) {
    setState(() {
      currentPhoto = photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    
      return _buildDefaultUI(context);
  }

  bool shouldBlurImage(Store<AppState> store) {
    final state = store.state;

   

    final currentUserId = state.authState.currentUserId;
    final isPhotoOwner = currentPhoto.createdUserId != null &&
        currentPhoto.createdUserId == currentUserId &&
        currentUserId.isNotEmpty &&
        currentPhoto.createdUserId!.isNotEmpty;

    if (isPhotoOwner) {
      return false;
    }

    final isAuthenticated = state.authState.isAuthenticated;
    final isGuest = state.authState.originator == OriginatorType.guest.value;

    if (!isAuthenticated || isGuest) {
      return true;
    }

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
            return true;
          }
        }
      }
    }

    return false;
  }

  Widget _buildLoopjamUI(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
    final state = store.state;
    final photoList = state.photoState.list;
    final photoMap = state.photoState.map;
    final screenSize = MediaQuery.of(context).size;
    final num computedWidth = (screenSize.width * 0.75).clamp(480.0, 1100.0);
    computedWidth.toDouble();
    int currentIndex = photoList.indexOf(currentPhoto.id);
    if (currentIndex == -1) currentIndex = 0;

    bool canNavigateLeft = currentIndex > 0;
    bool canNavigateRight = currentIndex < photoList.length - 1;

    void handleReport(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final reportController = TextEditingController();
          return AlertDialog(
            title: const Text('Report Photo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please describe why you are reporting this Photo:'),
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
                      entityId: currentPhoto.id,
                      entityType: EntityType.photo,
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

    void handleDownLoad() async {
      Navigator.of(context).pop();

      try {
        final response = await http.get(Uri.parse(currentPhoto.url));
        if (response.statusCode == 200) {
          final urlParts = currentPhoto.url.split('/');
          final fileName = urlParts.last.contains('.')
              ? urlParts.last
              : 'photo-${currentPhoto.id}.jpg';

          saveDownloadedFile(response.bodyBytes, fileName);
        } else {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
      } catch (e) {
        logError('Error downloading photo: $e');
      }
    }

    void handleDelete(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Photo'),
            content: const Text(
                'Are you sure you want to delete this photo? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(PurgePhotosRequest(
                    Completer<void>(),
                    [currentPhoto.id],
                  ));
                  Navigator.of(context).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close photo preview dialog
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    bool canDeletePhoto(Store<AppState> store) {
      final state = store.state;
      final currentUserId = getLoggedInUserId(store);
      final isPhotoOwner = currentPhoto.createdUserId == currentUserId;

      final uiState = state.uiState;
      bool isEventAuthor = false;

      if (uiState.filterEntityId?.isNotEmpty == true) {
        final selectedEvent = state.eventState.map[uiState.filterEntityId];
        isEventAuthor = selectedEvent?.createdUserId == currentUserId;
      }

      return isPhotoOwner || isEventAuthor;
    }

    Widget buildReportedCommentsBox() {
      if (currentPhoto.reported != true ||
          currentPhoto.reportsMap == null ||
          currentPhoto.reportsMap!.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appTheme.defaultColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: appTheme.danger,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: appTheme.danger, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Reported Comments (${currentPhoto.reportsMap!.length})',
                  style: TextStyle(
                    color: appTheme.danger,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...currentPhoto.reportsMap!.entries.map((entry) {
              final report = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        if (report['reportedAt'] != null)
                          Text(
                            formatDate(
                                convertTimestampToDateString(
                                    report['reportedAt']),
                                context),
                            style: TextStyle(
                              fontSize: 10,
                              color: appTheme.defaultColor,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report['comment'] ?? 'No comment provided',
                      style: TextStyle(
                        color: AppTheme.light.text,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Positioned(
              top: isMobile(context) ? 60 : 80,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      const Spacer(),
                      if (isAuthenticated(store.state) &&
                          !shouldBlurImage(store)) ...[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => handleReport(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Report',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => handleDownLoad(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (getLoggedInUserId(store) ==
                                currentPhoto.createdUserId &&
                            ProjectConfig.showEditPhotoButton())
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Navigator.of(context).pop();
                                store.dispatch(EditPhoto(photo: currentPhoto));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(right: 8),
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        if (canDeletePhoto(store))
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () => handleDelete(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(right: 16),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isMobile(context) ? 40 : 80),
                Center(
                  child: SizedBox(
                    width: isMobile(context) ? 300 : 800,
                    height: isMobile(context) ? 300 : 500,
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0 && canNavigateLeft) {
                          final previousId = photoList[currentIndex - 1];
                          final previousPhoto = photoMap[previousId];
                          if (previousPhoto != null) {
                            _navigateToPhoto(previousPhoto);
                          }
                        } else if (details.primaryVelocity! < 0 &&
                            canNavigateRight) {
                          final nextId = photoList[currentIndex + 1];
                          final nextPhoto = photoMap[nextId];
                          if (nextPhoto != null) {
                            _navigateToPhoto(nextPhoto);
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          if (currentPhoto.url.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: shouldBlurImage(store)
                                  ? Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: currentPhoto.url,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 18, sigmaY: 18),
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.45),
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      ],
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: currentPhoto.url,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                            ),
                          if (currentPhoto.category.isNotEmpty ||
                              currentPhoto.tags.isNotEmpty)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 24, 16, 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (!shouldBlurImage(store) &&
                                              widget.creatorDetails
                                                      ?.hasValidDetails ==
                                                  true)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _buildSimpleCreatorAvatar(),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      _buildSimpleCreatorName(),
                                                      const SizedBox(height: 2),
                                                      _buildSimpleCreationTime(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
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
                ),
                const SizedBox(
                  height: 16,
                ),
                if (photoList.length > 1)
                  Center(
                    child: SizedBox(
                      width: isMobile(context) ? 300 : 800,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${currentIndex + 1}/${photoList.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(28),
                                    onTap: canNavigateLeft
                                        ? () {
                                            final previousId =
                                                photoList[currentIndex - 1];
                                            final previousPhoto =
                                                photoMap[previousId];
                                            if (previousPhoto != null) {
                                              _navigateToPhoto(previousPhoto);
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: canNavigateLeft
                                            ? Colors.white
                                            : Colors.grey[700],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 18,
                                        color: canNavigateLeft
                                            ? Colors.black
                                            : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(28),
                                    onTap: canNavigateRight
                                        ? () {
                                            final nextId =
                                                photoList[currentIndex + 1];
                                            final nextPhoto = photoMap[nextId];
                                            if (nextPhoto != null) {
                                              _navigateToPhoto(nextPhoto);
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: canNavigateRight
                                            ? Colors.white
                                            : Colors.grey[700],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 18,
                                        color: canNavigateRight
                                            ? Colors.black
                                            : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
              ],
            ),
            if (isAdmin(store.state))
              Positioned(
                bottom: 140,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    buildReportedCommentsBox(),
                  ],
                ),
              ),
            _buildLoopjamStatusMessage(currentPhoto),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultUI(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
    final state = store.state;
    final photoList = state.photoState.list;
    final photoMap = state.photoState.map;
    final screenSize = MediaQuery.of(context).size;

    int currentIndex = photoList.indexOf(currentPhoto.id);
    if (currentIndex == -1) currentIndex = 0;

    bool canNavigateLeft = currentIndex > 0;
    bool canNavigateRight = currentIndex < photoList.length - 1;

    void handleReport(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final reportController = TextEditingController();
          return AlertDialog(
            title: const Text('Report Photo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please describe why you are reporting this Photo:'),
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
                      entityId: currentPhoto.id,
                      entityType: EntityType.photo,
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

    void handleDownLoad() async {
      Navigator.of(context).pop();

      try {
        final response = await http.get(Uri.parse(currentPhoto.url));
        if (response.statusCode == 200) {
          final uri = Uri.parse(currentPhoto.url);
          final pathSegments = uri.pathSegments;
          String fileName = pathSegments.isNotEmpty ? pathSegments.last : '';

          if (fileName.contains('?')) {
            fileName = fileName.split('?').first;
          }

          if (fileName.isEmpty || !fileName.contains('.')) {
            fileName = 'photo-${currentPhoto.id}';
          }

          fileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

          saveDownloadedFile(response.bodyBytes, fileName);
        } else {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
      } catch (e) {
        logError('Error downloading photo: $e');
      }
    }

    Widget buildReportedCommentsBox() {
      if (currentPhoto.reported != true ||
          currentPhoto.reportsMap == null ||
          currentPhoto.reportsMap!.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appTheme.defaultColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: appTheme.danger,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: appTheme.danger, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Reported Comments (${currentPhoto.reportsMap!.length})',
                  style: TextStyle(
                    color: appTheme.danger,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...currentPhoto.reportsMap!.entries.map((entry) {
              final report = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        if (report['reportedAt'] != null)
                          Text(
                            formatDate(
                                convertTimestampToDateString(
                                    report['reportedAt']),
                                context),
                            style: TextStyle(
                              fontSize: 10,
                              color: appTheme.defaultColor,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report['comment'] ?? 'No comment provided',
                      style: TextStyle(
                        color: AppTheme.light.text,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
          ),
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {},
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0 && canNavigateLeft) {
                      final previousId = photoList[currentIndex - 1];
                      final previousPhoto = photoMap[previousId];
                      if (previousPhoto != null) {
                        _navigateToPhoto(previousPhoto);
                      }
                    } else if (details.primaryVelocity! < 0 &&
                        canNavigateRight) {
                      final nextId = photoList[currentIndex + 1];
                      final nextPhoto = photoMap[nextId];
                      if (nextPhoto != null) {
                        _navigateToPhoto(nextPhoto);
                      }
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: screenSize.width * 0.95,
                      maxHeight: screenSize.height * 0.85,
                    ),
                    child: currentPhoto.url.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: shouldBlurImage(store)
                                ? Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: currentPhoto.url,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.error,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 18, sigmaY: 18),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.45),
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ],
                                  )
                                : CachedNetworkImage(
                                    imageUrl: currentPhoto.url,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      if (isAuthenticated(store.state) &&
                          !shouldBlurImage(store)) ...[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => handleReport(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Report',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => handleDownLoad(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (getLoggedInUserId(store) ==
                                currentPhoto.createdUserId &&
                            ProjectConfig.showEditPhotoButton())
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Navigator.of(context).pop();
                                store.dispatch(EditPhoto(photo: currentPhoto));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (photoList.length > 1)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${photoList.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: canNavigateLeft
                                    ? () {
                                        final previousId =
                                            photoList[currentIndex - 1];
                                        final previousPhoto =
                                            photoMap[previousId];
                                        if (previousPhoto != null) {
                                          _navigateToPhoto(previousPhoto);
                                        }
                                      }
                                    : null,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: canNavigateLeft
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.grey.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 20,
                                    color: canNavigateLeft
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: canNavigateRight
                                    ? () {
                                        final nextId =
                                            photoList[currentIndex + 1];
                                        final nextPhoto = photoMap[nextId];
                                        if (nextPhoto != null) {
                                          _navigateToPhoto(nextPhoto);
                                        }
                                      }
                                    : null,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: canNavigateRight
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.grey.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: canNavigateRight
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (((currentPhoto.category.isNotEmpty ||
                          currentPhoto.tags.isNotEmpty)) ||
                  (
                      widget.creatorDetails?.hasValidDetails == true &&
                      !shouldBlurImage(store)))
                Positioned(
                  bottom: photoList.length > 1 ? 120 : 80,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!shouldBlurImage(store) &&
                            widget.creatorDetails?.hasValidDetails == true)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildSimpleCreatorAvatar(),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildSimpleCreatorName(),
                                    const SizedBox(height: 2),
                                    _buildSimpleCreationTime(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (currentPhoto.category.isNotEmpty)
                          Text(
                            currentPhoto.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (currentPhoto.tags.isNotEmpty ) ...[
                          const SizedBox(height: 4),
                          Text(
                            currentPhoto.tags,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              if (isAdmin(store.state))
                Positioned(
                  bottom: 200,
                  left: 0,
                  right: 0,
                  child: buildReportedCommentsBox(),
                ),
              _buildStatusMessage(currentPhoto),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(PhotoEntity photo) {
    String statusText = '';

    if (photo.isDeleted! == true) {
      statusText = 'Photo is deleted';
    } else if (photo.isArchived) {
      statusText = 'Photo is pending approval';
    }

    if (statusText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 160,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoopjamStatusMessage(PhotoEntity photo) {
    String statusText = '';

    if (photo.isDeleted! == true) {
      statusText = 'Photo is deleted';
    } else if (photo.isArchived) {
      statusText = 'Photo is pending approval';
    }

    if (statusText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 140,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleCreatorAvatar() {
    if (widget.creatorDetails?.avatarUrl != null &&
        widget.creatorDetails!.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(widget.creatorDetails!.avatarUrl!),
        backgroundColor: Colors.grey[300],
      );
    } else if (widget.creatorDetails?.creatorInitial != null) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: Colors.blue,
        child: Text(
          widget.creatorDetails!.creatorInitial!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return const CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey,
      child: Text(
        'U',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSimpleCreatorName() {
    return Text(
      widget.creatorDetails?.creatorName ?? 'Unknown User',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSimpleCreationTime() {
    if (widget.creatorDetails?.timeAgo == null) {
      return const SizedBox.shrink();
    }

    return Text(
      widget.creatorDetails!.timeAgo!,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
