// First, make sure to add these imports:
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/dynamic_field_drived_values.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart' as path;

class FormSubmissionResult {
  final Map<String, dynamic> flatData;
  final Map<String, dynamic> formattedData;

  FormSubmissionResult({
    required this.flatData,
    required this.formattedData,
  });
}

class FormSubmissionHandler {
  static Future<FormSubmissionResult> handleSubmit({
    required List<QuestionGroupModel> questionGroups,
    required dynamic answers,
    required BuildContext context,
    required DynamicFieldSubmissionType type,
    bool showLoadingDialog = true,
  }) async {
    try {
      if (showLoadingDialog) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final Map<String, dynamic> formattedData = {};
      final Map<String, dynamic> flatData = {};

      final store = StoreProvider.of<AppState>(context);
      final state = store.state;
      final currentUserId = state.user.id;

      Map<String, dynamic> flatAnswers;
      if (answers is Map<String, Map<String, dynamic>>) {
        flatAnswers = {};
        answers.forEach((groupName, groupAnswers) {
          groupAnswers.forEach((key, value) {
            flatAnswers[key] = value;
          });
        });
      } else {
        flatAnswers = Map<String, dynamic>.from(answers);
      }

      for (var group in questionGroups) {
        final groupData = <String, dynamic>{};

        for (var question in group.getQuestions(type)) {
          final answer = flatAnswers[question.id];
          if (answer == null) continue;

          // if (question.id == 'age' || question.id == 'dob') {
          //   printL('calling');
          //   DateTime dobDate = DateTime.parse(answer);

          //   Timestamp dobTimestamp = Timestamp.fromDate(dobDate);
          //   _processAgeField(question, flatAnswers, groupData);
          //   flatData[question.id] = dobTimestamp;
          //   continue;
          // }
          if (question.id == 'age') {
            if (answer is int) {
              flatData[question.id] = answer;
            } else if (answer is String) {
              try {
                flatData[question.id] = int.parse(answer);
              } catch (e) {
                try {
                  DateTime dobDate = DateTime.parse(answer);
                  flatData[question.id] =
                      DerivedFieldUtils.calculateAge(dobDate);
                } catch (e) {
                  printL('Error parsing as date: $e');
                  flatData[question.id] = answer;
                }
              }
            } else if (answer is DateTime) {
              flatData[question.id] = DerivedFieldUtils.calculateAge(answer);
            } else {
              try {
                flatData[question.id] = int.parse(answer.toString());
              } catch (e) {
                printL('Error converting to int: $e');
                flatData[question.id] = answer;
              }
            }

            _processAgeField(question, flatAnswers, groupData);

            continue;
          }
          if (question.id == 'dob') {
            printL('Processing dob field');

            if (answer is DateTime) {
              flatData[question.id] = answer.toIso8601String();
            } else if (answer is String) {
              try {
                DateTime dobDate = DateTime.parse(answer);
                flatData[question.id] = dobDate.toIso8601String();
              } catch (e) {
                printL('Error parsing dob string: $e');
                flatData[question.id] = answer;
              }
            } else {
              flatData[question.id] = answer.toString();
            }

            _processAgeField(question, flatAnswers, groupData);

            continue;
          }
          if (question.type == InputType.Document && answer is List) {
            final List<Map<String, dynamic>> typedAnswer = answer.map((item) {
              if (item is String) {
                return {'url': item, 'action': 'existing'};
              } else if (item is Map<String, dynamic> &&
                  item.containsKey('url')) {
                return {...item, 'action': 'existing'};
              } else if (item is Map<String, dynamic>) {
                if (item.containsKey('bytes') && !item.containsKey('action')) {
                  return {...item, 'action': 'added'};
                }
                return item;
              } else {
                throw TypeError();
              }
            }).toList();

            final uploadedUrls = await _uploadFiles(typedAnswer, currentUserId);
            printL('urls to upload ==> $uploadedUrls');
            flatData[question.id] = uploadedUrls;
            groupData[question.label] = uploadedUrls.join(', ');
            continue;
          }

          flatData[question.id] = answer;
          groupData[question.label] = _formatAnswerForDisplay(question, answer);
        }

        if (groupData.isNotEmpty) {
          formattedData[group.id] = groupData;
        }
      }

      if (showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      return FormSubmissionResult(
        flatData: flatData,
        formattedData: formattedData,
      );
    } catch (e) {
      if (showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: ${e.toString()}')),
        );
      }

      rethrow;
    }
  }

