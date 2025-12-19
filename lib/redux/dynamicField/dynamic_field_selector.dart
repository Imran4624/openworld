import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_state.dart';

class DynamicFieldSelectors {
  static bool canMoveNext(DynamicFieldState state) {
    if (state.currentQuestionIndex == -1) return true;

    if (state.questionGroups.isEmpty || 
        state.currentGroupIndex < 0 || 
        state.currentGroupIndex >= state.questionGroups.length) {
      return false;
    }

    final currentGroup = state.questionGroups[state.currentGroupIndex];
    final editQuestions = currentGroup.getQuestionsForEdit();

    if (currentGroup.showAllQuestions) {
      for (final question in editQuestions) {
        if (!question.required) continue;
        final answer = state.answers[currentGroup.id]?[question.id];
        if (!_isAnswerValid(question, answer)) return false;
      }
      return true;
    } else {
      if (state.currentQuestionIndex >= editQuestions.length) return true;
      final currentQuestion = editQuestions[state.currentQuestionIndex];
      if (!currentQuestion.required) return true;
      final answer = state.answers[currentGroup.id]?[currentQuestion.id];
      return _isAnswerValid(currentQuestion, answer);
    }
  }

  static bool _isAnswerValid(QuestionModel question, dynamic answer) {
    switch (question.type) {
      case InputType.Text:
        return answer != null && answer.toString().trim().isNotEmpty;

      case InputType.TextArea:
        return answer != null && answer.toString().trim().isNotEmpty;

      case InputType.CustomWali:
        if (answer == null) return false;
        final Map<String, dynamic> waliAnswer = answer as Map<String, dynamic>;
        return waliAnswer['noGuardian'] == true ||
            (waliAnswer['email'] != null && waliAnswer['email'].isNotEmpty);

      case InputType.Date:
        if (answer == null) return false;
        final parts = answer.toString().split('-');
        return parts.length == 3 && parts.every((part) => part.isNotEmpty);

      case InputType.NumberIncrementable:
        return answer != null;

      case InputType.Document:
        if (answer == null || answer is! List) return false;
        final validFileCount =
            answer.where((item) => item['action'] != 'deleted').length;
        return validFileCount >= question.minValue &&
            validFileCount <= question.maxValue;

      default:
        return answer != null &&
            (answer is! String || answer.isNotEmpty) &&
            (answer is! List || answer.isNotEmpty);
    }
  }
}
