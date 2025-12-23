import 'dart:async';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({
    Key? key,
    this.isFilter = false,
  }) : super(key: key);

  static const String route = '/profile/view';

  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileViewVM>(
      converter: (Store<AppState> store) {
        return ProfileViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return ProfileView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class ProfileViewVM {
  ProfileViewVM({
    required this.state,
    required this.profile,
    required this.company,
    required this.onEntityAction,
    required this.onRefreshed,
    required this.isSaving,
    required this.isLoading,
    required this.isDirty,
    required this.onBackPressed,
  });

  factory ProfileViewVM.fromStore(Store<AppState> store) {
    final state = store.state;

    var profile = ProfileEntity(id: state.profileUIState.selectedId);
    if (state.profileUIState.selectedId == getLoggedInUserId(store)) {
      profile = state.profileState.loggedInUserProfile;
    } else {
      profile = state.profileState.map[state.profileUIState.selectedId] ??
          ProfileEntity(id: state.profileUIState.selectedId);
    }
    Future<Null> _handleRefresh(BuildContext context) {
      final completer =
          snackBarCompleter<Null>(AppLocalization.of(context)!.refreshComplete);
      store.dispatch(LoadProfile(completer: completer, profileId: profile.id));
      return completer.future;
    }

    return ProfileViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: profile.isNew,
      profile: profile,
      onRefreshed: (context) => _handleRefresh(context),
      onBackPressed: () {
        RoutingRules.defaultEntityLoadingRouting();
      },
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions([profile], action, autoPop: true),
    );
  }

  final AppState state;
  final ProfileEntity profile;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
