import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

Widget buildDocumentField(
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
) {
  final allowedExtensions =
      question.allowedTypes.split(',').map((e) => e.trim()).toList() ?? [];

  return StatefulBuilder(
    builder: (context, setState) {
      final store = StoreProvider.of<AppState>(context);
      final appTheme =
          AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
      final List<Map<String, dynamic>> documents = initialValue != null
          ? (initialValue as List<dynamic>).map((item) {
              if (item is String) {
                return {'url': item, 'action': 'existing'};
              } else if (item is Map<String, dynamic>) {
                return item;
              } else {
                throw TypeError();
              }
            }).toList()
          : <Map<String, dynamic>>[];

      final int maxDocs = question.maxValue;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                children: List.generate(maxDocs, (index) {
                  if (index < documents.length &&
                      documents[index]['action'] != 'deleted') {
                    return _buildDocumentTile(
                      appTheme: appTheme,
                      documents[index],
                      onDelete: () {
                        setState(() {
                          if (documents[index].containsKey('url')) {
                            documents[index]['action'] = 'deleted';
                          } else {
                            documents.removeAt(index);
                          }

                          final activeDocuments = documents
                              .where((doc) => doc['action'] != 'deleted')
                              .toList();

                          updateAnswer(activeDocuments);

                          (context as Element).markNeedsBuild();
                        });
                      },
                    );
                  }
                  return _buildUploadTile(
                    appTheme: appTheme,
                    onTap: documents
                                .where((doc) => doc['action'] != 'deleted')
                                .length <
                            maxDocs
                        ? () async {
                            try {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                // allowedExtensions: allowedExtensions,
                                allowMultiple: true,
                                withData: true,
                              );

                              if (result != null) {
                                setState(() {
                                  final remainingSlots = maxDocs -
                                      documents
                                          .where((doc) =>
                                              doc['action'] != 'deleted')
                                          .length;
                                  final newFiles = result.files
                                      .take(remainingSlots)
                                      .map((file) => {
                                            'name': file.name,
                                            'bytes': file.bytes,
                                            'size': file.size,
                                            'type': file.extension,
                                            'action': 'added'
                                          })
                                      .toList();

                                  int firstEmptySlot = documents.indexWhere(
                                      (doc) => doc['action'] == 'deleted');
                                  if (firstEmptySlot != -1) {
                                    for (var file in newFiles) {
                                      documents.insert(firstEmptySlot, file);
                                      firstEmptySlot++;
                                    }
                                  } else {
                                    documents.addAll(newFiles);
                                  }

                                  final activeDocuments = documents
                                      .where(
                                          (doc) => doc['action'] != 'deleted')
                                      .toList();
                                  updateAnswer(activeDocuments);

                                  (context as Element).markNeedsBuild();
                                });
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error uploading file: ${e.toString()}'),
                                ),
                              );
                            }
                          }
                        : null,
                  );
                }),
              ),
            ),
          ),

          // Helper text
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Upload ${question.minValue} to ${question.maxValue} images (${allowedExtensions.join(", ")})',
              style: TextStyle(
                fontSize: 12,
                color: appTheme.defaultColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildDocumentTile(Map<String, dynamic> doc,
    {required VoidCallback onDelete, ThemeColors? appTheme}) {
  if (doc['action'] == 'deleted') return Container();

  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: appTheme!.defaultColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: doc.containsKey('url')
              ? Image.network(
                  doc['url'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.broken_image,
                          size: 40, color: appTheme.defaultColor),
                    );
                  },
                )
              : Image.memory(
                  doc['bytes'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.broken_image,
                          size: 40, color: appTheme.defaultColor),
                    );
                  },
                ),
        ),
      ),
      Positioned(
        top: 4,
        right: 4,
        child: InkWell(
          onTap: onDelete,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: appTheme.defaultColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 16, color: AppTheme.dark.text),
          ),
        ),
      ),
    ],
  );
}

Widget _buildUploadTile({VoidCallback? onTap, ThemeColors? appTheme}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: onTap != null ? appTheme!.defaultColor : appTheme!.transparent,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: onTap != null ? appTheme.defaultColor : appTheme.transparent,
        ),
      ),
    ),
  );
}
