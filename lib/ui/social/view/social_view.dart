import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/social/view/social_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/files.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/constants.dart';

class SocialView extends StatefulWidget {
  const SocialView({
    super.key,
    required this.viewModel,
    required this.isFilter,
  });

  final SocialViewVM viewModel;
  final bool isFilter;

  @override
  _SocialViewState createState() => _SocialViewState();
}

class _SocialViewState extends State<SocialView> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentsExpanded = false; // Add this state variable

  List<String> _getPhotoUrls() {
    final social = widget.viewModel.social;
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

  List<Widget> _getCommentsToDisplay(SocialEntity social) {
    if (social.commentsMap == null || social.commentsMap!.isEmpty) {
      return [];
    }

    final entries = social.commentsMap!.entries.toList();
    
    entries.sort((a, b) {
      final timestampA = (a.value as Map<String, dynamic>)['timestamp'] as int? ?? 0;
      final timestampB = (b.value as Map<String, dynamic>)['timestamp'] as int? ?? 0;
      return timestampB.compareTo(timestampA); // Descending order
    });
    
    final commentsToShow = _isCommentsExpanded ? entries : entries.take(3).toList();
    
    return commentsToShow.map((entry) {
      final comment = entry.value as Map<String, dynamic>;
      return _buildCommentItem(
        userName: comment['userName'] ,
        comment: comment['comment'] ,
        timeAgo: comment['timestamp'] != null
            ? timeago.format(
                DateTime.fromMillisecondsSinceEpoch(comment['timestamp']))
            : 'Just now',
      );
    }).toList();
  }

  void _handleLike(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (isAuthenticated(store.state)) {
    store.dispatch(LikeEntityRequest(
      entityId: widget.viewModel.social.id,
      entityType: EntityType.social,
      type: 1,
    ));
      
    } else {
      
    showLoginDialog(context: context, title: 'Login Required',content: 'Please login to like post.');
    }
  }

  void _handleComment() {
    final store = StoreProvider.of<AppState>(context);
    if (isAuthenticated(store.state)) {
    if (_commentController.text.trim().isNotEmpty) {
      store.dispatch(CommentEntityRequest(
        entityId: widget.viewModel.social.id,
        entityType: EntityType.social,
        comment: _commentController.text.trim(),
      ));
      _commentController.clear();
    }
  } else {
    showLoginDialog(context: context, title: 'Login Required',content: 'Please login to post a comment.');
  }
  }
  void _showReportedComments(BuildContext context) {
    if (widget.viewModel.social.reported != true || widget.viewModel.social.reportsMap == null || widget.viewModel.social.reportsMap!.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.flag, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Reported Comments'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxHeight: 400),
            child: widget.viewModel.social.reportsMap == null || widget.viewModel.social.reportsMap!.isEmpty
                ? const Text('No reports found.')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.viewModel.social.reportsMap!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final userId = widget.viewModel.social.reportsMap!.keys.elementAt(index);
                      final report = widget.viewModel.social.reportsMap![userId];
                      
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                // Text(
                                //   'User ID: ${userId.substring(0, 8)}...',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey[600],
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                // const Spacer(),
                                if (report['reportedAt'] != null)
                                  Text(
                                    formatDate(convertTimestampToDateString(report['reportedAt']), context),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              report['comment'] ?? 'No comment provided',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final social = viewModel.social;
    final theme = Theme.of(context);
    final photoUrls = _getPhotoUrls();
    final store = StoreProvider.of<AppState>(context);
    final currentUserId = getLoggedInUserId(store);
    final isLiked = social.likesMap?.containsKey(currentUserId) ?? false;
    final createdDate = social.createdAt > 0
        ? DateTime.fromMillisecondsSinceEpoch(social.createdAt)
        : DateTime.now();

    return ViewScaffold(
      isFilter: widget.isFilter,
      isEditable: social.createdUserId ==
          getLoggedInUserId(store),
      entity: social,
      title: social.userDisplayName.isNotEmpty
          ? '${social.userDisplayName}\'s Post'
          : '',
      onBackPressed: () => viewModel.onBackPressed(),
      body: ScrollableListView(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (social.userPhotoUrl.isNotEmpty)
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(social.userPhotoUrl),
                        )
                      else
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.primaryColor,
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 28),
                        ),
                      const SizedBox(width: 16),
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
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  timeago.format(createdDate),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (social.category.isNotEmpty) ...[
                                  Icon(Icons.label_outline,
                                      size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    social.category,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (social.reported == true && social.reportsMap != null && social.reportsMap!.isNotEmpty && isAdmin(store.state))
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
                child: GestureDetector(
                  onTap: () => _showReportedComments(context),
                  child: Row(
                    children: [
                      Icon(
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
                      const Spacer(),
                      Text(
                        'Tap to view',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                  if (social.content.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      social.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  if (photoUrls.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: DynamicFieldsViewImages(
                              viewType: ImageViewType.thumbnailBig,
                              images: photoUrls,
                            ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 16,
                            color: isLiked ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text('${social.likeCount} likes'),
                        ],
                      ),
                      Text('${social.commentCount} comments'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon:
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        label: '',
                        color: isLiked ? Colors.blue : null,
                        onPressed: () => _handleLike(context),
                      ),
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: '',
                        onPressed: () {
                          // Scroll to comment section or focus comment input
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: '',
                        onPressed: () {
                          final url = 'https://http://localhost:8080//social/${social.id}';
                          final filename = 'social-${social.id}.txt';
                          shareContent(context, url, filename: filename);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Comments', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.person,size: 18),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          onSubmitted: (_) => _handleComment(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _handleComment,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  ..._getCommentsToDisplay(social),
                  if (social.commentCount > 3 && social.commentsMap != null && social.commentsMap!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isCommentsExpanded = !_isCommentsExpanded;
                          });
                        },
                        child: Text(
                          _isCommentsExpanded 
                              ? 'Show less comments'
                              : 'View all ${social.commentCount} comments',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // if (social.tags.isNotEmpty) ...[
          //   const SizedBox(height: 16),
          //   Card(
          //     margin: const EdgeInsets.symmetric(horizontal: 8),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Tags', style: theme.textTheme.bodyMedium),
          //           const SizedBox(height: 8),
          //           Wrap(
          //             spacing: 8,
          //             runSpacing: 8,
          //             children: social.tags
          //                 .split(',')
          //                 .where((tag) => tag.trim().isNotEmpty)
          //                 .map((tag) => Chip(
          //                       label: Text('#${tag.trim()}'),
          //                     ))
          //                 .toList(),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ],
          const SizedBox(height: 16),
        ],
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

  Widget _buildCommentItem({
    required String userName,
    required String comment,
    required String timeAgo,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeAgo,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment),
        ],
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;
}
