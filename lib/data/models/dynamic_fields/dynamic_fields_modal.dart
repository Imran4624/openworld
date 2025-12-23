import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/mock/opw.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

enum SearchableType {
  None,
  ShowInBasicSearch,
  ShowInAdvanceSearch,
}

enum InputType {
  Undefined,
  Text,
  TextArea,
  Radio,
  Dropdown,
  Date,
  Age,
  CustomWali,
  Tags,
  List,
  ListSearchable,
  ListMultiselect,
  ListMultiselectSearchable,
  NumberIncrementable,
  GridMultiSelect,
  ClassicDate,
  Timeline,
  Location,
  Document,
  Range,
  Number,
  Boolean
}

enum QuestionType {
  opw,
}

class DrivesViewField {
  final String id;
  final String logic;

  DrivesViewField({
    required this.id,
    required this.logic,
  });

  factory DrivesViewField.fromJson(Map<String, dynamic> json) {
    return DrivesViewField(
      id: json['id'],
      logic: json['logic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logic': logic,
    };
  }
}

class QuestionModel {
  final String id;
  final String label;
  final InputType type;
  final String? condition;
  final List<DrivesViewField>? drivesViewFields;
  final dynamic options;
  final dynamic inputOptions;
  final String? placeholder;
  final int editOrder;
  final int viewOrder;
  final bool required;
  final bool showInLine;
  final num defaultValue;
  final int minValue;
  final int maxValue;
  final String allowedTypes;
  final List<TimelineNode>? nodes;
  final SearchableType? searchable;
  final String? info;
  final String? checkbox;
  final String? checkboxChecked;
  final String? selectedField;
  final String? showField;
  final bool? isRangeSelect;
  final bool? isMultiSelect;

  QuestionModel({
    required this.id,
    required this.label,
    required this.type,
    this.condition,
    this.drivesViewFields,
    this.options,
    this.inputOptions,
    this.placeholder,
    this.editOrder = 0,
    this.viewOrder = 0,
    this.required = false,
    this.showInLine = false,
    this.minValue = 0,
    this.maxValue = 1000,
    this.defaultValue = 0,
    this.allowedTypes = '',
    this.nodes,
    this.searchable,
    this.info,
    this.checkbox,
    this.checkboxChecked,
    this.selectedField,
    this.showField,
    this.isRangeSelect,
    this.isMultiSelect,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      label: json['label'],
      type: json['type'] != null
          ? InputType.values.firstWhere(
              (e) => e.toString() == json['type'].toString(),
              orElse: () => InputType.Undefined)
          : InputType.Undefined,
      condition: json['condition'],
      drivesViewFields: json['drivesViewFields'] != null
          ? (json['drivesViewFields'] as List)
              .map((item) => DrivesViewField.fromJson(item))
              .toList()
          : null,
      options: json['options'],
      inputOptions: json['input_options'],
      placeholder: json['placeholder'],
      editOrder: json['editOrder'] ?? 0,
      viewOrder: json['viewOrder'] ?? 0,
      required: json['required'] ?? false,
      showInLine: json['showInLine'] ?? false,
      allowedTypes: json['allowedTypes'] ?? "",
      defaultValue: num.tryParse(json['default']?.toString() ?? '') ?? 0,
      minValue: int.tryParse(json['minValue']?.toString() ?? '') ?? 0,
      maxValue: int.tryParse(json['maxValue']?.toString() ?? '') ?? 1000,
      nodes: json['nodes'] != null
          ? (json['nodes'] as List)
              .map((node) => TimelineNode.fromJson(node))
              .toList()
          : null,
      searchable: json['searchable'] != null
          ? SearchableType.values.firstWhere(
              (e) => e.toString() == 'SearchableType.${json['searchable']}')
          : null,
      info: json['info'],
      checkbox: json['checkbox'],
      checkboxChecked: json['checkboxChecked'],
      selectedField: json['selectedField'],
      showField: json['showField'],
      isRangeSelect: json['isRangeSelect'] ?? false,
      isMultiSelect: json['isMultiSelect'] ?? false,
    );
  }

