import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

extension QuestionMapExtension on Map<String, QuestionModel> {
  String getDisplayName(String key) {
    if (containsKey(key) && this[key] != null) {
      return this[key]!.label;
    }
    return '';
  }

  String getDisplayValueForField(String key, dynamic value) {
    if (value == null) return '';

    if (!containsKey(key) || this[key] == null) {
      return _formatGenericValue(value);
    }

    final question = this[key]!;
    return getDisplayValue(question, value);
  }

  String _formatGenericValue(dynamic value) {
    if (value == null) return '';

    if (value is Map) {
      if (value.isEmpty) return '';

      if (value.containsKey('min') && value.containsKey('max')) {
        return '${value['min']} - ${value['max']}';
      }

      if (value.containsKey('name')) {
        return value['name']?.toString() ?? '';
      }

      return value.entries
              .take(2)
              .map((e) => '${e.key}: ${e.value}')
              .join(', ') +
          (value.length > 2 ? '...' : '');
    }

    if (value is List) {
      if (value.isEmpty) return '';
      return value.take(2).map((v) => v?.toString() ?? '').join(', ') +
          (value.length > 2 ? '...' : '');
    }

    return value.toString();
  }
}

extension QuestionBuiltMapExtension on BuiltMap<String, dynamic> {
  List<String> getImages(String key) {
    List<String> imageUrls = [];

    if (!containsKey(key) || this[key] == null) {
      return imageUrls;
    }

    final imagesData = this[key]!;

    if (imagesData is List && imagesData.isNotEmpty) {
      for (var imageObject in imagesData) {
        if (imageObject is Map<String, dynamic> &&
            imageObject.containsKey('url') &&
            imageObject['url'] != null) {
          imageUrls.add(imageObject['url'].toString());
        } else if (imageObject is String) {
          imageUrls.add(imageObject);
        }
      }
    }

    return imageUrls;
  }

  String getPreferredGender() {
    if (!containsKey(DynamicFieldsConstants.gender) ||
        this[DynamicFieldsConstants.gender] == null) {
      return '';
    }

    final userGender = this[DynamicFieldsConstants.gender];

    if (userGender is List && userGender.isNotEmpty) {
      if (userGender.contains('1')) {
        return '2';
      } else if (userGender.contains('2')) {
        return '1';
      }
    } else if (userGender is String) {
      if (userGender == 'male' || userGender == '1') {
        return '2';
      } else if (userGender == 'female' || userGender == '2') {
        return '1';
      }
    } else if (userGender is int) {
      if (userGender == 1) {
        return '2';
      } else if (userGender == 2) {
        return '1';
      }
    }

    return '';
  }

  String getValue(String key) {
    if (containsKey(key) && this[key] != null && this[key] != '') {
      return this[key].toString();
    } else if (key == DynamicFieldsConstants.name) {
      if (containsKey('first_name') &&
          this['first_name'] != null &&
          this['first_name'] != '') {
        return this['first_name'].toString();
      }
      return 'No name';
    }
    return 'No name';
  }

  String getAge(String key) {
    if (!containsKey(key) || this[key] == null) {
      return '';
    }

    try {
      final dobValue = this[key].toString();
      if (dobValue.isEmpty) return '';

      final DateTime dob = DateTime.parse(dobValue);
      final DateTime now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }

      return '$age';
    } catch (e) {
      return '';
    }
  }

  Map<String, String> getDisplayFields(
      List<String> fieldIds, Map<String, QuestionModel> questionMap) {
    Map<String, String> displayFields = {};

    for (String fieldId in fieldIds) {
      if (!containsKey(fieldId) ||
          !questionMap.containsKey(fieldId) ||
          questionMap[fieldId] == null) {
        continue;
      }

      String value = getDisplayValue(questionMap[fieldId]!, this[fieldId]);

      if (value.isNotEmpty) {
        displayFields[fieldId] = value;
      }
    }

    return displayFields;
  }
}

String getDisplayValue(QuestionModel? question, dynamic answer) {
  if (question == null || answer == null) return '';

  if (answer is Map && question.isRangeSelect == true) {
    final min = answer['min'] ?? 'N/A';
    final max = answer['max'] ?? 'N/A';
    return '$min - $max';
  }

  if (question.type == InputType.Location) {
    if (answer is Map<String, dynamic>) {
      return answer['name']?.toString() ?? '';
    }
    return answer.toString();
  }

  if (answer is List) {
    if (answer.isEmpty) return '';

    if (question.type == InputType.Document) {
      final int fileCount = answer.length;
      return '$fileCount file${fileCount <= 1 ? '' : 's'}';
    }

    return answer
        .where((val) => val != null)
        .map((val) => _getOptionDisplayName(question, val))
        .where((name) => name.isNotEmpty)
        .join(', ');
  }

  if (question.isCustomWali()) {
    if (answer is Map<String, dynamic>) {
      return _formatWaliDisplay(answer);
    }
    return '';
  }

  return _getOptionDisplayName(question, answer);
}

String _getOptionDisplayName(QuestionModel question, dynamic value) {
  if (value == null) return '';

  if ((question.isDropdown() || question.isRadio()) &&
      question.selectedField != null &&
      question.showField != null &&
      question.options != null) {
    try {
      final options = question.options as List;
      if (options.isEmpty) return value.toString();

      final option = options.firstWhere(
        (option) =>
            option != null &&
            option[question.selectedField] != null &&
            option[question.selectedField].toString() == value.toString(),
        orElse: () => null,
      );

      if (option != null && option[question.showField] != null) {
        return option[question.showField].toString();
      }
      return value.toString();
    } catch (_) {
      return value.toString();
    }
  }

  if (question.isListType() && question.options != null) {
    try {
      final option = (question.options as List).firstWhere(
        (option) =>
            option[question.selectedField ?? 'value'].toString() ==
            value.toString(),
      );
      return option[question.showField ?? 'name'].toString();
    } catch (_) {
      return value.toString();
    }
  }

  if (question.type == InputType.ClassicDate) {
    try {
      final DateTime? initialDateTime =
          value != null ? DateTime.fromMillisecondsSinceEpoch(value) : null;

      final String initialDateString = initialDateTime != null
          ? '${initialDateTime.year}-${initialDateTime.month.toString().padLeft(2, '0')}-${initialDateTime.day.toString().padLeft(2, '0')}'
          : value.toString();
      return initialDateString;
    } catch (_) {
      return '';
    }
  }

  return value.toString();
}

String _formatWaliDisplay(Map<String, dynamic> waliData) {
  if (waliData.isEmpty) return '';

  final email = waliData['email'];
  final noGuardian = waliData['noGuardian'] ?? false;

  if (email != null && email.toString().isNotEmpty) {
    return email.toString();
  }

  if (noGuardian) {
    return 'No Guardian';
  }

  return '';
}

String dynamicFieldProfileNameField(Map<String, dynamic> dynamicFields) {
  if (dynamicFields.containsKey(DynamicFieldsConstants.name) &&
      dynamicFields[DynamicFieldsConstants.name] != null &&
      dynamicFields[DynamicFieldsConstants.name].toString().isNotEmpty) {
    return dynamicFields[DynamicFieldsConstants.name];
  } else {
    return 'No name';
  }
}
