// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/user/user_selectors.dart';
import 'user_screen.dart';

class UserScreenBuilder extends StatelessWidget {
  const UserScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserScreenVM>(
      converter: UserScreenVM.fromStore,
      builder: (context, vm) {
        return UserScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class UserScreenVM {
  UserScreenVM({
    required this.isInMultiselect,
    required this.userList,
    required this.userCompany,
    required this.userMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity? userCompany;
  final List<String> userList;
  final BuiltMap<String, UserEntity> userMap;

  static UserScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return UserScreenVM(
      userMap: state.userState.map,
      userList: memoizedFilteredUserList(state.getUISelection(EntityType.user),
          state.userState.map, state.userState.list, state.userListState),
      userCompany: state.userCompany,
      isInMultiselect: state.userListState.isInMultiselect(),
    );
  }
}
