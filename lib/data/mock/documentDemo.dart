import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> documentDemoQuestions = {
  'name': 'DocumentDemo Questions',
  'textOnSubmit': 'documentDemoQuestions updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'intro',
      'group': 'Introduction',
      'description':
          "This is an introductory screen to make sure you're keeping your customers engaged and you're not getting high blood pressure by filling answers your silly questions.",
      'icon': Icons.waving_hand,
      'show_intro_screen': true,
      'show_all_questions': true,
      'questions': [
        {
          'id': 'name',
          'type': InputType.Text,
          'placeholder': 'Enter your name',
          'label': 'Name',
          'icon': Icons.text_fields,
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'photo',
          'type': InputType.Document,
          'label': 'How you look like',
          'icon': Icons.image,
          'editOrder': 2,
          'viewOrder': 2,
          'minValue': 0,
          'maxValue': 1,
          'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
          'required': false,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    },
    {
      'id': 'professional',
      'group': 'Professional Documents',
      'description':
          "I'm happy you have made it so far. Now its time to upload your documents for a professional application.",
      'icon': Icons.work,
      'show_intro_screen': true,
      'show_all_questions': true,
      'questions': [
        {
          'id': 'resume',
          'type': InputType.Document,
          'label': 'Upload your work experience and resume',
          'icon': Icons.description,
          'editOrder': 1,
          'viewOrder': 1,
          'minValue': 2,
          'maxValue': 7,
          'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
          'required': true,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    },
    {
      'id': 'certificates',
      'group': 'Certificates',
      'description':
          'This is last step, you can upload any certificates you want.',
      'icon': Icons.school,
      'show_intro_screen': true,
      'show_all_questions': true,
      'questions': [
        {
          'id': 'certs',
          'type': InputType.Document,
          'label': 'Upload certificates',
          'icon': Icons.file_upload,
          'editOrder': 1,
          'viewOrder': 1,
          'minValue': 0,
          'maxValue': 3,
          'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
          'required': false,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    }
  ]
};
