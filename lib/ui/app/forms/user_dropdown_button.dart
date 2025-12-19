import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';

class UserDropdownButton<T> extends StatelessWidget {
  const UserDropdownButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.selectedItemBuilder,
    this.labelText,
    this.showBlank = false,
    this.blankValue = '',
    this.blankLabel,
    this.enabled = true,
    this.autofocus = false,
  }) : super(key: key);

  final String? labelText;
  final dynamic value;
  final Function(dynamic)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final bool showBlank;
  final bool enabled;
  final bool autofocus;
  final dynamic blankValue;
  final String? blankLabel;
  final DropdownButtonBuilder? selectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    // Ensure the value remains valid and the default value is set correctly
    dynamic checkedValue = value;
    final values = items.toList().map((option) => option.value).toList();

    if (!values.contains(value)) {
      checkedValue = blankValue; // We don't want a null value
    }
    final bool isEmpty = checkedValue == null || checkedValue == '';

    return DropdownButton<T>(
      hint:
          labelText != null ? Text(labelText!) : null, // Show label if provided
      value: checkedValue as T?, // Use the valid value or default to blankValue
      isExpanded: true,
      autofocus: autofocus,
      iconSize: 32,
      underline: SizedBox(),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: enabled ? onChanged : null,
      selectedItemBuilder: selectedItemBuilder,
      items: [
        if (showBlank || isEmpty)
          DropdownMenuItem<T>(
            value: blankValue,
            child: Row(
              children: [
                Icon(Icons.person, size: 32),
                SizedBox(width: 10),
                Text(
                  kMyAccount, // Default user name
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ...items,
      ],
    );
  }
}
