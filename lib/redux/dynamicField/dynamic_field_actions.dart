import 'dart:async';

import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';

class ViewDynamicFields {
  ViewDynamicFields(this.questionType, {this.isEdit = false});
  final QuestionType questionType;
  final bool isEdit;

  @override
  String toString() {
    return 'ViewDynamicFields';
  }
}

class ViewSearchScreen {
  ViewSearchScreen(this.questionType);
  final QuestionType questionType;

  @override
  String toString() {
    return 'ViewSearchScreen';
  }
}

class LoadQuestions implements StartLoading {
  LoadQuestions(this.questionType);
  final QuestionType questionType;

  @override
  String toString() {
    return 'LoadQuestions';
  }
}

class DisposeControllersAction {
  @override
  String toString() {
    return 'DisposeControllersAction';
  }
}

class LoadAnswers implements StartSaving {
  LoadAnswers(this.completer, this.questionType);
  final Completer completer;
  final QuestionType questionType;

  @override
  String toString() {
    return 'LoadAnswers';
  }
}

class LoadAnswersSuccess implements StopSaving {
  LoadAnswersSuccess(this.answers);

  final Map<String, dynamic> answers;

  @override
  String toString() {
    return 'LoadAnswersSuccess';
  }
}

class SaveDynamicFieldDetails {
  SaveDynamicFieldDetails(this.dynamicFieldsData, this.entityType);
  final dynamic dynamicFieldsData;
  final EntityType entityType;

  @override
  String toString() {
    return 'SaveDynamicFieldDetails';
  }
}

class ProfileSavedAction {
  @override
  String toString() {
    return 'ProfileSavedAction';
  }
}

class LoadQuestionsSuccess implements StopLoading {
  LoadQuestionsSuccess(this.questionGroups, this.questionType, {this.completer});

  final List<QuestionGroupModel> questionGroups;
  final QuestionType questionType;
  final Completer? completer;

  @override
  String toString() {
    return 'LoadQuestionsSuccess';
  }
}

class UpdateSelectedTab {
  UpdateSelectedTab(this.index);
  final int index;

  @override
  String toString() {
    return 'UpdateSelectedTab';
  }
}

class UpdateAnswerAction {
  UpdateAnswerAction(this.groupId, this.questionId, this.value);

  final String groupId;
  final String questionId;
  final dynamic value;

  @override
  String toString() {
    return 'UpdateAnswerAction';
  }
}

class MoveNextAction {
  @override
  String toString() {
    return 'MoveNextAction';
  }
}

class MovePreviousAction {
  @override
  String toString() {
    return 'MovePreviousAction';
  }
}

class SubmitAction {
  @override
  String toString() {
    return 'SubmitAction';
  }
}
