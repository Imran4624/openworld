import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> boilerplateQuestions = {
  'name': 'Create Profile',
  'textOnSubmit': 'Profile details updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'personal_details',
      'group': 'Welcome',
      'description':
          "Glad to have you here! Don't worry its just a sample question to get started.",
    'questions': [
      {
          'id': DynamicFieldsConstants.name,
          'type': InputType.Text,
          'placeholder': 'Enter your first name',
          'label': 'First Name',
          'icon': Icons.text_fields,
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'info': 'This will be shown on your profile',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 1,
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
      },
    ]
  },
  ]
};
