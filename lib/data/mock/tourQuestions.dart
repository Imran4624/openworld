import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> tourQuestions = {
  'name': 'Tour Questions',
  'textOnSubmit': 'tourQuestions updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'dates',
      'group': 'Dates',
      'description': 'Provide trip dates information',
      'show_intro_screen': false,
      'show_all_questions': true,
      'icon': Icons.date_range,
      'questions': [
        {
          'id': 'how_many_days',
          'type': InputType.NumberIncrementable,
          'placeholder': 'Enter the number of days',
          'label': 'How many days?',
          'icon': Icons.timer,
          'editOrder': 1,
          'viewOrder': 1,
          'defautValue': 2,
          'minValue': 1,
          'maxValue': 3,
          'required': true,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'start_date',
          'type': InputType.ClassicDate,
          'placeholder': 'Add start date (optional)',
          'label': 'Start Date',
          'icon': Icons.calendar_today,
          'editOrder': 2,
          'viewOrder': 2,
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
      'id': 'guests',
      'group': "Who's going?",
      'description':
          "Let us know who's going and we'll use this info to tailor your itinerary.",
      'icon': Icons.group,
      'show_intro_screen': false,
      'show_all_questions': true,
      'questions': [
        {
          'id': 'adult',
          'type': InputType.NumberIncrementable,
          'placeholder': 'Number of adults',
          'label': 'Adult',
          'icon': Icons.person,
          'editOrder': 1,
          'viewOrder': 1,
          'defautValue': 2,
          'minValue': 1,
          'maxValue': 5,
          'required': true,
          'showInLine': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'children',
          'type': InputType.NumberIncrementable,
          'placeholder': 'Number of children',
          'label': 'Children',
          'icon': Icons.child_care,
          'editOrder': 2,
          'viewOrder': 2,
          'defautValue': 2,
          'minValue': 0,
          'maxValue': 5,
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
      'id': 'attractions',
      'group': 'Attractions',
      'description': 'Choose what you want to see',
      'icon': Icons.attractions,
      'questions': [
        {
          'id': 'what_to_see',
          'type': InputType.GridMultiSelect,
          'placeholder': 'Select attractions',
          'label': 'What do you want to see?',
          'icon': Icons.landscape,
          'editOrder': 1,
          'viewOrder': 1,
          'required': false,
          'showField': 'image,name,category,time',
          'sortField': 'name',
          'selectedField': 'value',
          'options': [
            {
              'name': 'Beaches',
              'value': 1,
              'image':
                  'https://photographylife.com/wp-content/uploads/2023/05/Nikon-Z8-Official-Samples-00002.jpg',
              'category': 'Nature',
              'time': '2-3 hours'
            },
            {
              'name': 'Mountains',
              'value': 2,
              'image':
                  'https://photographylife.com/wp-content/uploads/2023/05/Nikon-Z8-Official-Samples-00002.jpg',
              'category': 'Adventure',
              'time': 'Half a day'
            },
            {
              'name': 'Museums',
              'value': 3,
              'image':
                  'https://photographylife.com/wp-content/uploads/2023/05/Nikon-Z8-Official-Samples-00002.jpg',
              'category': 'History',
              'time': 'Up to an hour'
            },
            {
              'name': 'Historical Sites',
              'value': 4,
              'image':
                  'https://photographylife.com/wp-content/uploads/2023/05/Nikon-Z8-Official-Samples-00002.jpg',
              'category': 'Cultural',
              'time': '2-3 hours'
            }
          ],
          'searchable': 'ShowInAdvanceSearch',
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    },
    {
      'id': 'starting_point',
      'group': 'Starting Point',
      'description': 'Provide your starting location',
      'icon': Icons.location_on,
      'questions': [
        {
          'id': 'starting_address',
          'type': InputType.Location,
          'placeholder': 'Add starting address',
          'label': 'Where are you starting your trip?',
          'icon': Icons.place,
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    }
  ]
};
