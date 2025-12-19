import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

//TODO _canMoveNext() validation should also be moved here

bool validateInput(
    QuestionModel question, dynamic answer, BuildContext context) {
  if (question.isTagsType()) {
    if (!_validateTags(question, answer)) {
      _showValidationError(
          'Please select at least one ${question.label}', context);
      return false;
    }
  }

  if (question.isCustomWali()) {
    if (!_validateCustomWali(answer)) {
      _showValidationError(
          'Please provide an email or check "No Guardian"', context);
      return false;
    }
  }

  // Existing required field validation
  if (question.required &&
      (answer == null ||
          (answer is List && answer.isEmpty) ||
          answer.toString().isEmpty)) {
    _showValidationError('This field is required', context);
    return false;
  }

  return true;
}

bool _validateTags(QuestionModel question, dynamic answer) {
  if (!question.required) return true;

  if (answer is List && answer.isNotEmpty) return true;
  return false;
}

bool _validateCustomWali(dynamic value) {
  if (value == null) return false;
  if (value is! Map<String, dynamic>) return false;
  String? email = value['email'];
  bool noGuardian = value['noGuardian'] ?? false;

  return (email != null && email.trim().isNotEmpty) || noGuardian;
}

void _showValidationError(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
