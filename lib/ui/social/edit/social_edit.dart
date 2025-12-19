import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/social/edit/social_edit_vm.dart';
import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'dart:convert';

class SocialEdit extends StatefulWidget {
  const SocialEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SocialEditVM viewModel;

  @override
  _SocialEditState createState() => _SocialEditState();
}

class _SocialEditState extends State<SocialEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_socialEdit');
  final _debouncer = Debouncer();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  List<Map<String, dynamic>> _selectedImages = [];
  List<String> _existingImageUrls = [];
  List<TextEditingController> _controllers = [];
  String _category = '';
  List<String> _tags = [];
  bool _isUploading = false;

  final List<String> _categoryOptions = [
    'General',
    'News',
    'Event',
    'Personal',
    'Announcement'
  ];

  @override
  void didChangeDependencies() {
    _controllers = [_contentController, _tagController];
    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final social = widget.viewModel.social;
    _contentController.text = social.content;

    if (social.photos.isNotEmpty) {
      try {
        _existingImageUrls = List<String>.from(json.decode(social.photos));
      } catch (e) {
        printL('Error parsing photos: $e');
      }
    }

    if (social.category.isNotEmpty) {
      _category = social.category;
    }

    if (social.tags.isNotEmpty) {
      _tags = social.tags.split(',').map((tag) => tag.trim()).toList();
    }

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
      final social = widget.viewModel.social.rebuild((b) => b
        ..content = _contentController.text.trim()
        ..category = _category
        ..tags = _tags.join(', '));

      if (social != widget.viewModel.social) {
        widget.viewModel.onChanged(social);
      }
    });
  }

  Future<void> _pickImages() async {
    final pickedImages =
        await PhotoUploadHelper.pickImages(allowMultiple: true);

    if (pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedImages);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);

      final social = widget.viewModel.social
          .rebuild((b) => b..photos = json.encode(_existingImageUrls));

      widget.viewModel.onChanged(social);
    });
  }

  void _updateCategory(String? newCategory) {
    if (newCategory != null) {
      setState(() {
        _category = newCategory;
        _onChanged();
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _onChanged();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      _onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final social = viewModel.social;
    final theme = Theme.of(context);

    return EditScaffold(
      title: social.isNew ? localization.newSocial : localization.editSocial,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) async {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }

        setState(() {
          _isUploading = true;
        });

        List<Map<String, dynamic>> allImages = [];

        for (String url in _existingImageUrls) {
          allImages.add({
            'type': 'url',
            'data': url,
          });
        }

        for (Map<String, dynamic> image in _selectedImages) {
          allImages.add({
            'type': 'new',
            'name': image['name'],
            'mime': image['type'],
            'data': base64Encode(image['bytes']),
          });
        }

        final updatedSocial =
            social.rebuild((b) => b..photos = json.encode(allImages));

        viewModel.onChanged(updatedSocial);
        viewModel.onSavePressed(context);

        setState(() {
          _isUploading = false;
        });
      },
      entity: social,
      body: Form(
        key: _formKey,
        child: Builder(builder: (BuildContext context) {
          return ScrollableListView(
            children: <Widget>[
              if (_isUploading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Uploading images...'),
                      ],
                    ),
                  ),
                ),
              FormCard(
                children: <Widget>[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'What\'s on your mind?',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Write something...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          _selectedImages.isEmpty &&
                          _existingImageUrls.isEmpty) {
                        return 'Please write something or add an image';
                      }
                      return null;
                    },
                  ),
                  if (_existingImageUrls.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Existing Images', style: theme.textTheme.titleSmall),
                    SizedBox(height: 8),
                    Container(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _existingImageUrls.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(_existingImageUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 13,
                                child: GestureDetector(
                                  onTap: () => _removeExistingImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  if (_selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('New Images', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        _selectedImages[index]['bytes']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 13,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: _pickImages,
                        child: const Row(
                          children: [
                            Icon(Icons.photo_library, color: Colors.green),
                            SizedBox(width: 5),
                            Text('Add Photos'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: _category.isNotEmpty ? _category : null,
                    hint: const Text('Select a category'),
                    items: _categoryOptions.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: _updateCategory,
                  ),
                  const SizedBox(height: 16),
                  Text('Tags', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => _removeTag(tag),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tagController,
                          decoration: const InputDecoration(
                            hintText: 'Add a tag...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onFieldSubmitted: (value) {
                            _addTag(value);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (FocusScope.of(context).hasFocus) {
                                FocusScope.of(context).unfocus();
                              }
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final tagText = _tagController.text.trim();
                          if (tagText.isNotEmpty) {
                            _addTag(tagText);
                            _tagController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
