import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_selectors.dart';
import 'package:redux/redux.dart';

import 'profile_operation_screen.dart';

class ProfileOperationScreenBuilder extends StatelessWidget {
  const ProfileOperationScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileOperationScreenVM>(
      converter: ProfileOperationScreenVM.fromStore,
      onInit: (store) {
        store.dispatch(LoadProfileOperations(isRefresh: true));
      },
      builder: (context, vm) {
        return ProfileOperationScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class ProfileOperationScreenVM {
  ProfileOperationScreenVM({
    required this.isInMultiselect,
    required this.profileOperationList,
    required this.userCompany,
    required this.onEntityAction,
    required this.profileOperationMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> profileOperationList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, ProfileOperationEntity> profileOperationMap;

  static ProfileOperationScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return ProfileOperationScreenVM(
      profileOperationMap: state.profileOperationState.map,
      profileOperationList: memoizedFilteredProfileOperationList(
        state.getUISelection(EntityType.profileOperation),
        state.profileOperationState.map,
        state.profileOperationState.list,
        state.profileOperationListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.profileOperationListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> profileOperations,
              EntityAction action) =>
          handleProfileOperationAction(context, profileOperations, action),
    );
  }
}