  static void _processAgeField(
    QuestionModel question,
    Map<String, dynamic> answers,
    Map<String, dynamic> groupData,
  ) {
    try {
      final dob = answers['dob'];
      if (dob != null) {
        DateTime dobDate = DateTime.parse(dob);

        Timestamp dobTimestamp = Timestamp.fromDate(dobDate);

        answers['dob'] = dobTimestamp;

        int age = DerivedFieldUtils.calculateAge(dobDate);
        groupData[question.label] = age.toString();
      } else {
        groupData[question.label] = 'N/A';
      }
    } catch (e) {
      printL('Error processing DOB: $e');
      groupData[question.label] = 'N/A';
    }
  }

  static String _formatAnswerForDisplay(
      QuestionModel question, dynamic answer) {
    if (question.isListType() || question.isDropdown() || question.isRadio()) {
      return _formatOptionBasedAnswer(question, answer);
    }

    if (question.isTagsType()) {
      return _formatTagsAnswer(answer);
    }

    return answer.toString();
  }

  static String _formatOptionBasedAnswer(
      QuestionModel question, dynamic value) {
    List<String> displayValues = [];
    final valueList = value is String
        ? value.split(',').map((v) => v.trim()).toList()
        : (value is List ? value : [value]);

    for (var selectedValue in valueList) {
      try {
        final options = question.options as List;
        final option = options.firstWhere(
          (option) =>
              option[question.selectedField ?? 'value'].toString() ==
              selectedValue.toString(),
        );
        displayValues.add(option[question.showField ?? 'name'].toString());
      } catch (_) {
        displayValues.add(selectedValue.toString());
      }
    }

    return displayValues.join(', ');
  }

  static String _formatTagsAnswer(dynamic value) {
    if (value is List) {
      return value.map((v) => v.toString()).join(', ');
    }
    return value.toString();
  }

  static Future<List<String>> _uploadFiles(
      List<Map<String, dynamic>> files, String currentUserId) async {
    final List<String> uploadedUrls = [];
    String _getContentType(String extension) {
      switch (extension) {
        case '.jpg':
        case '.jpeg':
          return 'image/jpeg';
        case '.png':
          return 'image/png';
        case '.pdf':
          return 'application/pdf';
        case '.doc':
        case '.docx':
          return 'application/msword';
        default:
          return 'application/octet-stream';
      }
    }

    for (final file in files) {
      if (file['action'] == 'added') {
        try {
          final fileExtension = path.extension(file['name']).toLowerCase();

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('userProfileImages')
              .child(currentUserId)
              .child(
                  '${DateTime.now().millisecondsSinceEpoch}_${file['name']}');

          UploadTask uploadTask;
          if (isWeb()) {
            if (file['bytes'] == null || file['bytes']!.isEmpty) {
              throw Exception('No file data available');
            }
            uploadTask = storageRef.putData(
              file['bytes']!,
              SettableMetadata(contentType: _getContentType(fileExtension)),
            );
          } else {
            // Fix for iOS: Check for both bytes and path
            if (file['bytes'] != null && file['bytes']!.isNotEmpty) {
              // Use bytes if available (works on iOS)
              uploadTask = storageRef.putData(
                file['bytes']!,
                SettableMetadata(contentType: _getContentType(fileExtension)),
              );
            } else if (file['path'] != null) {
              // Use File path as fallback
              uploadTask = storageRef.putFile(
                File(file['path']!),
                SettableMetadata(contentType: _getContentType(fileExtension)),
              );
            } else {
              throw Exception('Neither file bytes nor path available');
            }
          }

          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          uploadedUrls.add(downloadUrl);
        } catch (e) {
          printL('Error uploading file: ${e.toString()}');
          rethrow;
        }
      } else if (file['action'] == 'deleted') {
        try {
          if (file.containsKey('url')) {
            final url = file['url'];
            final ref = FirebaseStorage.instance.refFromURL(url);
            await ref.delete();
            printL('File deleted successfully: $url');
          } else {
            printL('No URL provided for deletion');
          }
        } catch (e) {
          printL('Error deleting file: ${e.toString()}');
          rethrow;
        }
      } else if (file['action'] == 'existing') {
        final url = file['url'];
        uploadedUrls.add(url);
      }
    }
    return uploadedUrls;
  }
}
