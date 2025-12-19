import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_builder/document_field_builder.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_builder/location_field_builder.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/display_maps.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// the initial value in textcontoller is set in initState
// it sets differnt value for customWali

Widget buildInputField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer, {
  TextEditingController? controller,
}) {
  switch (question.type) {
    case InputType.Text:
      return _buildTextField(
        context,
        question,
        initialValue,
        updateAnswer,
        controller!,
      );
    case InputType.Range:
      return _buildRangeField(
        context,
        question,
        initialValue,
        updateAnswer,
      );
    case InputType.TextArea:
      return _buildTextAreaField(
        context,
        question,
        initialValue,
        updateAnswer,
        controller,
      );
    case InputType.Location:
      return buildLocationTextField(
        context,
        question,
        initialValue,
        updateAnswer,
        controller,
      );

    case InputType.Dropdown:
      return _buildDropdownField(
        question,
        initialValue,
        updateAnswer,
      );

    case InputType.Tags:
      return _buildTagsField(
        question,
        initialValue,
        (tags) => updateAnswer(tags),
      );

    case InputType.Date:
      return _buildDateField(
        question,
        initialValue,
        updateAnswer,
      );

    case InputType.ClassicDate:
      return _buildClassicDateField(
        context,
        question,
        initialValue,
        updateAnswer,
      );

    case InputType.GridMultiSelect:
      return _buildGridMultiSelect(
        question,
        initialValue,
        updateAnswer,
      );
    case InputType.Timeline:
      return buildTimelineField(context, question, initialValue, updateAnswer,
          isViewOnly: false);

    case InputType.NumberIncrementable:
      return _buildNumberIncrementableField(
          question, initialValue, updateAnswer);

    case InputType.CustomWali:
      return _buildCustomWaliField(
          context, question, initialValue, updateAnswer, controller!);
    case InputType.Radio:
      return _buildRadioField(question, initialValue, updateAnswer);
    case InputType.Document:
      return buildDocumentField(question, initialValue, updateAnswer);

    case InputType.List:
      return _buildListField(
          context, question, initialValue, updateAnswer, false, false);
    case InputType.ListSearchable:
      return _buildListField(
          context, question, initialValue, updateAnswer, false, true);
    case InputType.ListMultiselect:
      return _buildListField(
          context, question, initialValue, updateAnswer, true, false);
    case InputType.ListMultiselectSearchable:
      return _buildListField(
          context, question, initialValue, updateAnswer, true, true);
    case InputType.Undefined:
    default:
      printL('Error: Unsupported field type: ${question.type}');
      return const SizedBox.shrink();
  }
}

Widget buildSearchInputField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer, {
  TextEditingController? controller,
}) {
  if (question.isRangeSelect ?? false) {
    return _buildRangeSelector(
      question,
      initialValue,
      updateAnswer,
    );
  }

  if (question.isMultiSelect ?? false) {
    if (question.isTagsType()) {
      return _buildTagsField(
        question,
        initialValue,
        (tags) => updateAnswer(tags),
      );
    } else if (question.isDropdown() || question.isListType()) {
      return _buildListField(
        context,
        question,
        initialValue,
        updateAnswer,
        true, // Multi-select enabled
        question.type == InputType.ListSearchable ||
            question.type == InputType.ListMultiselectSearchable, // Searchable
      );
    }
  }

  // Default to regular input type handling for search fields
  switch (question.type) {
    case InputType.Text:
      return _buildTextField(
        context,
        question,
        initialValue,
        updateAnswer,
        controller!,
      );
    case InputType.TextArea:
      return _buildTextAreaField(
        context,
        question,
        initialValue,
        updateAnswer,
        controller!,
      );

    case InputType.Dropdown:
      return _buildDropdownField(
        question,
        initialValue,
        updateAnswer,
      );

    case InputType.Tags:
      return _buildTagsField(
        question,
        initialValue,
        (tags) => updateAnswer(tags),
      );

    case InputType.Date:
      return _buildDateField(
        question,
        initialValue,
        updateAnswer,
      );

    case InputType.CustomWali:
      return _buildCustomWaliField(
          context, question, initialValue, updateAnswer, controller!);
    case InputType.Radio:
      return _buildRadioField(question, initialValue, updateAnswer);

    case InputType.List:
      return _buildListField(
          context, question, initialValue, updateAnswer, false, false);
    case InputType.ListSearchable:
      return _buildListField(
          context, question, initialValue, updateAnswer, false, true);
    case InputType.ListMultiselect:
      return _buildListField(
          context, question, initialValue, updateAnswer, true, false);
    case InputType.ListMultiselectSearchable:
      return _buildListField(
          context, question, initialValue, updateAnswer, true, true);
    case InputType.Undefined:
    default:
      printL('Error: Unsupported field type: ${question.type}');
      return const SizedBox.shrink();
  }
}

