import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/entity_state_label.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dismissible_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/utils/files.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';

class SocialListItem extends StatelessWidget {
  const SocialListItem({
    required this.user,
    required this.social,
    required this.filter,
    this.onTap,
    this.onLongPress,
    this.onCheckboxChanged,
    this.isChecked = false,
  });

  final UserEntity? user;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final SocialEntity social;
  final String? filter;
  final Function(bool?)? onCheckboxChanged;
  final bool isChecked;

  List<String> _getPhotoUrls() {
    if (social.photos.isEmpty) {
      return [];
    }

    try {
      final parsed = json.decode(social.photos);

      if (parsed is List) {
        if (parsed.isNotEmpty && parsed.first is String) {
          return List<String>.from(parsed);
        } else if (parsed.isNotEmpty && parsed.first is Map) {
          List<String> urls = [];
          for (var item in parsed) {
            if (item is Map &&
                item.containsKey('type') &&
                item['type'] == 'url') {
              urls.add(item['data']);
            }
          }
          return urls;
        }
      }
      return [];
    } catch (e) {
      print('Error parsing photos: $e');
      return [];
    }
  }

  void _handleLike(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (isAuthenticated(store.state)) {
      store.dispatch(LikeEntityRequest(
        entityId: social.id,
        entityType: EntityType.social,
        type: 1,
      ));
    } else {
      showLoginDialog(context: context, title: 'Login Required', content: 'Please login to like posts.');
    }
  }

  void _handleComment(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (!isAuthenticated(store.state)) {
      showLoginDialog(context: context, title: 'Login Required', content: 'Please login to comment on posts.');
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final commentController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: 'Write your comment...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(CommentEntityRequest(
                    entityId: social.id,
                    entityType: EntityType.social,
                    comment: commentController.text.trim(),
                  ));
                  showToast("Comment added SuccessFully");
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _handleReport(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (!isAuthenticated(store.state)) {
      showLoginDialog(context: context, title: 'Login Required', content: 'Please login to report posts.');
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final reportController = TextEditingController();
        return AlertDialog(
          title: const Text('Report Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please describe why you are reporting this post:'),
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
                    entityId: social.id,
                    entityType: EntityType.social,
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

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final socialUIState = uiState.socialUIState;
    final listUIState = socialUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final showCheckbox = onCheckboxChanged != null || isInMultiselect;
    final theme = Theme.of(context);
    final photoUrls = _getPhotoUrls();
    final currentUserId = getLoggedInUserId(store);
    final isLiked = social.likesMap?.containsKey(currentUserId) ?? false;

    final filterMatch =
        filter?.isNotEmpty == true ? social.matchesFilterValue(filter!) : null;

    return DismissibleEntity(
      userCompany: state.userCompany,
      entity: social,
      isSelected: social.id ==
          (uiState.isEditing
              ? socialUIState.editing?.id
              : socialUIState.selectedId),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (social.reported == true && social.reportsMap != null && social.reportsMap!.isNotEmpty && isAdmin(state))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flag,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This post has been reported (${social.reportsMap!.length} report${social.reportsMap!.length > 1 ? 's' : ''})',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            InkWell(
              onTap: () => onTap != null ? onTap!() : selectEntity(entity: social),
              onLongPress: () => onLongPress != null
                  ? onLongPress!()
                  : selectEntity(entity: social, longPress: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        if (social.userPhotoUrl.isNotEmpty)
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(social.userPhotoUrl),
                          )
                        else
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: theme.primaryColor,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                social.userDisplayName.isNotEmpty
                                    ? social.userDisplayName
                                    : "Anonymous User",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                social.createdAt > 0
                                    ? timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            social.createdAt))
                                    : 'Just now',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'report':
                                _handleReport(context);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'report',
                              child: Row(
                                children: [
                                  Icon(Icons.flag, size: 16),
                                  SizedBox(width: 8),
                                  Text('Report'),
                                ],
                              ),
                            ),
                          ],
                          child: const Icon(Icons.more_horiz),
                        ),
                        if (showCheckbox)
                          Checkbox(
                            value: isChecked,
                            onChanged: onCheckboxChanged,
                            activeColor: theme.colorScheme.secondary,
                          ),
                      ],
                    ),
                  ),
                  if (social.content.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        social.content,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  if (photoUrls.isNotEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        if (photoUrls.length == 1) {
                          return CachedNetworkImage(
                            imageUrl: photoUrls.first,
                            height: 250,
                            width: width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          );
                        } else {
                          return Container(
                            height: photoUrls.length > 2 ? 250 : 180,
                            child: _buildPhotoGrid(photoUrls, width),
                          );
                        }
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_up,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${social.likeCount}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        Text(
                          '${social.commentCount} comments',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        label: 'Like',
                        color: isLiked ? Colors.blue : null,
                        onPressed: () => _handleLike(context),
                      ),
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'Comment',
                        onPressed: () => _handleComment(context),
                      ),
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onPressed: () {
                          final url = 'https://http://localhost:8080//social/${social.id}';
                          final filename = 'social-${social.id}.txt';
                          shareContent(context, url, filename: filename);
                        },
                      ),
                    ],
                  ),
                  if (social.category.isNotEmpty || social.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (social.category.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Chip(
                                label: Text(social.category),
                                backgroundColor: theme.primaryColor.withOpacity(0.1),
                                labelStyle: TextStyle(color: theme.primaryColor),
                              ),
                            ),
                          ...social.tags
                              .split(',')
                              .where((tag) => tag.trim().isNotEmpty)
                              .map((tag) => Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Chip(
                                      label: Text('#${tag.trim()}'),
                                    ),
                              )),
                        ],
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: EntityStateLabel(social),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildPhotoGrid(List<String> photoUrls, double width) {
    if (photoUrls.length == 2) {
      return Row(
        children: [
          _buildGridImage(photoUrls[0], width / 2, 180),
          _buildGridImage(photoUrls[1], width / 2, 180),
        ],
      );
    } else if (photoUrls.length == 3) {
      return Row(
        children: [
          _buildGridImage(photoUrls[0], width / 2, 250),
          Column(
            children: [
              _buildGridImage(photoUrls[1], width / 2, 125),
              _buildGridImage(photoUrls[2], width / 2, 125),
            ],
          ),
        ],
      );
    } else if (photoUrls.length == 4) {
      // 2x2 grid
      return Column(
        children: [
          Row(
            children: [
              _buildGridImage(photoUrls[0], width / 2, 125),
              _buildGridImage(photoUrls[1], width / 2, 125),
            ],
          ),
          Row(
            children: [
              _buildGridImage(photoUrls[2], width / 2, 125),
              _buildGridImage(photoUrls[3], width / 2, 125),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              _buildGridImage(photoUrls[0], width / 2, 125),
              _buildGridImage(photoUrls[1], width / 2, 125),
            ],
          ),
          Row(
            children: [
              _buildGridImage(photoUrls[2], width / 2, 125),
              Stack(
                children: [
                  _buildGridImage(photoUrls[3], width / 2, 125),
                  if (photoUrls.length > 4)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black45,
                        child: Center(
                          child: Text(
                            '+${photoUrls.length - 4} more',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildGridImage(String url, double width, double height) {
    return Container(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      ),
    );
  }
}
