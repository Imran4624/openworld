import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/dynamic_fields_static_data.dart';

final Map<String, Object> profileQuestions = {
  'name': 'Profile Questions',
  'textOnSubmit': 'Profile details updated successfully',
  'custom': {},
  'groups': [
    {
      'id': 'personal_details',
      'group': 'Personal Details',
      'editOrder': 1,
      'viewOrder': 1,
      'show_intro_screen': true,
      'description': "I'll ask some personal questions, hold tight!",
      'icon': Icons.person,
      // 'slider': {
      //   'content': [
      //     {
      //       'image':
      //           'https://flutterboilerplate.s3.us-east-2.amazonaws.com/auth/signup.webp',
      //       'title': 'Welcome',
      //       'description':
      //           'Thank you for joining us! Let me show how to use the app.'
      //     },
      //     {
      //       'image':
      //           'https://flutterboilerplate.s3.us-east-2.amazonaws.com/auth/signin.webp',
      //       'title': '',
      //       'description': ''
      //     },
      //     {
      //       'image':
      //           'https://flutterboilerplate.s3.us-east-2.amazonaws.com/auth/social-login.webp',
      //       'title': '',
      //       'description': ''
      //     },
      //   ]
      // },
      'questions': [
        {
          'id': DynamicFieldsConstants.images,
          'type': InputType.Document,
          'placeholder': '',
          'label':
              'Upload your photo (Your picture will be blurred for privacy)',
          'minValue': 1,
          'maxValue': 5,
          'allowedTypes': 'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg',
          'icon': Icons.image,
          'editOrder': 1,
          'viewOrder': 1,
          'defautValue': 2,
          'required': true,
          'showInLine': false,
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': DynamicFieldsConstants.name,
          'type': InputType.Text,
          'placeholder': 'Enter your first name',
          'label': 'First Name',
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
          'id': DynamicFieldsConstants.age,
          'type': InputType.Age,
          'placeholder': '',
          'label': 'Age',
          'icon': Icons.date_range,
          'editOrder': -1,
          'viewOrder': 2,
          'required': false,
          'options': [18, 40],
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 1,
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
          'editOrder': 2,
          'viewOrder': -1,
          'required': true,
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
                'options': List.generate(11, (i) => (1990 + i).toString()),
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
          'editOrder': 3,
          'viewOrder': 3,
          'required': true,
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
          //height
          'id': 'height',
          'type': InputType.Dropdown,
          'placeholder': 'Select your height',
          'label': 'Height',
          'icon': Icons.height,
          'editOrder': 3,
          'viewOrder': 3,
          'required': false,
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': getHeightOptions(),
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false,
        },
        {
          //marital_status
          'id': 'marital_status',
          'type': InputType.List,
          'placeholder': 'Select your marital status',
          'label': 'Marital Status',
          'icon': Icons.group,
          'editOrder': 4,
          'viewOrder': 4,
          'required': true,
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Never Married', 'value': 1},
            {'name': 'Divorced', 'value': 2},
            {'name': 'Widowed', 'value': 3},
            {'name': 'Other', 'value': 4}
          ],
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          //children
          'id': 'children',
          'type': InputType.List, //list_multiselect_searchable
          'placeholder': 'Select your children status',
          'label': 'Children',
          'icon': Icons.child_care,
          'editOrder': 5,
          'viewOrder': 5,
          'required': false,
          'selectedField': 'value',
          'showField': 'name',
          'options': [
            {'name': 'Has children', 'value': '1'},
            {'name': 'Doesn’t have children', 'value': '2'},
            {'name': 'Prefer not to say', 'value': '3'},
          ],
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false,
        },
        // {
        //   //grew_up_in
        //   'id': 'grew_up_in',
        //   'type': InputType.Text,
        //   'placeholder': 'Enter the country where you grew up',
        //   'label': 'Grew Up In',
        //   'editOrder': 2,
        //   'viewOrder': 2,
        //   'required': true,
        //   'searchable': 'ShowInBasicSearch',
        //   'isMultiSelect': false,
        //   'isRangeSelect': false,
        //   'isSearchable': false
        // },
        {
          //current_location
          'id': 'current_location',
          'type': InputType.ListSearchable, //dropdown_searchable
          'placeholder': "Enter the country you're living in",
          'label': 'Current Location',
          'editOrder': 3,
          'viewOrder': 3,
          'required': false,
          'selectedField': 'code',
          'showField': 'name',
          'options': getCountryOptions(),
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
          'isSearchable': true,
          'searchOrder': 3
        },
        // {
        //   //wali
        //   'id': 'wali',
        //   'type': InputType.CustomWali,
        //   'required': true,
        //   'editOrder': 4,
        //   'viewOrder': -1,
        //   'icon': Icons.person,
        //   'placeholder': "Enter your guardian's email address",
        //   'info': 'Your activity details will be emailed to your guardian',
        //   'label': "Your wali's email",
        //   'checkbox': "I don't have a guardian",
        //   'checkboxChecked':
        //       "I understand that I don't have a guardian and I'll keep check and balance on myself",
        //   'searchable': 'None',
        // },
        // {
        //   'id': 'social_links',
        //   'type': InputType.Text,
        //   'required': true,
        //   'editOrder': 5,
        //   'viewOrder': -1,
        //   'icon': Icons.person,
        //   'placeholder': "Social Links",
        //   'info':
        //       'In order to get approval, we need to see who you are, so please share your LinkedIn or Instagram or Facebook',
        //   'label': "Social Links",
        //   'searchable': 'None',
        // },
        {
          'id': 'about',
          'type': InputType.TextArea,
          'required': true,
          'editOrder': 6,
          'viewOrder': -1,
          'icon': Icons.person_2_outlined,
          'placeholder': "About",
          'label': "About",
          'searchable': 'None',
        },
      ]
    },
    {
      'id': 'languages_ethnicity',
      'group': 'Languages and Ethnicity',
      'editOrder': 5,
      'viewOrder': 5,
      'description': 'Share your languages and ethnic background.',
      'icon': Icons.language,
      'questions': [
        {
          'id': 'languages',
          'type': InputType.ListMultiselect,
          'placeholder': 'Select the languages you speak',
          'label': 'Languages',
          'icon': Icons.translate,
          'editOrder': 1,
          'viewOrder': 1,
          'required': false,
          'selectedField': 'value',
          'showField': 'name',
          'sortField': 'name',
          'options': [
            {'name': 'Arabic', 'value': 1},
            {'name': 'English', 'value': 2},
            {'name': 'French', 'value': 3},
            {'name': 'Urdu', 'value': 4},
            {'name': 'Persian', 'value': 5},
            {'name': 'Turkish', 'value': 6},
            {'name': 'Malay', 'value': 7},
            {'name': 'Indonesian', 'value': 8},
            {'name': 'Pashto', 'value': 9},
            {'name': 'Somali', 'value': 10},
            {'name': 'Bengali', 'value': 11},
            {'name': 'Kurdish', 'value': 12},
            {'name': 'Swahili', 'value': 13},
            {'name': 'Hausa', 'value': 14}
          ],
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': false,
          'searchOrder': 1
        },
        {
          'id': 'ethnic_background',
          'type': InputType.Dropdown,
          'placeholder': 'Select your ethnic background',
          'label': 'Ethnic Background',
          'icon': Icons.public,
          'editOrder': 2,
          'viewOrder': 2,
          'required': false,
          'selectedField': 'code',
          'showField': 'name',
          'sortField': 'name',
          'options': getCountryOptions(),
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false,
          'searchOrder': 2
        }
      ]
    },
    {
      'id': 'interests_personality',
      'group': 'Interests and Personality',
      'editOrder': 6,
      'viewOrder': 6,
      'description': 'Let us know about your interests and personality!',
      'icon': Icons.interests,
      'show_intro_screen': true,
      // 'show_all_questions': true,
      'questions': [
        {
          'id': 'interests',
          'type': InputType.Tags,
          'placeholder': 'Select your interests',
          'label': 'Interests',
          'icon': Icons.directions_bike,
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': true,
          'options': [
            {'label': 'Cycling', 'icon': Icons.directions_bike},
            {'label': 'Tennis', 'icon': Icons.sports_tennis},
            {'label': 'Coding', 'icon': Icons.code},
            {'label': 'Reading', 'icon': Icons.book},
            {'label': 'Cooking', 'icon': Icons.kitchen},
            {'label': 'Traveling', 'icon': Icons.flight},
            {'label': 'Photography', 'icon': Icons.camera_alt},
            {'label': 'Fitness', 'icon': Icons.fitness_center},
            {'label': 'Music', 'icon': Icons.music_note},
            {'label': 'Gaming', 'icon': Icons.videogame_asset}
          ],
          'searchOrder': 1
        },
        {
          'id': 'personality',
          'type': InputType.Tags,
          'placeholder': 'Select your personality traits',
          'label': 'Personality',
          'icon': Icons.person,
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': true,
          'options': [
            {'label': 'Adventurous', 'icon': Icons.explore},
            {'label': 'Affectionate', 'icon': Icons.favorite},
            {'label': 'Bookworm', 'icon': Icons.book},
            {'label': 'Creative', 'icon': Icons.palette},
            {'label': 'Respectful', 'icon': Icons.emoji_people},
            {'label': 'Positive', 'icon': Icons.sentiment_satisfied},
            {'label': 'Patient', 'icon': Icons.hourglass_bottom},
            {'label': 'Empathetic', 'icon': Icons.volunteer_activism},
            {'label': 'Generous', 'icon': Icons.card_giftcard},
            {'label': 'Funny', 'icon': Icons.emoji_emotions}
          ],
          'searchOrder': 2
        },
        {
          'id': 'communication_style',
          'type': InputType.Tags,
          'label': 'Preferred Communication Style',
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          'options': [
            {'label': 'In Person', 'icon': Icons.person},
            {'label': 'Phone Call', 'icon': Icons.phone},
            {'label': 'Video Chat', 'icon': Icons.video_call}
          ],
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
        }
      ]
    }
  ]
};