Widget _buildTextField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
  TextEditingController controller, {
  bool? showBorder = true,
  int? maxLines,
  String? customHint,
  String? customLabel,
  TextStyle? textStyle,
}) {
  final store = StoreProvider.of<AppState>(context);
  final appTheme =
      AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
  return Column(
    children: [
      TextFormField(
        controller: controller,
        style: textStyle,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: customLabel ?? question.label,
          hintText: customHint ?? question.placeholder,
          border: showBorder == false ? InputBorder.none : null,
        ),
        onChanged: (value) {
          dynamic sanitizedValue = value;
          if (question.id == DynamicFieldsConstants.email) {
            sanitizedValue = value.trim().toLowerCase();
          } else if (question.id == DynamicFieldsConstants.name || 
                     question.id.toLowerCase().contains('name')) {
            sanitizedValue = value.trim();
          }
          updateAnswer(sanitizedValue);
        },
      ),
      if (question.info != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            question.info!,
            style: TextStyle(
              fontSize: 12,
              color: appTheme.defaultColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ],
  );
}

Widget _buildTextAreaField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
  TextEditingController? controller, {
  bool? showBorder = true,
  int maxLines = 5,
  String? customHint,
  String? customLabel,
  TextStyle? textStyle,
  bool expands = false,
}) {
  final store = StoreProvider.of<AppState>(context);
  final appTheme =
      AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        style: textStyle,
        maxLines: expands ? null : maxLines,
        minLines: expands ? null : 3,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: customLabel ?? question.label,
          hintText: customHint ?? question.placeholder,
          border: showBorder == false ? InputBorder.none : OutlineInputBorder(),
        ),
        onChanged: (value) {
          dynamic sanitizedValue = value;
          if (question.id == DynamicFieldsConstants.email) {
            sanitizedValue = value.trim().toLowerCase();
          } else if (question.id == DynamicFieldsConstants.name || 
                     question.id.toLowerCase().contains('name')) {
            sanitizedValue = value.trim();
          }
          updateAnswer(sanitizedValue);
        },
      ),
      if (question.info != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            question.info!,
            style: TextStyle(
              fontSize: 12,
              color: appTheme.defaultColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ],
  );
}

