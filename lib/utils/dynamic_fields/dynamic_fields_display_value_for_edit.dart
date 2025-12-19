import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

String getDisplayValueForEditOverviewScreen(
    QuestionModel question, dynamic answer) {
  if (answer == null) return '';

  if (answer is Map && question.isRangeSelect == true) {
    final min = answer['min'] ?? 'N/A';
    final max = answer['max'] ?? 'N/A';
    return '$min - $max';
  }

  if (question.type == InputType.Location) {
    if (answer is Map<String, dynamic>) {
      return answer['name']?.toString() ?? 'Location not set';
    }
    return answer.toString();
  }

  if (answer is List) {
    if (question.type == InputType.Document) {
      final int fileCount = answer.length;
      return '$fileCount file${fileCount <= 1 ? '' : 's'}';
    }

    return answer.map((val) {
      return _getOptionDisplayName(question, val);
    }).join(', ');
  }

  if (question.isCustomWali()) {
    return _formatWaliDisplay(answer);
  }

  // Handle single value
  return _getOptionDisplayName(question, answer);
}

String _getOptionDisplayName(QuestionModel question, dynamic value) {
  // Check if the question has both selectedField and showField
  if ((question.isDropdown() || question.isRadio()) &&
      question.selectedField != null &&
      question.showField != null &&
      question.options != null) {
    try {
      final option = (question.options as List).firstWhere(
        (option) =>
            option[question.selectedField].toString() == value.toString(),
      );
      return option[question.showField].toString();
    } catch (_) {
      // Fallback to original value if no matching option found
      return value.toString();
    }
  }

  // For list type questions
  if (question.isListType() && question.options != null) {
    try {
      final option = (question.options as List).firstWhere(
        (option) =>
            option[question.selectedField ?? 'value'].toString() ==
            value.toString(),
      );
      return option[question.showField ?? 'name'].toString();
    } catch (_) {
      // Fallback to original value if no matching option found
      return value.toString();
    }
  }

  if (question.type == InputType.ClassicDate) {
    final DateTime? initialDateTime =
        value != null ? DateTime.fromMillisecondsSinceEpoch(value) : null;

    final String initialDateString = initialDateTime != null
        ? '${initialDateTime.year}-${initialDateTime.month.toString().padLeft(2, '0')}-${initialDateTime.day.toString().padLeft(2, '0')}'
        : value.toString();
    return initialDateString;
  }
  if (question.type == InputType.Date) {
    String dateStr = value.toString();

    if (dateStr.contains('T')) {
      dateStr = dateStr.split('T')[0];
    }
    return dateStr;
  }

  // For all other types
  return value.toString();
}

String _formatWaliDisplay(Map<String, dynamic> waliData) {
  final email = waliData['email'];
  final noGuardian = waliData['noGuardian'] ?? false;

  if (email != null && email.toString().isNotEmpty) {
    return email;
  }

  if (noGuardian) {
    return 'No Guardian';
  }

  return 'Unknown Wali';
}
