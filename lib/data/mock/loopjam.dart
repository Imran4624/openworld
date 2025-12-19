import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> loopjamQuestions = {
  'name': 'Create Profile',
  'textOnSubmit': 'Profile details updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'personal_details',
      'group': 'Personal Details',
      'description': "Thank you for joining! Let's get to know you better.",
      'icon': Icons.person,
      'questions': [
        // {
        //   'id': DynamicFieldsConstants.name,
        //   'type': InputType.Text,
        //   'placeholder': 'Enter your name',
        //   'label': 'Name',
        //   'icon': Icons.text_fields,
        //   'editOrder': 1,
        //   'viewOrder': 1,
        //   'required': true,
        //   // 'info': 'This will be shown on your profile',
        //   'searchable': 'None',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // },
        // {
        //   'id': DynamicFieldsConstants.images,
        //   'type': InputType.Document,
        //   'placeholder': '',
        //   'label':
        //       'Upload your photo',
        //   'minValue': 1,
        //   'maxValue': 1,
        //   'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
        //   'icon': Icons.image,
        //   'editOrder': 2,
        //   'viewOrder': 2,
        //   'defautValue': 2,
        //   'required': true,
        //   'showInLine': false,
        //   'searchable': 'None',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // },
      ]
    },
  ]
};
