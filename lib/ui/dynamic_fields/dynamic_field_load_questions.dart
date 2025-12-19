import 'dart:async';

import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';

void loadDynamicFieldQuestions(QuestionType questionType, {Completer? completer}) {
  final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);

  // if (store.state.dynamicFieldState.questionGroups.isEmpty) {
    store.dispatch(LoadQuestions(questionType));
  // } else {
  //   completer?.complete();
  // }
}
