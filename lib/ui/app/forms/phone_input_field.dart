import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatelessWidget {
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final bool autofocus;
  final String? initialValue;

  const PhoneInputField({
    Key? key,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      disableLengthCheck: true,
      autofocus: autofocus,
      initialValue: initialValue,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      initialCountryCode: 'GB',
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: 'Please provide a phone number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
} 