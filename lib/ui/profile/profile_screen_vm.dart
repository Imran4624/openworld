import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_selectors.dart';
import 'package:redux/redux.dart';

import 'profile_screen.dart';

class ProfileScreenBuilder extends StatelessWidget {
  const ProfileScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileScreenVM>(
      converter: ProfileScreenVM.fromStore,
      onInit: (store) {
        store.dispatch(LoadProfiles(isRefresh: true));
      },
      builder: (context, vm) {
        return ProfileScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class ProfileScreenVM {
  ProfileScreenVM({
    required this.isInMultiselect,
    required this.profileList,
    required this.userCompany,
    required this.onEntityAction,
    required this.profileMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> profileList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, ProfileEntity> profileMap;

  static ProfileScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ProfileScreenVM(
      profileMap: state.profileState.map,
      profileList: memoizedFilteredProfileList(
        state.getUISelection(EntityType.profile),
        state.profileState.map,
        state.profileState.list,
        state.profileListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.profileListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> profiles,
              EntityAction action) =>
          handleProfileAction(context, profiles, action),
    );
  }
}
