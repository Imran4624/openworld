import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> cacQuestions = {
  'name': 'Create Profile',
  'textOnSubmit': 'Profile details updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'personal_details',
      'group': 'Personal Details',
      'description':
          "Thank you for joining Cocktails & Conversation! Let's get to know you better.",
      'icon': Icons.person,
      'slider': {
        'content': [
          {
            'image':
                'https://firebasestorage.googleapis.com/v0/b/cocktails-d9e40.firebasestorage.app/o/static_assets%2F4.webp?alt=media&token=a768cfbf-7522-4e21-8efc-d9f0ac0015e7',
            'title': '',
            'description': ''
          },
          {
            'image':
                'https://firebasestorage.googleapis.com/v0/b/cocktails-d9e40.firebasestorage.app/o/static_assets%2F5.webp?alt=media&token=1cc495e3-2727-4e44-8619-772df7369035',
            'title': '',
            'description': ''
          },
          {
            'image':
                'https://firebasestorage.googleapis.com/v0/b/cocktails-d9e40.firebasestorage.app/o/static_assets%2F6.webp?alt=media&token=8a5ab909-485c-45d6-9eb6-515c31908bd5',
            'title': '',
            'description': ''
          },
        ]
      },
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
          'info': 'This will be shown on your profile',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 1,
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'email',
          'type': InputType.Text,
          'placeholder': 'Enter your email',
          'label': 'Email',
          'icon': Icons.email,
          'editOrder': -1,
          'viewOrder': -1,
          'required': true,
          'info': 'This will be used for communication',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 2,
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'Location',
          'type': InputType.Text,
          'placeholder': '',
          'label': 'Where are you from',
          'icon': Icons.date_range,
          'editOrder': 3,
          'viewOrder': 3,
          'required': false,
          'info': 'Town where you live',
          'searchable': 'None',
          'searchOrder': -1,
          'isMultiSelect': false,
          'isRangeSelect': true,
          'isSearchable': false
        },
        {
          'id': 'Occupation',
          'type': InputType.Text,
          'placeholder': '',
          'label': 'Occupation',
          'icon': Icons.date_range,
          'editOrder': 4,
          'viewOrder': 4,
          'required': false,
          'info': 'This will be shown on your profile',
          'searchable': 'None',
          'searchOrder': -11,
          'isMultiSelect': false,
          'isRangeSelect': true,
          'isSearchable': false
        },
        {
          //dob
          'id': DynamicFieldsConstants.dob,
          'type': InputType.Date,
          'placeholder': 'Enter your date of birth',
          'label': 'Date of Birth',
          'icon': Icons.calendar_today,
          'editOrder': 5,
          'viewOrder': -1,
          'required': true,
          'info': 'This will be shown on your profile',
          'input_options': {
            'use_text_field': false,
            'use_dropdowns': true,
            'fields': [
              {
                'id': 'day',
                'type': InputType.Dropdown,
                'placeholder': 'Day',
                'options':
                    List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'))
              },
              {
                'id': 'month',
                'type': InputType.Dropdown,
                'placeholder': 'Month',
                'options': [
                  {'label': 'January', 'value': '01'},
                  {'label': 'February', 'value': '02'},
                  {'label': 'March', 'value': '03'},
                  {'label': 'April', 'value': '04'},
                  {'label': 'May', 'value': '05'},
                  {'label': 'June', 'value': '06'},
                  {'label': 'July', 'value': '07'},
                  {'label': 'August', 'value': '08'},
                  {'label': 'September', 'value': '09'},
                  {'label': 'October', 'value': '10'},
                  {'label': 'November', 'value': '11'},
                  {'label': 'December', 'value': '12'}
                ]
              },
              {
                'id': 'year',
                'type': InputType.Dropdown,
                'placeholder': 'Year',
                'options': List.generate((DateTime.now().year - 18) - 1965 + 1,
                    (i) => (1965 + i).toString()),
                'searchable': true
              }
            ]
          },
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //gender
          'id': 'gender',
          'type': InputType.List, //InputType.Radio,
          'label': 'Gender',
          'editOrder': 6,
          'viewOrder': 6,
          'required': true,
          'info': 'This will be shown on your profile',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Male', 'value': 1},
            {'name': 'Female', 'value': 2},
            {'name': 'Other', 'value': 3},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': DynamicFieldsConstants.images,
          'type': InputType.Document,
          'label': 'Please upload up to 3 images of yourself',
          'icon': Icons.image,
          'editOrder': 10,
          'viewOrder': 10,
          'minValue': 1,
          'maxValue': 3,
          'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
          'required': true,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': DynamicFieldsConstants.socialLinks,
          'type': InputType.Text,
          'required': true,
          'editOrder': 7,
          'viewOrder': 7,
          'icon': Icons.person,
          'placeholder': "Social Links",
          'info':
              'To proceed with approval, please share your LinkedIn, Instagram, or Facebook URL.',
          'label': "Social Links",
          'searchable': 'None',
        },
        {
          'id': 'about_me',
          'type': InputType.Text,
          'placeholder': 'About me',
          'label': 'Let others know a bit about yourself',
          'icon': Icons.text_fields,
          'editOrder': 8,
          'viewOrder': 8,
          'required': false,
          'info': 'You can do this later',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    },
  ]
};
