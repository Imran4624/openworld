// dynamic_field_state.dart
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/project_config.dart';

part 'dynamic_field_state.g.dart';

abstract class DynamicFieldState
    implements Built<DynamicFieldState, DynamicFieldStateBuilder> {
  factory DynamicFieldState() {
    return _$DynamicFieldState._(
      questionGroups: BuiltList<QuestionGroupModel>(),
      answers: BuiltMap<String, BuiltMap<String, dynamic>>(),
      savedAnswers: Map<String, dynamic>(),
      currentGroupIndex: 0,
      currentQuestionIndex: -1,
      isLoading: true,
      inputFieldControllers: {},
      selectedTabIndex: 0,
      questionGroupType: ProjectConfig.onBoardingQuestionType,
    );
  }
  DynamicFieldState._();

  @override
  @memoized
  int get hashCode;

  BuiltList<QuestionGroupModel> get questionGroups;
  BuiltMap<String, BuiltMap<String, dynamic>> get answers;
  Map<String, dynamic> get savedAnswers;
  int get currentGroupIndex;
  int get currentQuestionIndex;
  bool get isLoading;
  Map<String, dynamic> get inputFieldControllers;

  QuestionType get questionGroupType;

  int get selectedTabIndex;

  DynamicFieldState loadQuestions(BuiltList<QuestionGroupModel> questions) {
    return rebuild((b) => b..questionGroups.replace(questions));
  }

  DynamicFieldState updateAnswer(
      String groupId, String questionId, dynamic value) {
    return rebuild((b) {
      final groupAnswers =
          answers[groupId]?.toBuilder() ?? MapBuilder<String, dynamic>();
      groupAnswers[questionId] = value;

      return b..answers.addAll({groupId: groupAnswers.build()});
    });
  }

  DynamicFieldState moveNext() {
    if (currentQuestionIndex == -1) {
      return rebuild((b) => b..currentQuestionIndex = 0);
    }

    if (questionGroups.isEmpty ||
        currentGroupIndex < 0 ||
        currentGroupIndex >= questionGroups.length) {
      return this;
    }

    final currentGroup = questionGroups[currentGroupIndex];

    if (currentGroup.showAllQuestions) {
      if (currentGroupIndex < questionGroups.length - 1) {
        final nextGroup = questionGroups[currentGroupIndex + 1];
        return rebuild((b) => b
          ..currentGroupIndex = currentGroupIndex + 1
          ..currentQuestionIndex =
              nextGroup.showIntroScreen || nextGroup.showSlider ? -1 : 0);
      }
    } else {
      final editQuestions = currentGroup.getQuestionsForEdit();
      if (currentQuestionIndex < editQuestions.length - 1) {
        return rebuild(
            (b) => b..currentQuestionIndex = currentQuestionIndex + 1);
      } else if (currentGroupIndex < questionGroups.length - 1) {
        final nextGroup = questionGroups[currentGroupIndex + 1];
        return rebuild((b) => b
          ..currentGroupIndex = currentGroupIndex + 1
          ..currentQuestionIndex =
              nextGroup.showIntroScreen || nextGroup.showSlider ? -1 : 0);
      }
    }
    return this;
  }

  DynamicFieldState movePrevious() {
    if (currentQuestionIndex > 0) {
      return rebuild((b) => b..currentQuestionIndex = currentQuestionIndex - 1);
    } else if (currentGroupIndex > 0) {
      if (questionGroups.isEmpty ||
          currentGroupIndex < 0 ||
          currentGroupIndex >= questionGroups.length) {
        return this;
      }

      final previousGroup = questionGroups[currentGroupIndex - 1];
      return rebuild((b) => b
        ..currentGroupIndex = currentGroupIndex - 1
        ..currentQuestionIndex =
            previousGroup.getQuestionsForEdit().length - 1);
    }
    return this;
  }

  DynamicFieldState setLoading(bool value) {
    return rebuild((b) => b..isLoading = value);
  }

  static Serializer<DynamicFieldState> get serializer =>
      _$dynamicFieldStateSerializer;
}
