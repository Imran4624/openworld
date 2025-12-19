import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> onboardingQuestions = {
  'name': 'OnBoarding Questions',
  'textOnSubmit': 'OnBoarding Questions updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'business_info',
      'group': 'Business Information',
      'description': "Let's get to know your business better",
      'icon': Icons.business,
      'questions': [
        {
          'id': 'business_size',
          'type': InputType.Radio,
          'placeholder': 'Select your business size',
          'label': 'Business Size',
          'icon': Icons.people,
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': '1-10 employees', 'value': 1},
            {'name': '11-50 employees', 'value': 2},
            {'name': '51-200 employees', 'value': 3},
            {'name': '201+ employees', 'value': 4}
          ],
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'industry',
          'type': InputType.ListMultiselectSearchable,
          'placeholder': 'Example of multi-select list with searchable',
          'label': 'Primary Industry',
          'icon': Icons.category,
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Technology', 'value': 1},
            {'name': 'Healthcare', 'value': 2},
            {'name': 'Finance', 'value': 3},
            {'name': 'Education', 'value': 4},
            {'name': 'Retail', 'value': 5},
            {'name': 'Manufacturing', 'value': 6},
            {'name': 'Other', 'value': 7}
          ],
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'primary_goal',
          'type': InputType.List,
          'placeholder': 'Example of single-select list',
          'label': 'Primary Goal',
          'icon': Icons.flag,
          'editOrder': 3,
          'viewOrder': 3,
          'required': true,
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Process Automation', 'value': 1},
            {'name': 'Data Analytics', 'value': 2},
            {'name': 'Customer Support', 'value': 3},
            {'name': 'Team Collaboration', 'value': 4}
          ],
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    }
  ]
};
