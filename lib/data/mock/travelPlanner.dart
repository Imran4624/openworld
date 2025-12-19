import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

final Map<String, Object> travelPlannerQuestions = {
  'name': 'Travel Questions',
  'textOnSubmit': 'Profile details updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'dates',
      'group': 'Tour Details',
      'description': 'Provide trip dates information',
      'show_intro_screen': false,
      'show_all_questions': true,
      'icon': Icons.date_range,
      'questions': [
        {
          'id': 'timeline',
          'type': InputType.Timeline,
          'placeholder': 'Plan your journey',
          'label': 'Time to plan',
          'icon': Icons.timer,
          'editOrder': 1,
          'viewOrder': 1,
          'defautValue': 2,
          'minValue': 1,
          'maxValue': 3,
          'required': false,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false,
          'nodes': [
            {
              'heading': 'Pickup',
              'date': '2025-03-15T00:00:00.000',
              'time': '7:30',
              'description':
                  '• Your coach will be outside the Gloucester Road Station next to Tesco\n• Please arrive 10 minutes before departure time \n\nhttps://maps.apple.com/?address=London,%20England&auid=12198381547828029807&ll=51.494597,-0.183464&lsp=9902&q=Gloucester%20Road%20Station&_ext=CkYKBQgEEOEBCgQIBRADCgUIBhC8AQoECAoQAAoECDEQIgoECFIQCgoECFUQDgoECFkQAgoECF8QAQoFCKQBEAEKBQjBARABEiQpE7U0t0K/SUAx/yuGBr2Sx7852s5SDVa/SUBBmRcWkoJdx78%3D'
            },
            {
              'heading': 'Arrive Stonehenge',
              'date': '2025-03-15T00:00:00.000',
              'time': '09:15',
              'description':
                  '• Spend one and half hour in Stonehenge \n• Facilities at the Stonehenge visitor centre include toilets, cafeteria, souvenir store and exhibition centre.\n• Once you arrive, please make sure to collect your tickets from your tour leader in order to access the Stonehenge site and exhibition centre. \n\nhttps://www.google.com/maps/place/Stonehenge+Visitor+Centre/@51.1842875,-1.8573687,17z/data=!3m1!4b1!4m6!3m5!1s0x4873e7c7729d788f:0x46df7c4042e0ca30!8m2!3d51.1842875!4d-1.8573687!16s%2Fg%2F11bbw_fzhw?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D'
            },
            {
              'heading': 'Leave for Bath',
              'date': '2025-03-15T00:00:00.000',
              'time': '11:00',
              'description':
                  '• Your coach will be parked where you were dropped off.\n• Drive via scenic English Countryside'
            },
            {
              'heading': 'Arrive in Bath',
              'date': '2025-03-15T00:00:00.000',
              'time': '12:15',
              'description':
                  '• Walkin tour for 45 minutes (if you want to join)\n• Spend 3 hours in Bath'
            },
            {
              'heading': 'Depart Bath',
              'date': '2025-03-15T00:00:00.000',
              'time': '15:00',
              'description':
                  "• The drive back to London will take 2.5 hours, but don't worry we'll be making a stop for refreshment \n\n https://www.google.com/maps/place/7+Terrace+Walk,+Bath+BA1+1LN/@51.3812566,-2.3575367,144m/data=!3m1!1e3!4m6!3m5!1s0x4871811226b5285f:0x2ad5c6545b39abe5!8m2!3d51.3813481!4d-2.3576585!16s%2Fg%2F11q2nh25vd?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoJLDEwMjExMjM0SAFQAw%3D%3D"
            },
            {
              'heading': 'Tour Finishes',
              'date': '2025-03-15T00:00:00.000',
              'time': '18:00',
              'description':
                  '• The coach will drop you at Gloucester Road next to Tesco.'
            }
          ]
        }
      ]
    }
  ]
};
