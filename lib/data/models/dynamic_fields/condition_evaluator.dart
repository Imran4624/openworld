import 'package:built_collection/built_collection.dart';

class ConditionEvaluator {
  /// Evaluates a condition expression against form values
  ///
  /// Example conditions:
  /// - "gender == 2"
  /// - "age > 25"
  /// - "education in ('doctor', 'engineer')"
  /// - "profession != 'unemployed'"
  /// - "gender == 2 && age > 25"
  /// - "education in ('doctor', 'engineer') || profession != 'unemployed'"
  /// - "reason in 1" (for single value check in list)
  /// - "reason in (1, 2, 3)" (for multiple values check in list)
  static bool evaluateCondition(String? condition,
      BuiltMap<String, BuiltMap<String, dynamic>> formValues) {
    // If no condition is specified, the question should be shown
    if (condition == null || condition.trim().isEmpty) {
      return true;
    }

    dynamic findKeyValue(String key) {
      // First, try to find the key directly in any group
      for (final groupValues in formValues.values) {
        if (groupValues.containsKey(key)) {
          return groupValues[key];
        }
      }
      
      // If not found directly, search recursively in nested structures
      for (final groupValues in formValues.values) {
        final result = _findKeyValueRecursive(groupValues, key);
        if (result != null) return result;
      }
      
      return null;
    }

    try {
      // Handle AND operator (&&)
      if (condition.contains('&&')) {
        List<String> conditions = condition.split('&&');
        return conditions.every((c) => evaluateCondition(c.trim(), formValues));
      }

      // Handle OR operator (||)
      if (condition.contains('||')) {
        List<String> conditions = condition.split('||');
        return conditions.any((c) => evaluateCondition(c.trim(), formValues));
      }

      // Handle 'in' operator - this is the main fix for your issue
      if (condition.contains(' in ')) {
        List<String> parts = condition.split(' in ');
        if (parts.length != 2) return false;
        
        String field = parts[0].trim();
        String valuesStr = parts[1].trim();

        final fieldValue = findKeyValue(field);
        print('Field: $field, Field Value: $fieldValue, Values String: $valuesStr');

        if (fieldValue == null) return false;

        if (!valuesStr.startsWith('(')) {
          final targetValue = _parseValue(valuesStr);
          return _checkValueInFieldValue(fieldValue, targetValue);
        }

        if (valuesStr.startsWith('(') && valuesStr.endsWith(')')) {
          valuesStr = valuesStr.substring(1, valuesStr.length - 1);
        }

        List<String> valuesList = valuesStr
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

        for (String valueStr in valuesList) {
          final targetValue = _parseValue(valueStr);
          if (_checkValueInFieldValue(fieldValue, targetValue)) {
            return true;
          }
        }
        return false;
      }

      // Handle comparison operations
      if (condition.contains('==')) {
        List<String> parts = condition.split('==');
        if (parts.length != 2) return false;
        String field = parts[0].trim();
        String value = parts[1].trim();
        final fieldValue = findKeyValue(field);
        return _compareValues(fieldValue, _parseValue(value));
      }

      if (condition.contains('!=')) {
        List<String> parts = condition.split('!=');
        if (parts.length != 2) return false;
        String field = parts[0].trim();
        String value = parts[1].trim();
        final fieldValue = findKeyValue(field);
        return !_compareValues(fieldValue, _parseValue(value));
      }

      if (condition.contains('>=')) {
        List<String> parts = condition.split('>=');
        if (parts.length != 2) return false;
        String field = parts[0].trim();
        String value = parts[1].trim();
        final fieldValue = findKeyValue(field);
        return _compareGreaterThanOrEqual(fieldValue, _parseValue(value));
      }

      if (condition.contains('<=')) {
        List<String> parts = condition.split('<=');
        if (parts.length != 2) return false;
        String field = parts[0].trim();
        String value = parts[1].trim();
        final fieldValue = findKeyValue(field);
        return _compareLessThanOrEqual(fieldValue, _parseValue(value));
      }

      if (condition.contains('>')) {
        List<String> parts = condition.split('>');
        if (parts.length != 2) return false;
        String field = parts[0].trim();
        String value = parts[1].trim();
        final fieldValue = findKeyValue(field);
        return _compareGreaterThan(fieldValue, _parseValue(value));
      }

      if (condition.contains('<')) {
        List<String> parts = condition.split('<');
        if (parts.length != 2) return false;
        String field = parts[0].trim();
        String value = parts[1].trim();
        final fieldValue = findKeyValue(field);
        return _compareLessThan(fieldValue, _parseValue(value));
      }

      // If we reach here, the condition format wasn't recognized
      print('Warning: Unrecognized condition format: $condition');
      return true;
    } catch (e) {
      print('Error evaluating condition "$condition": $e');
      // If there's an error in evaluation, show the question by default
      return true;
    }
  }

