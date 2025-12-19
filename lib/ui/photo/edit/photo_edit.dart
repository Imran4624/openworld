import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class PhotoEdit extends StatefulWidget {
  const PhotoEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final PhotoEditVM viewModel;

  @override
  _PhotoEditState createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_photoEdit');
  final _debouncer = Debouncer();

  // STARTER: controllers - do not remove comment
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _isEditMode = false;
  List<TextEditingController> _controllers = [];
  List<Map<String, dynamic>> _images = [];
  bool _isImageLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = !widget.viewModel.photo.isNew;
  }

  @override
  void didChangeDependencies() {
    _controllers = [
      // STARTER: array - do not remove comment
      _categoryController,
      _tagsController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final photo = widget.viewModel.photo;
    // STARTER: read value - do not remove comment
    _categoryController.text = photo.category.toString();
    _tagsController.text = photo.tags.toString();

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    _debouncer.run(() {
      final photo = widget.viewModel.photo.rebuild((b) => b
        // STARTER: set value - do not remove comment
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
          await PhotoUploadHelper.pickImages(allowMultiple: !_isEditMode);

      setState(() {
        _isImageLoading = false;
        if (images.isNotEmpty) {
          if (_isEditMode) {
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
      logError(' Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final photo = viewModel.photo;
    final colorScheme = Theme.of(context).colorScheme;

    final title = _isEditMode
        ? localization.editPhoto
        : _images.isEmpty
            ? localization.newPhoto
            : 'Upload ${_images.length} Photos';

    return EditScaffold(
      title: title,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }

        final BuildContext currentContext = context;
        if (_isEditMode) {
          viewModel.onSavePressed(currentContext, null);
        } else {
          if (_images.isEmpty) {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              const SnackBar(content: Text('Please select at least one photo')),
            );
          } else {
            viewModel.onUploadMultiplePhotos(
                currentContext,
                _categoryController.text.trim(),
                _tagsController.text.trim(),
                _images);
          }
        }
      },
      entity: photo,
      body: Form(
        key: _formKey,
        child: Builder(builder: (BuildContext context) {
          return ScrollableListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              FormCard(
                children: <Widget>[
                  // Category Field
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 16),
                  //   child: TextFormField(
                  //     controller: _categoryController,
                  //     autocorrect: false,
                  //     style: TextStyle(fontSize: 16),
                  //     decoration: InputDecoration(
                  //       labelText: 'Category',
                  //       labelStyle: TextStyle(
                  //         color: Colors.grey[700],
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 16,
                  //       ),
                  //       filled: true,
                  //       fillColor: Colors.grey[50],
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //         borderSide: BorderSide(color: Colors.grey[300]!),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //         borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  //       ),
                  //       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  //       prefixIcon: Icon(Icons.category, color: colorScheme.primary),
                  //     ),
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter a category';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),

                  // Container(
                  //   margin: EdgeInsets.only(bottom: 24),
                  //   child: TextFormField(
                  //     controller: _tagsController,
                  //     autocorrect: false,
                  //     style: TextStyle(fontSize: 16),
                  //     decoration: InputDecoration(
                  //       labelText: 'Tags (comma separated)',
                  //       labelStyle: TextStyle(
                  //         color: Colors.grey[700],
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 16,
                  //       ),
                  //       filled: true,
                  //       fillColor: Colors.grey[50],
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //         borderSide: BorderSide(color: Colors.grey[300]!),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //         borderSide:
                  //             BorderSide(color: colorScheme.primary, width: 2),
                  //       ),
                  //       contentPadding:
                  //           EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  //       prefixIcon: Icon(Icons.tag, color: colorScheme.primary),
                  //       hintText: 'e.g., nature, landscape, travel',
                  //     ),
                  //   ),
                  // ),

                  if (_isEditMode) ...[
                    Text(
                      'Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                        color: Colors.grey[100],
                      ),
                      child: photo.url.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : viewModel.state.photoUIState.defaultImageData !=
                                  null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    viewModel.state.photoUIState
                                            .defaultImageData!['bytes']
                                        as Uint8List,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    photo.url,
                                    fit: BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Image failed to load',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ),
                    Text(
                      'Image: ${photo.url.isEmpty ? "None" : "Set"}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: viewModel.isSaving
                                ? null
                                : () {
                                    viewModel.onRemoveImagePressed(context);
                                  },
                            icon: viewModel.isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.delete_forever),
                            label: Text(viewModel.isSaving
                                ? 'Deleting...'
                                : 'Delete Photo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isImageLoading ? null : _pickImages,
                            icon: _isImageLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.photo_library),
                            label: const Text('Replace Image'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 64,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Drag & drop photos here',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _isImageLoading ? null : _pickImages,
                            icon: _isImageLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add_photo_alternate),
                            label: const Text('Browse Photos'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_images.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_images.length} Photos Selected',
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
                              icon: const Icon(Icons.delete_sweep, size: 18),
                              label: const Text('Clear All'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    imageData['bytes'] as Uint8List,
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
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