Widget _buildRangeField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
) {
  final min = question.minValue.toDouble();
  final max = question.maxValue.toDouble();

  // Initialize with either the provided value or the minimum
  final initialVal = (initialValue ?? min).toDouble();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${question.label}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      StatefulBuilder(
        builder: (context, setState) {
          // Local state variable to track slider value
          double currentValue = initialVal;

          return Column(
            children: [
              // Display current value
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${min.toInt()}'),
                    Text('Value: ${currentValue.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text('${max.toInt()}'),
                  ],
                ),
              ),
              // The slider itself
              Slider(
                value: currentValue,
                min: min,
                max: max,
                divisions: (max - min).toInt(),
                label: currentValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    currentValue = value;
                    updateAnswer(value.toInt());
                  });
                },
              ),
              // Info text if provided
              if (question.info != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
                  child: Text(
                    question.info!,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}

Widget _buildDropdownField(
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
) {
  return DropdownButtonFormField<dynamic>(
    decoration: InputDecoration(labelText: question.label),
    value: initialValue,
    items: (question.options as List)
        .map<DropdownMenuItem<dynamic>>((option) => DropdownMenuItem<dynamic>(
              value: option[question.selectedField ?? 'value'],
              child: Text(option[question.showField ?? 'name']),
            ))
        .toList(),
    onChanged: updateAnswer,
  );
}

Widget _buildRadioField(
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: (question.options as List).map<Widget>((option) {
          final value = option[question.selectedField ?? 'value'];
          final label = option[question.showField ?? 'name'];

          return ChoiceChip(
            label: Text(label),
            selected: initialValue == value,
            onSelected: (bool selected) {
              if (selected) {
                updateAnswer(value);
              }
            },
            selectedColor: AppTheme.light.primary,
            backgroundColor: AppTheme.light.defaultColor,
            labelStyle: TextStyle(
              color: AppTheme.dark.text,
              fontWeight:
                  initialValue == value ? FontWeight.w600 : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: initialValue == value
                    ? AppTheme.light.primary
                    : AppTheme.light.defaultColor,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildCustomWaliField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
  TextEditingController controller,
) {
  // Extract the email and checkbox state from initialValue
  String? email;
  bool noGuardian = false;
  final store = StoreProvider.of<AppState>(context);
  final appTheme =
      AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

  if (initialValue != null && initialValue is Map<String, dynamic>) {
    email = initialValue['email'] as String?;
    noGuardian = initialValue['noGuardian'] as bool? ?? false;
  }

  if (email != null && controller.text.isEmpty) {
    controller.text = email;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Email TextField
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: question.label,
          hintText: question.placeholder,
        ),
        enabled: !noGuardian, // Disable when checkbox is checked
        onChanged: (value) {
          updateAnswer({
            'email': value.trim().toLowerCase(),
            'noGuardian': noGuardian,
          });
        },
      ),

      // Info text
      if (question.info != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            question.info!,
            style: TextStyle(
              fontSize: 12,
              color: appTheme.defaultColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

      // Checkbox with label
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: StatefulBuilder(
          builder: (context, setState) => Row(
            children: [
              Checkbox(
                value: noGuardian,
                onChanged: (bool? value) {
                  setState(() {
                    noGuardian = value ?? false;
                    if (noGuardian) {
                      controller.clear();
                    }
                    updateAnswer({
                      'email': controller.text.trim().toLowerCase(),
                      'noGuardian': noGuardian,
                    });
                  });
                },
              ),
              Expanded(
                child: Text(question.checkbox ?? ''),
              ),
            ],
          ),
        ),
      ),

      // Display message when checkbox is checked
      if (noGuardian && question.checkboxChecked != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            question.checkboxChecked!,
            style: TextStyle(
              fontSize: 12,
              color: appTheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ],
  );
}

Widget _buildDateField(QuestionModel question, dynamic initialValue,
    void Function(String) updateAnswer) {
  final inputOptions = question.inputOptions;

  Map<String, String> dateComponents = {'year': '', 'month': '', 'day': ''};

  if (initialValue != null) {
    String dateStr = initialValue.toString();

    if (dateStr.contains('T')) {
      dateStr = dateStr.split('T')[0];
    }

    final parts = dateStr.split('-');
    if (parts.length == 3) {
      String day = parts[2];
      if (day.contains('T')) {
        day = day.split('T')[0];
      }

      dateComponents = {'year': parts[0], 'month': parts[1], 'day': day};
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: (inputOptions['fields'] as List).map<Widget>((field) {
          final fieldId = field['id'];
          final fieldInitialValue = dateComponents[fieldId];

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: field['placeholder'],
                  labelText: field['placeholder'],
                ),
                value: fieldInitialValue?.isNotEmpty == true
                    ? fieldInitialValue
                    : null,
                items: (field['options'] as List)
                    .map<DropdownMenuItem<String>>((option) {
                  final value = option is Map
                      ? (option['value'] ?? option['label']).toString()
                      : option.toString();
                  final label =
                      option is Map ? option['label'] ?? value : value;

                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    dateComponents[fieldId] = value;

                    // Only update if all fields are filled
                    if (dateComponents.values.every((v) => v.isNotEmpty)) {
                      final formattedDate =
                          '${dateComponents['year']}-${dateComponents['month']}-${dateComponents['day']}';
                      updateAnswer(formattedDate);
                    }
                  }
                },
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildGridMultiSelect(
  QuestionModel question,
  List<dynamic>? initialValue,
  void Function(List<dynamic>) updateAnswer,
) {
  return GridMultiSelectField(
    question: question,
    initialValue: initialValue,
    updateAnswer: (List<dynamic> selectedValues) {
      updateAnswer(selectedValues);
    },
  );
}

Widget _buildTagsField(
  QuestionModel question,
  dynamic initialTags,
  void Function(List<String>) updateAnswer,
) {
  // Safely convert initialTags to a List<String> or use an empty list if null
  final tags = initialTags != null
      ? List<String>.from(initialTags as List<dynamic>)
      : <String>[];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(question.label, style: const TextStyle(fontSize: 16)),
      Wrap(
        spacing: 8,
        children: (question.options as List).map<Widget>((option) {
          // Determine if option is a string or a map
          final label = option is String ? option : option['label'] as String;
          final icon = option is Map && option.containsKey('icon')
              ? option['icon'] as IconData
              : null;
          final isSelected = tags.contains(label);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) Icon(icon, size: 18),
                  if (icon != null) const SizedBox(width: 4),
                  Text(label),
                ],
              ),
              selected: isSelected,
              avatar: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 18,
                    )
                  : null,
              onSelected: (selected) {
                final updatedTags = List<String>.from(tags);
                if (selected) {
                  updatedTags.add(label);
                } else {
                  updatedTags.remove(label);
                }
                updateAnswer(updatedTags);
              },
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildListField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
  bool multiSelectEnabled,
  bool searchEnabled,
) {
  final store = StoreProvider.of<AppState>(context);
  final appTheme =
      AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
  final List<dynamic> options = question.options ?? [];
  final String showField = question.showField ?? 'name';
  final String selectedField = question.selectedField ?? 'value';

  final List<String> initialSelectedValues = initialValue is List
      ? initialValue.map((e) => e.toString()).toList()
      : (initialValue != null ? [initialValue.toString()] : []);

  final ValueNotifier<List<String>> selectedValues =
      ValueNotifier<List<String>>(initialSelectedValues);

  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<List<dynamic>> filteredOptions =
      ValueNotifier<List<dynamic>>(options);

  void searchOptions(String query) {
    if (query.isEmpty) {
      filteredOptions.value = options;
    } else {
      filteredOptions.value = options.where((option) {
        final displayName = option[showField]?.toString().toLowerCase() ?? '';
        return displayName.contains(query.toLowerCase());
      }).toList();
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      // Padding(
      //   padding: const EdgeInsets.only(bottom: 8.0),
      //   child: Text(
      //     question.label,
      //     style: Theme.of(context).textTheme.titleMedium,
      //   ),
      // ),

      // Search input
      if (searchEnabled)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: searchOptions,
          ),
        ),

      // List of options
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300, minHeight: 50),
        child: ValueListenableBuilder<List<String>>(
          valueListenable: selectedValues,
          builder: (context, selectedItems, child) {
            return ValueListenableBuilder<List<dynamic>>(
              valueListenable: filteredOptions,
              builder: (context, currentOptions, child) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: currentOptions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final option = currentOptions[index];

                    // Get the display name and value based on specified fields
                    final displayName = option[showField]?.toString() ?? '';
                    final optionValue = option[selectedField]?.toString() ?? '';

                    final isSelected = selectedItems.contains(optionValue);

                    return InkWell(
                      onTap: () {
                        if (multiSelectEnabled) {
                          // Multi-select logic
                          final currentSelection =
                              List<String>.from(selectedValues.value);
                          if (isSelected) {
                            currentSelection.remove(optionValue);
                          } else {
                            currentSelection.add(optionValue);
                          }
                          selectedValues.value = currentSelection;
                          updateAnswer(currentSelection);
                        } else {
                          // Single select logic
                          selectedValues.value = [optionValue];
                          updateAnswer(optionValue);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? appTheme.primary
                                  : appTheme.defaultColor,
                              width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),

                            // Selection Indicator
                            if (isSelected)
                              Icon(
                                multiSelectEnabled
                                    ? Icons.check_box
                                    : Icons.check_circle,
                                color: appTheme.primary,
                              )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),

      // Placeholder text
      if (question.placeholder != null)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            question.placeholder!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: appTheme.defaultColor),
          ),
        ),
    ],
  );
}

Widget _buildRangeSelector(
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
) {
  final min = (question.options?[0] ?? 0).toDouble();
  final max = (question.options?[1] ?? 100).toDouble();

  final minValue = (initialValue?['min'] ?? min).toDouble();
  final maxValue = (initialValue?['max'] ?? max).toDouble();

  RangeValues currentRangeValues = RangeValues(minValue, maxValue);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${question.label} (Range)',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      StatefulBuilder(
        builder: (context, setState) {
          return RangeSlider(
            values: currentRangeValues,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            labels: RangeLabels(
              currentRangeValues.start.round().toString(),
              currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                currentRangeValues = values;

                updateAnswer({
                  'min': values.start.toInt(),
                  'max': values.end.toInt(),
                });
              });
            },
          );
        },
      ),
    ],
  );
}

Widget _buildNumberIncrementableField(QuestionModel question,
    dynamic initialValue, void Function(String) updateAnswer) {
  return StatefulBuilder(
    builder: (context, setState) {
      final store = StoreProvider.of<AppState>(context);
      final appTheme =
          AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

      num currentValue =
          num.tryParse(initialValue?.toString() ?? '') ?? question.defaultValue;

      void increment() {
        if (currentValue < question.maxValue) {
          setState(() {
            currentValue++;
            updateAnswer(currentValue.toString());
          });
        }
      }

      void decrement() {
        if (currentValue > question.minValue) {
          setState(() {
            currentValue--;
            updateAnswer(currentValue.toString());
          });
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentValue > question.minValue ? decrement : null,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentValue > question.minValue
                    ? appTheme.primary
                    : appTheme.defaultColor,
              ),
              child: Align(
                alignment: Alignment.center,
                child: const Icon(
                  Icons.remove,
                  size: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              currentValue.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: currentValue < question.maxValue ? increment : null,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentValue < question.maxValue
                    ? appTheme.primary
                    : appTheme.defaultColor,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  color: AppTheme.dark.text,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildTimelineField(BuildContext context, QuestionModel question,
    dynamic answer, void Function(String) updateAnswer,
    {bool isViewOnly = true}) {
  final nodeControllers = TimelineFieldState.getControllers(question.id);
  final store = StoreProvider.of<AppState>(context);
  ThemeColors colors =
      AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
  void initializeControllers(List<TimelineNode> nodes) {
    if (nodeControllers.isEmpty) {
      for (var node in nodes) {
        final controller = TimelineControllers();
        controller.heading.text = node.heading;
        controller.description.text = node.description ?? '';
        nodeControllers.add(controller);
      }
      TimelineFieldState.setControllers(question.id, nodeControllers);
    }
  }

  List<TimelineNode> initialNodes = question.nodes ?? [];
  if (answer != null && answer is String && answer.isNotEmpty) {
    try {
      final List<dynamic> jsonList = json.decode(answer);
      initialNodes =
          jsonList.map((json) => TimelineNode.fromJson(json)).toList();
    } catch (e) {
      printL('Error parsing initialValue: $e');
    }
    initializeControllers(initialNodes);
  } else {
    initializeControllers(initialNodes);
  }

  final nodesNotifier = ValueNotifier<List<TimelineNode>>(initialNodes);
  final isEditModeNotifier = ValueNotifier<bool>(!isViewOnly);

  void updateParent(List<TimelineNode> nodes) {
    nodesNotifier.value = nodes;
    final jsonList = nodes.map((node) => node.toJson()).toList();
    updateAnswer(json.encode(jsonList));
  }

  Widget _buildDatePicker(BuildContext context, TimelineNode node, int index,
      List<TimelineNode> nodes, Function(List<TimelineNode>) updateParent) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: node.date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          final newNodes = List<TimelineNode>.from(nodes);
          newNodes[index] = TimelineNode(
            heading: node.heading,
            date: selectedDate,
            time: node.time,
            description: node.description,
          );
          updateParent(newNodes);
        }
      },
      child: Text(
        node.date != null
            ? '${node.date!.day}/${node.date!.month}/${node.date!.year}'
            : 'Add Date',
        style: TextStyle(color: colors.defaultColor),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, TimelineNode node, int index,
      List<TimelineNode> nodes, Function(List<TimelineNode>) updateParent) {
    return InkWell(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: node.time ?? TimeOfDay.now(),
        );
        if (selectedTime != null) {
          final newNodes = List<TimelineNode>.from(nodes);
          newNodes[index] = TimelineNode(
            heading: node.heading,
            date: node.date,
            time: selectedTime,
            description: node.description,
          );
          updateParent(newNodes);
        }
      },
      child: Text(
        node.time != null ? node.time!.format(context) : 'Add Time',
        style: TextStyle(color: colors.defaultColor),
      ),
    );
  }

  Widget _buildDateDisplay(TimelineNode node) {
    return Text(
      node.date != null
          ? '${node.date!.day}/${node.date!.month}/${node.date!.year}'
          : 'No date',
      style: TextStyle(color: colors.defaultColor),
    );
  }

  Widget _buildTimeDisplay(BuildContext context, TimelineNode node) {
    return Text(
      node.time != null ? node.time!.format(context) : 'No time',
      style: TextStyle(color: colors.defaultColor),
    );
  }

  return Column(
    children: [
      if (!isViewOnly)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isEditModeNotifier,
              builder: (context, isEditMode, _) {
                return SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Edit'),
                      icon: Icon(Icons.edit),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('View'),
                      icon: Icon(Icons.visibility),
                    ),
                  ],
                  selected: {isEditMode},
                  onSelectionChanged: (Set<bool> newSelection) {
                    isEditModeNotifier.value = newSelection.first;
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return colors.primary; // Selected color
                        }
                        return colors.transparent; // Unselected color
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppTheme.dark.text;
                        }
                        return colors.text;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      const SizedBox(height: 16),
      ValueListenableBuilder<List<TimelineNode>>(
        valueListenable: nodesNotifier,
        builder: (context, nodes, _) {
          final store = StoreProvider.of<AppState>(context);
          final appTheme =
              AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
          return ValueListenableBuilder<bool>(
            valueListenable: isEditModeNotifier,
            builder: (context, isEditMode, _) {
              return Stack(
                children: [
                  Positioned(
                    left: 6,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: appTheme.defaultColor,
                    ),
                  ),
                  Column(
                    children: [
                      ...nodes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final node = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, //change it to start/center if you want circle at start of node
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: appTheme.primary, width: 2),
                                    color: AppTheme.dark.text,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: isEditMode
                                                ? _buildTextField(
                                                    context,
                                                    question,
                                                    node.heading,
                                                    (value) {
                                                      final newNodes = List<
                                                              TimelineNode>.from(
                                                          nodes);
                                                      newNodes[index] =
                                                          TimelineNode(
                                                        heading: value,
                                                        date: node.date,
                                                        time: node.time,
                                                        description:
                                                            node.description,
                                                      );
                                                      updateParent(newNodes);
                                                    },
                                                    nodeControllers[index]
                                                        .heading,
                                                    showBorder: false,
                                                    customHint: '',
                                                    customLabel: 'Plan',
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                : Text(
                                                    node.heading.isEmpty
                                                        ? 'No heading'
                                                        : node.heading,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child: isEditMode
                                                    ? _buildDatePicker(
                                                        context,
                                                        node,
                                                        index,
                                                        nodes,
                                                        updateParent)
                                                    : _buildDateDisplay(node),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                width: 65,
                                                child: isEditMode
                                                    ? _buildTimePicker(
                                                        context,
                                                        node,
                                                        index,
                                                        nodes,
                                                        updateParent)
                                                    : _buildTimeDisplay(
                                                        context, node),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (isEditMode)
                                        _buildTextField(
                                          context,
                                          question,
                                          node.description,
                                          (value) {
                                            final newNodes =
                                                List<TimelineNode>.from(nodes);
                                            newNodes[index] = TimelineNode(
                                              heading: node.heading,
                                              date: node.date,
                                              time: node.time,
                                              description: value,
                                            );
                                            updateParent(newNodes);
                                          },
                                          nodeControllers[index].description,
                                          showBorder: false,
                                          customHint:
                                              'Add description (use • for bullet points)',
                                          customLabel: 'Add Details',
                                          maxLines: null,
                                        )
                                      else if (node.description?.isNotEmpty ??
                                          false)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              node.description!
                                                  .replaceAll(
                                                      RegExp(
                                                        r'https?:\/\/(www\.)?(google\.com\/maps|goo\.gl\/maps|maps\.apple\.com|what3words\.com)\/[^\s]+|///[\w\.]+\.[\w\.]+\.[\w\.]+',
                                                        caseSensitive: false,
                                                      ),
                                                      '')
                                                  .trim(),
                                            ),
                                            buildMapPreview(node.description!),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                if (isEditMode && nodes.length > 1)
                                  IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: AppTheme.light.danger),
                                    onPressed: () {
                                      final newNodes =
                                          List<TimelineNode>.from(nodes);
                                      newNodes.removeAt(index);
                                      nodeControllers.removeAt(index);
                                      updateParent(newNodes);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      if (isEditMode &&
                              nodes.isNotEmpty &&
                              nodes.last.heading.isNotEmpty
                          // &&
                          // nodes.last.date != null &&
                          // nodes.last.time != null
                          )
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 28),
                            child: TextButton.icon(
                              onPressed: () {
                                final newNodes = List<TimelineNode>.from(nodes);
                                newNodes.add(TimelineNode());
                                nodeControllers.add(TimelineControllers());
                                updateParent(newNodes);
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    ],
  );
}

Widget _buildClassicDateField(BuildContext context, QuestionModel question,
    int? initialValue, void Function(int) updateAnswer,
    {TextEditingController? controller}) {
  final DateTime? initialDateTime = initialValue != null
      ? DateTime.fromMillisecondsSinceEpoch(initialValue)
      : null;

  final String initialDateString = initialDateTime != null
      ? '${initialDateTime.year}-${initialDateTime.month.toString().padLeft(2, '0')}-${initialDateTime.day.toString().padLeft(2, '0')}'
      : '';

  printL('initial date string ==> $initialDateString');
  final textController =
      controller ?? TextEditingController(text: initialDateString);

  return TextFormField(
    controller: textController,
    decoration: InputDecoration(
      labelText: question.label,
      hintText: question.placeholder,
      suffixIcon: const Icon(Icons.calendar_today),
    ),
    readOnly: true,
    onTap: () async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDateTime ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        final int timestamp = pickedDate.millisecondsSinceEpoch;

        final String formattedDate =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';

        textController.text = formattedDate;
        updateAnswer(timestamp);
      }
    },
  );
}

class GridMultiSelectField extends StatefulWidget {
  final QuestionModel question;
  final List<dynamic>? initialValue;
  final void Function(List<dynamic>) updateAnswer;

  const GridMultiSelectField({
    super.key,
    required this.question,
    this.initialValue,
    required this.updateAnswer,
  });

  @override
  State<GridMultiSelectField> createState() => _GridMultiSelectFieldState();
}

class _GridMultiSelectFieldState extends State<GridMultiSelectField> {
  late List<dynamic> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = List<dynamic>.from(widget.initialValue ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options =
        (widget.question.options as List).cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final value = option[widget.question.selectedField ?? 'value'];
              final isSelected = selectedValues.contains(value);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedValues.remove(value);
                    } else {
                      selectedValues.add(value);
                    }
                    widget.updateAnswer(List<dynamic>.from(selectedValues));
                  });
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : AppTheme.light.transparent,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image section
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(option['image'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Details section
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    option['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    option['category'] ?? '',
                                    style: TextStyle(
                                      color: AppTheme.light.defaultColor,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    option['time'] ?? '',
                                    style: TextStyle(
                                      color: AppTheme.light.defaultColor,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.check_box_rounded,
                              color: AppTheme.dark.text,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TimelineControllers {
  final TextEditingController heading;
  final TextEditingController description;

  TimelineControllers()
      : heading = TextEditingController(),
        description = TextEditingController();

  void dispose() {
    heading.dispose();
    description.dispose();
  }
}

class TimelineFieldState {
  static final Map<String, List<TimelineControllers>> _nodeControllers = {};

  static List<TimelineControllers> getControllers(String questionId) {
    return _nodeControllers[questionId] ?? [];
  }

  static void setControllers(
      String questionId, List<TimelineControllers> controllers) {
    _nodeControllers[questionId] = controllers;
  }
}

class CountryFlagUtils {
  /// Converts a country code to its corresponding flag emoji
  static String getFlagEmoji(String countryCode) {
    try {
      // Ensure the country code is uppercase
      final code = countryCode.toUpperCase();

      // Validate input
      if (code.length != 2) {
        printL('Error generating flag emoji length: ${code.length}');
        return '🏳️';
      }

      // Convert each character to its regional indicator symbol
      final flag = code.split('').map((char) {
        return String.fromCharCode(char.codeUnitAt(0) + 127397);
      }).join();

      return flag;
    } catch (e) {
      printL('Error generating flag emoji: $e');
      return '🏳️';
    }
  }

  static Map<String, String> generateFlagEmojiMap(List? countryCodes) {
    if (countryCodes == null) return {};

    return {
      for (var code in countryCodes)
        code.toString(): getFlagEmoji(code.toString())
    };
  }
}