  bool isListType() {
    return type == InputType.List ||
        type == InputType.ListSearchable ||
        type == InputType.ListMultiselect ||
        type == InputType.ListMultiselectSearchable;
  }

  bool isTextType() => type == InputType.Text;
  bool isTextAreaType() => type == InputType.TextArea;
  bool isTagsType() => type == InputType.Tags;
  bool isAgeType() => type == InputType.Age;
  bool isDropdown() => type == InputType.Dropdown;
  bool isRadio() => type == InputType.Radio;
  bool isCustomWali() => type == InputType.CustomWali;
  bool isTimeline() => type == InputType.Timeline;
  bool isLocation() => type == InputType.Location;
  bool isDocument() => type == InputType.Document;
}

class QuestionGroupModel {
  final String id;
  final String name;
  final String description;
  final bool showIntroScreen;
  final bool showSlider;
  final bool showAllQuestions;
  final Map<String, dynamic>? slider;
  final int viewOrder;
  final List<QuestionModel> questions;

  QuestionGroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.showIntroScreen,
    required this.showSlider,
    this.slider,
    required this.showAllQuestions,
    required this.questions,
    required this.viewOrder,
  });

  factory QuestionGroupModel.fromJson(Map<String, dynamic> json) {
    List<QuestionModel> questions = (json['questions'] as List)
        .map((q) => QuestionModel.fromJson(q))
        .toList();

    questions.sort((a, b) => a.editOrder.compareTo(b.editOrder));

    final hasSlider = json['slider'] != null && json['slider'] is Map;
    return QuestionGroupModel(
      id: json['id'] ?? '',
      name: json['group'],
      description: json['description'] ?? '',
      showIntroScreen: json['show_intro_screen'] ?? false,
      showSlider: hasSlider,
      slider: hasSlider ? json['slider'] : null,
      showAllQuestions: json['show_all_questions'] ?? false,
      questions: questions,
      viewOrder: json['view_order'] ?? 999,
    );
  }

  static List<QuestionGroupModel> fromQuestionList(QuestionType type) {
    switch (type) {
      case QuestionType.opw:
        return (opwQuestions['groups'] as List)
            .map((group) => QuestionGroupModel.fromJson(group))
            .toList();
      default:
        logError(' Questions not defined for question type: $type');
        throw ArgumentError('Unsupported question type: $type');
    }
  }

  List<QuestionModel> getQuestions(DynamicFieldSubmissionType type) {
    switch (type) {
      case DynamicFieldSubmissionType.search:
        return getQuestionsForView();
      case DynamicFieldSubmissionType.edit:
      case DynamicFieldSubmissionType.create:
        return getQuestionsForEdit();
      default:
        return getQuestionsForView();
    }
  }

  List<QuestionModel> getQuestionsForEdit() {
    return questions.where((q) => q.editOrder != -1).toList()
      ..sort((a, b) => a.editOrder.compareTo(b.editOrder));
  }

  List<QuestionModel> getQuestionsForView() {
    return questions.where((q) => q.viewOrder != -1).toList()
      ..sort((a, b) => a.viewOrder.compareTo(b.viewOrder));
  }
}

class TimelineNode {
  String heading;
  DateTime? date;
  TimeOfDay? time;
  String? description;

  TimelineNode({
    this.heading = '',
    this.date,
    this.time,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'description': description,
    };
  }

  static TimelineNode fromJson(Map<String, dynamic> json) {
    TimeOfDay? timeOfDay;
    if (json['time'] != null) {
      final timeParts = json['time'].split(':');
      if (timeParts.length == 2) {
        try {
          timeOfDay = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
        } catch (e) {
          logError(' Error parsing time: $e');
        }
      }
    }

    return TimelineNode(
      heading: json['heading'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: timeOfDay,
      description: json['description'],
    );
  }
}

extension QuestionTypeExtension on QuestionType {
  String getName() {
    switch (this) {
      case QuestionType.opw:
        return opwQuestions['name'] as String;
      default:
        return '';
    }
  }
}
