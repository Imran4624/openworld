import 'dart:async';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class ProfileOperationViewScreen extends StatelessWidget {
  const ProfileOperationViewScreen({
    Key? key,
    this.isFilter = false,
  }) : super(key: key);

  static const String route = '/profile_operation/view';

  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileOperationViewVM>(
      converter: (Store<AppState> store) {
        return ProfileOperationViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return ProfileOperationView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class ProfileOperationViewVM {
  ProfileOperationViewVM({
    required this.state,
    required this.profileOperation,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
  });

  factory ProfileOperationViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final profileOperation = state.profileOperationState
            .map[state.profileOperationUIState.selectedId] ??
        ProfileOperationEntity(id: state.profileOperationUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadProfileOperation(
          completer: completer, profileOperationId: profileOperation.id));
      return completer.future;
    }

    return ProfileOperationViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: profileOperation.isNew,
      profileOperation: profileOperation,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(ProfileOperationScreen.route));

        if (state.prefState.isMobile) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
              ProfileOperationScreen.route, (Route<dynamic> route) => false);
        } else {
          viewEntitiesByType(entityType: EntityType.profileOperation);
        }
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([profileOperation], action, autoPop: true),
    );
  }

  final AppState state;
  final ProfileOperationEntity profileOperation;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
