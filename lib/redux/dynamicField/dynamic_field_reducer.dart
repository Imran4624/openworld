// dynamic_field_reducer.dart
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/condition_evaluator.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'dynamic_field_actions.dart';
import 'dynamic_field_state.dart';

final dynamicFieldReducer = combineReducers<DynamicFieldState>([
  TypedReducer<DynamicFieldState, LoadQuestionsSuccess>(
      _questionsLoadedSuccess),
  TypedReducer<DynamicFieldState, UpdateAnswerAction>(_updateAnswer),
  TypedReducer<DynamicFieldState, DisposeControllersAction>(
      _disposeDynamicFieldControllers),
  TypedReducer<DynamicFieldState, LoadAnswersSuccess>(_loadAnswersSuccess),
  TypedReducer<DynamicFieldState, UpdateSelectedTab>(_updateTabIndex),
  TypedReducer<DynamicFieldState, MoveNextAction>(_moveNext),
  TypedReducer<DynamicFieldState, MovePreviousAction>(_movePrevious),
]);

DynamicFieldState _questionsLoadedSuccess(
    DynamicFieldState state, LoadQuestionsSuccess action) {
  final updatedControllers =
      Map<String, TextEditingController>.from(state.inputFieldControllers);

  for (var group in action.questionGroups) {
    for (var question in group.questions) {
      if (question.isTextType() ||
          question.isCustomWali() ||
          question.isTextAreaType()) {
        updatedControllers[question.id] =
            updatedControllers[question.id] ?? TextEditingController();
      }
    }
  }

  final initialQuestionIndex = action.questionGroups.isNotEmpty &&
          (action.questionGroups[0].showIntroScreen ||
              action.questionGroups[0].showSlider)
      ? -1
      : 0;
    
  action.completer?.complete();

  return state.rebuild((b) => b
    ..questionGroups.replace(action.questionGroups)
    ..questionGroupType = action.questionType
    ..isLoading = false
    ..inputFieldControllers = updatedControllers
    ..currentGroupIndex = 0
    ..currentQuestionIndex = initialQuestionIndex);
}

DynamicFieldState _updateAnswer(
    DynamicFieldState state, UpdateAnswerAction action) {
  return state.rebuild((b) {
    final groupAnswers = state.answers[action.groupId]?.toBuilder() ??
        MapBuilder<String, dynamic>();
    groupAnswers[action.questionId] = action.value;
    return b..answers.addAll({action.groupId: groupAnswers.build()});
  });
}

DynamicFieldState _disposeDynamicFieldControllers(
    DynamicFieldState state, DisposeControllersAction action) {
  return state.rebuild((b) {
    state.inputFieldControllers
        .forEach((key, controller) => controller.dispose());
    return state.rebuild((b) => b..inputFieldControllers?.clear());
  });
}

DynamicFieldState _loadAnswersSuccess(
    DynamicFieldState state, LoadAnswersSuccess action) {
  return state.rebuild((b) {
    if (action.answers.isEmpty) {
      return b
        ..answers.clear()
        ..savedAnswers?.clear();
    } else {
      return b..savedAnswers?.addAll(action.answers);
    }
  });
}

DynamicFieldState _updateTabIndex(
    DynamicFieldState state, UpdateSelectedTab action) {
  return state.rebuild((b) => b..selectedTabIndex = action.index);
}

DynamicFieldState _moveNext(DynamicFieldState state, MoveNextAction action) {
  if (state.questionGroups.isEmpty ||
      state.currentGroupIndex < 0 ||
      state.currentGroupIndex >= state.questionGroups.length) {
    return state;
  }

  final currentGroup = state.questionGroups[state.currentGroupIndex];
  logInfo(
      'current question index ==> ${state.currentQuestionIndex} and current group index ==> ${state.currentGroupIndex}');
  if (state.currentQuestionIndex == -1) {
    return state.rebuild((b) => b..currentQuestionIndex = 0);
  }

  if (currentGroup.showAllQuestions) {
    if (state.currentGroupIndex < state.questionGroups.length - 1) {
      final nextGroup = state.questionGroups[state.currentGroupIndex + 1];
      return state.rebuild((b) => b
        ..currentGroupIndex = state.currentGroupIndex + 1
        ..currentQuestionIndex =
            nextGroup.showIntroScreen || nextGroup.showSlider ? -1 : 0);
    }
  } else {
    final editQuestions = currentGroup.getQuestionsForEdit();
    List<QuestionModel> visibleQuestions = editQuestions.where((question) {
      return ConditionEvaluator.evaluateCondition(
          question.condition, state.answers);
    }).toList();

    if (state.currentQuestionIndex < visibleQuestions.length - 1) {
      return state.rebuild(
          (b) => b..currentQuestionIndex = state.currentQuestionIndex + 1);
    } else if (state.currentGroupIndex < state.questionGroups.length - 1) {
      final nextGroup = state.questionGroups[state.currentGroupIndex + 1];
      return state.rebuild((b) => b
        ..currentGroupIndex = state.currentGroupIndex + 1
        ..currentQuestionIndex =
            nextGroup.showIntroScreen || nextGroup.showSlider ? -1 : 0);
    }
  }

  return state;
}

DynamicFieldState _movePrevious(
    DynamicFieldState state, MovePreviousAction action) {
  if (state.questionGroups.isEmpty ||
      state.currentGroupIndex < 0 ||
      state.currentGroupIndex >= state.questionGroups.length) {
    return state;
  }

  final currentGroup = state.questionGroups[state.currentGroupIndex];

  if (currentGroup.showAllQuestions) {
    if (state.currentQuestionIndex > 0) {
      return state.rebuild(
          (b) => b..currentQuestionIndex = state.currentQuestionIndex - 1);
    } else if (state.currentGroupIndex > 0) {
      final previousGroup = state.questionGroups[state.currentGroupIndex - 1];
      return state.rebuild((b) => b
        ..currentGroupIndex = state.currentGroupIndex - 1
        ..currentQuestionIndex =
            previousGroup.getQuestionsForEdit().length - 1);
    }
  } else {
    if (state.currentQuestionIndex > 0) {
      return state.rebuild(
          (b) => b..currentQuestionIndex = state.currentQuestionIndex - 1);
    } else if (state.currentGroupIndex > 0) {
      final previousGroup = state.questionGroups[state.currentGroupIndex - 1];

      final prevEditQuestions = previousGroup.getQuestionsForEdit();
      List<QuestionModel> prevVisibleQuestions =
          prevEditQuestions.where((question) {
        return ConditionEvaluator.evaluateCondition(
            question.condition, state.answers);
      }).toList();

      return state.rebuild((b) => b
        ..currentGroupIndex = state.currentGroupIndex - 1
        ..currentQuestionIndex = prevVisibleQuestions.isNotEmpty
            ? prevVisibleQuestions.length - 1
            : 0);
    }
  }

  return state;
}