  static dynamic _findKeyValueRecursive(BuiltMap<String, dynamic> data, String key) {
    if (data.containsKey(key)) {
      return data[key];
    }
    
    for (final value in data.values) {
      if (value is BuiltMap<String, dynamic>) {
        final nestedResult = _findKeyValueRecursive(value, key);
        if (nestedResult != null) return nestedResult;
      } else if (value is BuiltList) {
        for (final item in value) {
          if (item is BuiltMap<String, dynamic>) {
            final nestedResult = _findKeyValueRecursive(item, key);
            if (nestedResult != null) return nestedResult;
          }
        }
      }
    }
    return null;
  }

  /// Check if a target value exists in the field value
  /// Field value can be a single value, list, or other types
  static bool _checkValueInFieldValue(dynamic fieldValue, dynamic targetValue) {
    if (fieldValue == null) return false;

    // If field value is a list, check if target value is in the list
    if (fieldValue is List) {
      return fieldValue.any((item) => _compareValues(item, targetValue));
    }

    // If field value is a BuiltList, check if target value is in the list
    if (fieldValue is BuiltList) {
      return fieldValue.any((item) => _compareValues(item, targetValue));
    }

    // For single values, do direct comparison
    return _compareValues(fieldValue, targetValue);
  }

  static dynamic _parseValue(String value) {
    // Remove quotes if present
    if ((value.startsWith("'") && value.endsWith("'")) ||
        (value.startsWith('"') && value.endsWith('"'))) {
      return value.substring(1, value.length - 1);
    }

    // Try to parse as number
    if (int.tryParse(value) != null) {
      return int.parse(value);
    }

    if (double.tryParse(value) != null) {
      return double.parse(value);
    }

    // For boolean values
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;

    // Default to string
    return value;
  }

  static bool _compareValues(dynamic value1, dynamic value2) {
    if (value1 == null && value2 == null) return true;
    if (value1 == null || value2 == null) return false;

    // Convert to same type if possible
    if (value1 is num && value2 is String) {
      double? parsed = double.tryParse(value2);
      if (parsed != null) {
        value2 = parsed;
      }
    } else if (value1 is String && value2 is num) {
      value1 = double.tryParse(value1) ?? value1;
    }

    return value1 == value2;
  }

  static bool _compareGreaterThan(dynamic value1, dynamic value2) {
    if (value1 == null || value2 == null) return false;

    if (value1 is num && value2 is num) {
      return value1 > value2;
    }

    // Try to convert strings to numbers
    if (value1 is String && double.tryParse(value1) != null) {
      value1 = double.parse(value1);
    }

    if (value2 is String && double.tryParse(value2) != null) {
      value2 = double.parse(value2);
    }

    if (value1 is num && value2 is num) {
      return value1 > value2;
    }

    // String comparison
    if (value1 is String && value2 is String) {
      return value1.compareTo(value2) > 0;
    }

    return false;
  }

  static bool _compareLessThan(dynamic value1, dynamic value2) {
    if (value1 == null || value2 == null) return false;

    if (value1 is num && value2 is num) {
      return value1 < value2;
    }

    // Try to convert strings to numbers
    if (value1 is String && double.tryParse(value1) != null) {
      value1 = double.parse(value1);
    }

    if (value2 is String && double.tryParse(value2) != null) {
      value2 = double.parse(value2);
    }

    if (value1 is num && value2 is num) {
      return value1 < value2;
    }

    // String comparison
    if (value1 is String && value2 is String) {
      return value1.compareTo(value2) < 0;
    }

    return false;
  }

  static bool _compareGreaterThanOrEqual(dynamic value1, dynamic value2) {
    return _compareGreaterThan(value1, value2) ||
        _compareValues(value1, value2);
  }

  static bool _compareLessThanOrEqual(dynamic value1, dynamic value2) {
    return _compareLessThan(value1, value2) || _compareValues(value1, value2);
  }
}
