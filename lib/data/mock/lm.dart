import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> lmQuestions = {
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
        {
          'id': DynamicFieldsConstants.name,
          'type': InputType.Text,
          'placeholder': 'Enter your name',
          'label': 'Name',
          'icon': Icons.text_fields,
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          // 'info': 'This will be shown on your profile',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': DynamicFieldsConstants.reason,
          'type': InputType.ListMultiselect,
          'placeholder': '',
          'label': 'I\'m here to',
          'icon': Icons.text_fields,
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          // 'info': 'This will be shown on your profile',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Find a running buddy', 'value': 1},
            {'name': 'Train for the Marathon', 'value': 2},
            {'name': 'Get free Marathon photos', 'value': 3},
            {'name': 'Join running events', 'value': 4},
            {'name': 'Support my runner on Marathon day', 'value': 5},
            // {'name': 'Other', 'value': 3},
          ],
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'Location',
          'type': InputType.Text,
          'condition': '${DynamicFieldsConstants.reason} in 1',
          'placeholder': '',
          'label': 'Where are you from',
          'icon': Icons.date_range,
          'editOrder': 2,
          'viewOrder': 2,
          'required': false,
          'info': 'Town where you live',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': -1,
          'isMultiSelect': false,
          'isRangeSelect': true,
          'isSearchable': false
        },
        // {
        //   //dob
        //   'id': DynamicFieldsConstants.dob,
        //   'type': InputType.Date,
        //   'placeholder': 'Enter your date of birth',
        //   'label': 'Date of Birth',
        //   'icon': Icons.calendar_today,
        //   'editOrder': 2,
        //   'viewOrder': -1,
        //   'required': true,
        //   'info': 'This will be shown on your profile',
        //   'input_options': {
        //     'use_text_field': false,
        //     'use_dropdowns': true,
        //     'fields': [
        //       {
        //         'id': 'day',
        //         'type': InputType.Dropdown,
        //         'placeholder': 'Day',
        //         'options':
        //             List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'))
        //       },
        //       {
        //         'id': 'month',
        //         'type': InputType.Dropdown,
        //         'placeholder': 'Month',
        //         'options': [
        //           {'label': 'January', 'value': '01'},
        //           {'label': 'February', 'value': '02'},
        //           {'label': 'March', 'value': '03'},
        //           {'label': 'April', 'value': '04'},
        //           {'label': 'May', 'value': '05'},
        //           {'label': 'June', 'value': '06'},
        //           {'label': 'July', 'value': '07'},
        //           {'label': 'August', 'value': '08'},
        //           {'label': 'September', 'value': '09'},
        //           {'label': 'October', 'value': '10'},
        //           {'label': 'November', 'value': '11'},
        //           {'label': 'December', 'value': '12'}
        //         ]
        //       },
        //       {
        //         'id': 'year',
        //         'type': InputType.Dropdown,
        //         'placeholder': 'Year',
        //         'options': List.generate((DateTime.now().year - 18) - 1965 + 1,
        //             (i) => (1965 + i).toString()),
        //         'searchable': true
        //       }
        //     ]
        //   },
        //   'searchable': 'None',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // },
        // {
        //   //gender
        //   'id': 'gender',
        //   'type': InputType.List, //InputType.Radio,
        //   'label': 'Gender',
        //   'editOrder': 4,
        //   'viewOrder': 4,
        //   'required': true,
        //   'info': 'This will be shown on your profile',
        //   'selectedField': 'value',
        //   'showField': 'name',
        //   'sortField': 'name',
        //   'options': [
        //     {'name': 'Male', 'value': 1},
        //     {'name': 'Female', 'value': 2},
        //     {'name': 'Other', 'value': 3},
        //   ],
        //   'searchable': 'ShowInAdvanceSearch',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // },
        // {
        //   'id': DynamicFieldsConstants.images,
        //   'type': InputType.Document,
        //   'label': 'Please upload up to 3 images of yourself',
        //   'icon': Icons.image,
        //   'editOrder': 10,
        //   'viewOrder': 10,
        //   'minValue': 1,
        //   'maxValue': 3,
        //   'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
        //   'required': true,
        //   'showInLine': true,
        //   'searchable': 'None',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // },
        // {
        //   'id': DynamicFieldsConstants.socialLinks,
        //   'type': InputType.Text,
        //   'required': true,
        //   'editOrder': 5,
        //   'viewOrder': 5,
        //   'icon': Icons.person,
        //   'placeholder': "Social Links",
        //   'info':
        //       'To proceed with approval, please share your LinkedIn, Instagram, or Facebook URL.',
        //   'label': "Social Links",
        //   'searchable': 'None',
        // },
        // {
        //   'id': 'about_me',
        //   'type': InputType.Text,
        //   'placeholder': 'About me',
        //   'label': 'Let others know a bit about yourself',
        //   'icon': Icons.text_fields,
        //   'editOrder': 20,
        //   'viewOrder': 20,
        //   'required': false,
        //   'info': 'You can do this later',
        //   'searchable': 'None',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // }
      ]
    },
  ]
};
