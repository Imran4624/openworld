import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/company/company_selectors.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/live_text.dart';
import 'package:flutter_boilerplate/ui/app/platform_specific/file_downloader/downloader_factory.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen_vm.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    Key? key,
    required this.viewModel,
    this.isFilter = false,
  }) : super(key: key);

  final MessageScreenVM viewModel;
  final bool isFilter;
  static const String route = '/chat/view';

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with WidgetsBindingObserver {
  bool _isImageFile(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  final TextEditingController _messageController = TextEditingController();
  late ScrollController _scrollController = ScrollController();
  List<PlatformFile> _selectedFiles = [];
  bool _isAttachmentPreviewVisible = false;
  bool _isViewOnceEnabled = false;
  final Set<String> _viewedOnceMessages = {};
  final FocusNode _messageFocusNode = FocusNode();
  final downloader = getFileDownloader();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
        _isAttachmentPreviewVisible = true;
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      if (_selectedFiles.isEmpty) {
        _isAttachmentPreviewVisible = false;
      }
    });
  }

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty && _selectedFiles.isEmpty) return;

    widget.viewModel.onSendMessage(
      context,
      message,
      _selectedFiles,
      _isViewOnceEnabled,
    );
    _messageController.clear();
    setState(() {
      _selectedFiles = [];
      _isViewOnceEnabled = false;
      _isAttachmentPreviewVisible = false;
    });
    _scrollToBottom();
    _messageFocusNode.requestFocus();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      widget.viewModel.onLoad();
    }
  }

  Future<void> _downloadAttachment(
      BuildContext context, ChatMessageAttachment attachment) async {
    await downloader.downloadAttachment(context, attachment.url);
  }

  void _showImageOptions(
      BuildContext context, ChatMessageAttachment attachment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DynamicFieldsViewImages(
                viewType: ImageViewType.thumbnailBig,
                images: [attachment.url],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download Image'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _downloadAttachment(context, attachment);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRegularAttachment(ChatMessageAttachment attachment) {
    final store = StoreProvider.of<AppState>(context);
    final isDarkMode = store.state.prefState.enableDarkMode;
    final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;

    switch (attachment.type) {
      case 'image':
        return GestureDetector(
          onLongPress: () => _showImageOptions(context, attachment),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
              maxHeight: 200,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DynamicFieldsViewImages(
                viewType: ImageViewType.thumbnailBig,
                images: [attachment.url],
                blurIntensity: 0.0,
              ),
            ),
          ),
        );
      default:
        return GestureDetector(
          onTap: () => _downloadAttachment(context, attachment),
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: themeColors.background.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.attach_file, color: themeColors.text),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.name.isNotEmpty
                            ? attachment.name
                            : attachment.url.split('/').last,
                        style: TextStyle(
                          color: themeColors.text,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.download, color: themeColors.text, size: 18),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildMessageAttachment(ChatMessageEntity message) {
    if (message.isViewOnce) {
      final store = StoreProvider.of<AppState>(context);
      final hasBeenViewed = message.viewedBy[widget.viewModel.currentUserId] ??
          false || _viewedOnceMessages.contains(message.messageId);
      final isSender = message.senderId == widget.viewModel.currentUserId;
      final isDarkMode = store.state.prefState.enableDarkMode;
      final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;

      final timeWidget = Text(
        timeago.format(
          message.createdAtDate,
          locale: '${localeSelector(store.state, twoLetter: true)}_short',
        ),
        style: TextStyle(
          color: themeColors.text,
          fontSize: 12,
        ),
      );

      if (hasBeenViewed && !isSender) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: themeColors.defaultColor,
                shape: BoxShape.circle,
              ),
              child: const Tooltip(
                message: 'View Once',
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'message viewed',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            timeWidget,
          ],
        );
      }

      return GestureDetector(
        onTap: () {
          if (!hasBeenViewed && !isSender) {
            _showViewOnceMedia(message.attachments.first, message);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: themeColors.defaultColor,
                shape: BoxShape.circle,
              ),
              child: Tooltip(
                message: 'View Once',
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppTheme.light.secondary,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              message.attachments.isNotEmpty
                  ? message.attachments.first.type
                  : 'Photo',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            timeWidget,
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: message.attachments
          .map((attachment) => _buildRegularAttachment(attachment))
          .toList(),
    );
  }

  void _showViewOnceMedia(
      ChatMessageAttachment attachment, ChatMessageEntity message) {
    if (_viewedOnceMessages.contains(message.messageId)) {
      return;
    }

    final store = StoreProvider.of<AppState>(context);
    final isDarkMode = store.state.prefState.enableDarkMode;
    final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'View Once image',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Will disappear after viewing',
                          style: TextStyle(
                            color: themeColors.success,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: attachment.type == 'image'
                        ? Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              maxWidth: 400,
                            ),
                            child: DynamicFieldsViewImages(
                              viewType: ImageViewType.thumbnailBig,
                              images: [attachment.url],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.insert_drive_file, size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  attachment.url.split('/').last,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _viewedOnceMessages.add(message.messageId);
                      });
                      widget.viewModel.onViewOnceMessage(message);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final viewModel = widget.viewModel;
    final chat = viewModel.chat;
    final receiver = chat.participants
        .where((participant) => participant.userId != getLoggedInUserId(store))
        .toList();

    final isDarkMode = store.state.prefState.enableDarkMode;
    final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;

    return ViewScaffold(
      isFilter: widget.isFilter,
      entity: chat,
      isEditable: false,
      title: receiver.isNotEmpty ? receiver.first.userName : 'No participants',
      thumbnail: receiver.isNotEmpty ? receiver.first.userThumbnail : '',
      onBackPressed: () => viewModel.onBackPressed(),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                List<ChatMessageEntity> baseMessages =
                    widget.viewModel.messages;

                return StreamBuilder<List<ChatMessageEntity>>(
                  stream: widget.viewModel.messageStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData && baseMessages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final existingMessageIds =
                        baseMessages.map((m) => m.messageId).toSet();

                    final newStreamMessages =
                        snapshot.hasData ? snapshot.data! : [];
                    final messagesToAdd = newStreamMessages
                        .where((newMsg) =>
                            !existingMessageIds.contains(newMsg.messageId))
                        .toList();

                    final List<ChatMessageEntity> allMessages = [
                      ...baseMessages
                    ];
                    if (messagesToAdd.isNotEmpty) {
                      for (final message in messagesToAdd) {
                        if (message.senderId !=
                            widget.viewModel.currentUserId) {
                          allMessages.add(message);
                        }
                      }
                    }

                    return _buildMessageList(allMessages, viewModel);
                  },
                );
              },
            ),
          ),
          if (_isAttachmentPreviewVisible)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = _selectedFiles[index];
                  return Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80, // Ensures consistent box size
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeColors.defaultColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: _isImageFile(file.name)
                            ? isWeb()
                                ? Image.memory(
                                    file.bytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(file.path!),
                                    fit: BoxFit.cover,
                                  )
                            : const Center(
                                child: Icon(Icons.insert_drive_file, size: 40),
                              ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.light.defaultColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close,
                                size: 18, color: AppTheme.light.background),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _removeAttachment(index),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration:
                BoxDecoration(color: themeColors.background, boxShadow: [
              BoxShadow(
                color: themeColors.text.withOpacity(0.1),
                blurRadius: 4.0,
                offset: const Offset(0, -2),
              )
            ]),
            child: Row(
              children: [
                if (ProjectConfig.chatUploadingDocEnabled)
                  IconButton(
                    icon: Icon(Icons.attach_file,
                        color: themeColors.defaultColor),
                    onPressed: _pickFiles,
                  ),
                if (_selectedFiles.isNotEmpty)
                  IconButton(
                    icon: Tooltip(
                      message: 'View Once',
                      child: Icon(
                        _isViewOnceEnabled
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined,
                        color: _isViewOnceEnabled
                            ? themeColors.success
                            : themeColors.defaultColor,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isViewOnceEnabled = !_isViewOnceEnabled;
                      });
                    },
                  ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    style: TextStyle(color: themeColors.text),
                    maxLines: null,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: themeColors.defaultColor,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: themeColors.defaultColor,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: themeColors.defaultColor,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: themeColors.defaultColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: themeColors.success),
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
      List<ChatMessageEntity> messages, MessageScreenVM viewModel) {
    final sortedMessages = List<ChatMessageEntity>.from(messages)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      itemCount: sortedMessages.length,
      itemBuilder: (context, index) {
        if (index == sortedMessages.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final store = StoreProvider.of<AppState>(context);
        final isDarkMode = store.state.prefState.enableDarkMode;
        final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;
        final message = sortedMessages[index];
        final isSent = message.senderId == viewModel.currentUserId;

        if (message.isViewOnce) {
          return Align(
            alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              padding: const EdgeInsets.all(12.0),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                color: isSent ? themeColors.sentMessageBackground : themeColors.background,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: _buildMessageAttachment(message),
              ),
            ),
          );
        }

        return Align(
          alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isSent ? themeColors.sentMessageBackground : themeColors.background,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.attachments.isNotEmpty)
                  _buildMessageAttachment(message),
                if (message.content.isNotEmpty)
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isSent && isDarkMode ? AppTheme.light.text : themeColors.text,
                    ),
                  ),
                const SizedBox(height: 4.0),
                DefaultTextStyle(
                  style: TextStyle(
                    color:isSent && isDarkMode ? AppTheme.light.textSecondary : themeColors.textSecondary,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                  child: LiveText(
                    () => timeago.format(
                      message.createdAtDate,
                      locale: '${localeSelector(store.state, twoLetter: true)}_short',
                    ),
                    duration: const Duration(minutes: 1),
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
