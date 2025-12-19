import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/photo_model.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PhotoEditDialog extends StatefulWidget {
  final PhotoEditVM viewModel;
  final bool isEditMode;
  final VoidCallback? onClose;
  final EventEntity? selectedEvent;

  const PhotoEditDialog({
    Key? key,
    required this.viewModel,
    required this.isEditMode,
    this.selectedEvent,
    this.onClose,
  }) : super(key: key);

  @override
  State<PhotoEditDialog> createState() => _PhotoEditDialogState();
}

class _PhotoEditDialogState extends State<PhotoEditDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_photoEditDialog');
  final _debouncer = Debouncer();
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<Map<String, dynamic>> _images = [];
  bool _isImageLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controllers = [_categoryController, _tagsController];
    final photo = widget.viewModel.photo;
    _categoryController.text = photo.category.toString();
    _tagsController.text = photo.tags.toString();
    _controllers.forEach((controller) => controller.addListener(_onChanged));
    if (widget.isEditMode) {
      if (photo.url.isNotEmpty) {
        _images = [
          {
            'bytes': null,
            'url': photo.url,
          }
        ];
      }
    } else {
      _images.clear();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.removeListener(_onChanged));
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _resetSavingState() {
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _onChanged() {
    _debouncer.run(() {
      final photo = widget.viewModel.photo.rebuild((b) => b
        ..category = _categoryController.text.trim()
        ..tags = _tagsController.text.trim());
      if (photo != widget.viewModel.photo) {
        widget.viewModel.onChanged(photo);
      }
    });
  }

  Future<void> _pickImages() async {
    setState(() {
      _isImageLoading = true;
    });
    try {
      final images =
          await PhotoUploadHelper.pickImages(allowMultiple: !widget.isEditMode);
      setState(() {
        _isImageLoading = false;
        if (images.isNotEmpty) {
          if (widget.isEditMode) {
            widget.viewModel.onSingleImageSelected(images.first);
          } else {
            _images.addAll(images);
          }
        }
      });
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      print('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadPhotosInBackground(
    Store<AppState> store,
    String? eventId,
    List<Map<String, dynamic>> images,
    String category,
    String tags,
  ) async {
    try {
      if (images.isEmpty) {
        return;
      }

      final uploadCompleter = Completer<List<PhotoEntity>>();

      store.dispatch(UploadMultiplePhotosRequest(
        completer: uploadCompleter,
        category: category,
        eventId: eventId,
        tags: tags,
        imagesData: images,
      ));

      final savedPhotos = await uploadCompleter.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          throw TimeoutException('Photo upload timed out after 5 minutes');
        },
      );
      logInfo(
          'Successfully uploaded ${savedPhotos.length} photos in background');
    } catch (error) {
      logError('Error in background photo upload: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final colorScheme = Theme.of(context).colorScheme;
    final title = widget.isEditMode ? 'Edit Photo' : 'Add Photos and Videos';
    final uploadButtonText = widget.isEditMode ? 'Save' : 'Upload';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 700 ? screenWidth * 0.95 : 600.0;
    final maxDialogHeight = screenHeight * 0.85;
    final store = StoreProvider.of<AppState>(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxWidth: 700,
            maxHeight: maxDialogHeight,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Share your photos and videos directly',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 32),
                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(16),
                                dashPattern: [8, 6],
                                color: Colors.grey[300]!,
                                strokeWidth: 2,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 48, horizontal: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/loopjam/images/defaultDottedImage.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        widget.isEditMode
                                            ? 'Edit Your Photo'
                                            : 'Share Your Photos & Videos',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.isEditMode
                                            ? 'Update your photo below'
                                            : 'Drag and drop files here',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: 200,
                                        child: OutlinedButton.icon(
                                          onPressed: _isImageLoading ||
                                                  widget.isEditMode
                                              ? null
                                              : _pickImages,
                                          icon: _isImageLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Color(0xFF2218E2),
                                                  ),
                                                )
                                              : const Icon(Icons.upload,
                                                  color: Color(0xFF2218E2)),
                                          label: Text(
                                            widget.isEditMode
                                                ? 'Change Photo (disabled)'
                                                : 'Choose Files',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Color(0xFF2218E2),
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Color(0xFF2218E2),
                                                width: 1.5),
                                            backgroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_images.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_images.length <= 1 ? '${_images.length} Photo' : '${_images.length} Photos'} Selected',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _images.clear();
                                          });
                                        },
                                        icon: const Icon(Icons.delete_sweep,
                                            size: 18),
                                        label: const Text('Clear All'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 200, // Limit grid height
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: _images.length,
                                    itemBuilder: (context, index) {
                                      final imageData = _images[index];
                                      if (widget.isEditMode &&
                                          imageData['url'] != null) {
                                        // Show network image for edit mode
                                        return Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  imageData['url'],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.memory(
                                                  imageData['bytes']
                                                      as Uint8List,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 4,
                                              top: 4,
                                              child: InkWell(
                                                onTap: () =>
                                                    _removeImage(index),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bottom buttons (always visible)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : (widget.onClose ??
                                  () {
                                    _resetSavingState();
                                    Navigator.of(context).pop();
                                  }),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  final bool isValid =
                                      _formKey.currentState!.validate();
                                  if (!isValid) return;

                                  setState(() {
                                    _isSaving = true;
                                  });

                                  if (!isAuthenticated(store.state)) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => LoginDialogView(
                                        onClose: () {
                                          if (isWeb()) {
                                            setState(() {
                                              _isSaving = false;
                                            });
                                            Navigator.of(context).pop();
                                            store.dispatch(UpdateCurrentRoute(
                                                store.state.uiState
                                                    .currentRoute));
                                          } else {
                                            setState(() {
                                              _isSaving = true;
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        isDialogLogin: isMobile(context),
                                        onLoginSuccess: () {
                                          setState(() {
                                            _isSaving = false;
                                          });
                                          Debouncer.runOnComplete(() {
                                            var event = widget.selectedEvent;
                                            final currentUserId =
                                                getLoggedInUserId(store);
                                            final isAuthor =
                                                event!.createdUserId ==
                                                    currentUserId;

                                            if (!isAuthor) {
                                              final List<BuyerDetails>
                                                  attendees = event.orders
                                                      .map((order) =>
                                                          order.buyerDetails)
                                                      .toList();
                                              final isGuestOriginator = store
                                                      .state
                                                      .authState
                                                      .originator ==
                                                  OriginatorType.guest.value;
                                              final attendeeStatus =
                                                  isGuestOriginator
                                                      ? AttendeeStatus.pending
                                                      : AttendeeStatus.approved;

                                              final guestAttendee =
                                                  BuyerDetails((b) => b
                                                    ..firstName = store
                                                        .state
                                                        .authState
                                                        .currentUserName
                                                    ..lastName = ''
                                                    ..email = store
                                                        .state.authState.email
                                                    ..name = store
                                                        .state
                                                        .authState
                                                        .currentUserName
                                                    ..attendeeStatus =
                                                        attendeeStatus
                                                    ..rspv = isGuestOriginator
                                                        ? RSPV.request
                                                        : RSPV.maybe
                                                    ..phone = '');
                                              
                                              final currentUserEmail = store.state.authState.email.toLowerCase();
                                              final isAlreadyAttendee = attendees.any((attendee) => 
                                                attendee.email.toLowerCase() == currentUserEmail);
                                              
                                              if (!isAlreadyAttendee) {
                                                final newOrder = OrderEntity(
                                                    (b) => b
                                                      ..id = BaseEntity.nextId
                                                      ..status = 'completed'
                                                      ..createdAt = DateTime.now()
                                                          .millisecondsSinceEpoch
                                                      ..total = 0
                                                      ..currency = 'USD'
                                                      ..buyerDetails
                                                          .replace(guestAttendee)
                                                      ..issuedTickets =
                                                          ListBuilder<
                                                              IssuedTicket>()
                                                      ..lineItems = ListBuilder<
                                                          LineItem>());
                                                event = event.rebuild((b) => b
                                                  ..orders.add(newOrder)
                                                  ..totalOrders =
                                                      event!.totalOrders + 1);
                                              }
                                            }
                                            final Completer<EventEntity>
                                                completer =
                                                Completer<EventEntity>();
                                            printL('updated event $event');
                                            store.dispatch(SaveEventRequest(
                                                completer: completer,
                                                event: event));
                                            return completer.future
                                                .then((savedEvent) async {
                                              try {
                                                final imagesCopy = List<
                                                    Map<String,
                                                        dynamic>>.from(_images);
                                                if (imagesCopy.isNotEmpty) {
                                                  final category =
                                                      savedEvent.name.isNotEmpty
                                                          ? savedEvent.name
                                                          : 'Event Photos';
                                                  final tags = savedEvent
                                                          .description
                                                          .isNotEmpty
                                                      ? savedEvent.description
                                                      : 'Event';
                                                  await _uploadPhotosInBackground(
                                                    store,
                                                    savedEvent.id,
                                                    imagesCopy,
                                                    category,
                                                    tags,
                                                  );
                                                }
                                              } catch (e) {
                                                logError(
                                                    'Error preparing background upload: $e');
                                              }
                                              viewEntity(
                                                  entity: savedEvent,
                                                  force: true);
                                              setState(() {
                                                _isSaving = false;
                                              });
                                            }).catchError((Object error) {
                                              showDialog<ErrorDialog>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ErrorDialog(error);
                                                },
                                              );
                                              setState(() {
                                                _isSaving = false;
                                              });
                                            });
                                          });
                                        },
                                      ),
                                    );
                                    return;
                                  }

                                  if (widget.isEditMode) {
                                    await viewModel.onSavePressed(
                                        context, null);
                                    setState(() {
                                      _isSaving = false;
                                    });
                                  } else {
                                    if (_images.isEmpty) {
                                      setState(() {
                                        _isSaving = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select at least one photo')),
                                      );
                                    } else {
                                      try {
                                        await viewModel.onUploadMultiplePhotos(
                                          context,
                                          '', // category removed
                                          '', // tags removed
                                          _images,
                                        );
                                      } catch (e) {
                                        logError('Error uploading photos: $e');
                                      }
                                      setState(() {
                                        _isSaving = false;
                                      });
                                    }
                                  }
                                },
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(uploadButtonText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Close button in top right
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: _isSaving
                      ? null
                      : (widget.onClose ??
                          () {
                            _resetSavingState();
                            Navigator.of(context).pop();
                          }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
