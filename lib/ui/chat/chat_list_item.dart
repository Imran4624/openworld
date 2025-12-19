import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/chat/last_message_modal.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/data/models/user_model.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/chat/chat_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_selectors.dart';
import 'package:flutter_boilerplate/ui/app/dismissible_entity.dart';
import 'package:flutter_boilerplate/ui/app/live_text.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    required this.user,
    required this.chat,
    required this.filter,
    this.onTap,
    this.onLongPress,
    this.onCheckboxChanged,
    this.isChecked = false,
  });

  final UserEntity? user;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final ChatEntity chat;
  final String? filter;
  final Function(bool?)? onCheckboxChanged;
  final bool isChecked;

  Widget _buildLastMessagePreview(
      LastMessageEntity lastMessage, BuildContext context) {
    if (lastMessage.attachments != null &&
        lastMessage.attachments!.isNotEmpty) {
      final attachments = lastMessage.attachments!;
      final hasImages = attachments.any((a) => a.type == 'image');
      final hasFiles = attachments.any((a) => a.type == 'file');

      String attachmentText = '';
      if (hasImages && hasFiles) {
        attachmentText = ' Images and Files';
      } else if (hasImages) {
        final count = attachments.where((a) => a.type == 'image').length;
        attachmentText = ' ${count > 1 ? '$count Images' : 'Image'}';
      } else if (hasFiles) {
        final count = attachments.where((a) => a.type == 'file').length;
        attachmentText = '${count > 1 ? '$count Files' : 'File'}';
      }

      // If there's also a text message, combine them
      if (lastMessage.content.isNotEmpty) {
        return Row(
          children: [
            Icon(
              hasImages ? Icons.image : Icons.attach_file,
              size: 16,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                '${attachmentText} • ${lastMessage.content}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }

      return Row(
        children: [
          Icon(
            hasImages ? Icons.image : Icons.attach_file,
            size: 16,
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              attachmentText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      lastMessage.content,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 13,
          ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAvatar(ChatParticipantEntity participant, ThemeColors colors) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.defaultColor,
      ),
      child: ClipOval(
        child: participant.userThumbnail.isNotEmpty
            ? DynamicFieldsViewImages(
                viewType: ImageViewType.thumbnailBig,
                images: [participant.userThumbnail],
              )
            : _buildDefaultAvatar(colors),
      ),
    );
  }

  Widget _buildDefaultAvatar(ThemeColors colors) {
    return Image.asset(
      ProjectConfig.defaultImage,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.defaultColor,
        ),
        child: Icon(
          Icons.person,
          size: 24,
          color: colors.defaultColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final chatUIState = uiState.chatUIState;
    final listUIState = chatUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final showCheckbox = onCheckboxChanged != null || isInMultiselect;

    final receiver = chat.participants
        .where((participant) => participant.userId != state.user.id)
        .toList();

    final unreadCount = chat.getUnreadCount(state.user.id);
    final filterMatch =
        filter?.isNotEmpty == true ? chat.matchesFilterValue(filter!) : null;
    final lastMessage = chat.lastMessage;
    ThemeColors colors =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

    return DismissibleEntity(
      userCompany: state.userCompany,
      entity: chat,
      isSelected: chat.id ==
          (uiState.isEditing
              ? chatUIState.editing?.id
              : chatUIState.selectedId),
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: () {
            store.dispatch(UpdateLastMessageDocumentAction(null));
            if (onTap != null) {
              onTap!();
            } else {
              selectEntity(entity: chat);
            }
          },
          onLongPress: () => onLongPress != null
              ? onLongPress!()
              : selectEntity(entity: chat, longPress: true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showCheckbox)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IgnorePointer(
                      ignoring: listUIState.isInMultiselect(),
                      child: Checkbox(
                        value: isChecked,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) => onCheckboxChanged?.call(value),
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                if (receiver.isNotEmpty) _buildAvatar(receiver.first, colors),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              receiver.isNotEmpty
                                  ? receiver.first.userName
                                  : 'No participants',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          LiveText(
                            () => timeago.format(
                              lastMessage.createdAtDate,
                              locale:
                                  '${localeSelector(store.state, twoLetter: true)}_short',
                            ),
                            duration: Duration(minutes: 1),
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child:
                                _buildLastMessagePreview(lastMessage, context),
                          ),
                          if (unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (filterMatch != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            filterMatch,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
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
}
