import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> opwQuestions = {
  'name': 'Create Profile',
  'textOnSubmit': 'Profile details updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'personal_details',
      'group': 'Set up your details?',
      'description': "",
      'icon': Icons.person,
      'show_all_questions': true,
      'questions': [
        {
          'id': DynamicFieldsConstants.images,
          'type': InputType.Document,
          'label': 'Upload pic',
          'icon': Icons.image,
          'editOrder': 1,
          'viewOrder': 1,
          'minValue': 1,
          'maxValue': 1,
          'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
          'required': true,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': DynamicFieldsConstants.name,
          'type': InputType.Text,
          'placeholder': 'Enter your name',
          'label': 'Name',
          'icon': Icons.text_fields,
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          'info': '',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 1,
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //dob
          'id': DynamicFieldsConstants.dob,
          'type': InputType.Date,
          'placeholder': 'Enter your date of birth',
          'label': 'Date of Birth',
          'icon': Icons.calendar_today,
          'editOrder': 4,
          'viewOrder': 4,
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
          'type': InputType.Radio,
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
      ]
    },
    {
      'id': 'personal_preferences',
      'group': 'Set up your preferences',
      'description': "",
      'icon': Icons.person,
      'questions': [
        {
          //event preferences
          'id': 'eventpreferences',
          'type': InputType.List, //InputType.Radio,
          'label': 'Event Preferences?',
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'info': '',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Music', 'value': 1},
            {'name': 'NightLife', 'value': 2},
            {'name': 'Art', 'value': 3},
            {'name': 'Food', 'value': 4},
            {'name': 'Pop-ups', 'value': 5},
            {'name': 'Gathering', 'value': 6},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //going out goals
          'id': 'goingOutGoals',
          'type': InputType.List, //InputType.Radio,
          'label': 'Going Out Goals?',
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          'info': '',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Meet new people', 'value': 1},
            {'name': 'Learn something new', 'value': 2},
            {'name': 'Enjoy a Hobby', 'value': 3},
            {'name': 'Relax with friends', 'value': 4},
            {'name': 'Career connections', 'value': 5},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //social mode
          'id': 'socialMode',
          'type': InputType.List, //InputType.Radio,
          'label': 'Social Mode?',
          'editOrder': 3,
          'viewOrder': 3,
          'required': true,
          'info': '',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Solo', 'value': 1},
            {'name': 'Friends', 'value': 2},
            {'name': 'Crowds', 'value': 3},
            {'name': 'Small Groups', 'value': 4},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //Outing Time
          'id': 'OutingTime',
          'type': InputType.List, //InputType.Radio,
          'label': 'Outing Time?',
          'editOrder': 4,
          'viewOrder': 4,
          'required': true,
          'info': 'This will be shown on your profile',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Morning', 'value': 1},
            {'name': 'Afternoon', 'value': 2},
            {'name': 'Evening', 'value': 3},
            {'name': 'Night', 'value': 4},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //why here
          'id': 'whyHere',
          'type': InputType.List, //InputType.Radio,
          'label': 'Why here?',
          'editOrder': 5,
          'viewOrder': 5,
          'required': true,
          'info': '',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Discover', 'value': 1},
            {'name': 'Meet People', 'value': 2},
            {'name': 'Feel like a local', 'value': 3},
            {'name': 'Be an Urban Explorer', 'value': 4},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //eventVibe
          'id': 'eventVibe',
          'type': InputType.List, //InputType.Radio,
          'label': 'Event Vibe?',
          'editOrder': 6,
          'viewOrder': 6,
          'required': true,
          'info': '',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'High-Energy', 'value': 1},
            {'name': 'Relaxed and informative', 'value': 2},
            {'name': 'Intellectual', 'value': 3},
            {'name': 'Creative', 'value': 4},
            {'name': 'Adventurous', 'value': 5},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //eventRole
          'id': 'eventRole',
          'type': InputType.List, //InputType.Radio,
          'label': 'Event Role?',
          'editOrder': 7,
          'viewOrder': 7,
          'required': true,
          'info': '',
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Find Events', 'value': 1},
            {'name': 'Host Events', 'value': 2},
            {'name': 'Both', 'value': 3},
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
      ]
    },
  ]
};
