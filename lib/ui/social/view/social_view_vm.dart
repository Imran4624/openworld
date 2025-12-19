import 'dart:async';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/social/social_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/social/social_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/social/view/social_view.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class SocialViewScreen extends StatelessWidget {
  const SocialViewScreen({
    Key? key,
    this.isFilter = false,
  }) : super(key: key);

  static const String route = '/social/view';

  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SocialViewVM>(
      converter: (Store<AppState> store) {
        return SocialViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return SocialView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class SocialViewVM {
  SocialViewVM({
    required this.state,
    required this.social,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
  });

  factory SocialViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final social = state.socialState.map[state.socialUIState.selectedId] ??
        SocialEntity(id: state.socialUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadSocial(completer: completer, socialId: social.id));
      return completer.future;
    }

    return SocialViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: social.isNew,
      social: social,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(SocialScreen.route));
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([social], action, autoPop: true),
    );
  }

  final AppState state;
  final SocialEntity social;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
