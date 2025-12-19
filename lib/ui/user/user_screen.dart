// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/user/user_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/user/user_list_vm.dart';
import 'package:flutter_boilerplate/ui/user/user_screen_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/$kSettings/$kSettingsUserManagement';

  final UserScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context);

    return ListScaffold(
      entityType: EntityType.user,
      onHamburgerLongPress: () => store.dispatch(StartUserMultiselect()),
      appBarTitle: ListFilter(
        key: ValueKey('__filter_${state.userListState.filterClearedAt}__'),
        entityType: EntityType.user,
        entityIds: viewModel.userList,
        filter: state.userListState.filter,
        onFilterChanged: (value) {
          store.dispatch(FilterUsers(value));
        },
        onSelectedState: (EntityState state, value) {
          store.dispatch(FilterUsersByState(state));
        },
      ),
      onCheckboxPressed: () {
        if (store.state.userListState.isInMultiselect()) {
          store.dispatch(ClearUserMultiselect());
        } else {
          store.dispatch(StartUserMultiselect());
        }
      },
      body: UserListBuilder(),
      bottomNavigationBar: AppBottomBar(
        entityType: EntityType.user,
        onSelectedSortField: (value) => store.dispatch(SortUsers(value)),
        onSelectedCustom1: (value) =>
            store.dispatch(FilterUsersByCustom1(value)),
        onSelectedCustom2: (value) =>
            store.dispatch(FilterUsersByCustom2(value)),
        onSelectedCustom3: (value) =>
            store.dispatch(FilterUsersByCustom3(value)),
        onSelectedCustom4: (value) =>
            store.dispatch(FilterUsersByCustom4(value)),
        sortFields: [
          UserFields.firstName,
          UserFields.lastName,
          UserFields.email,
        ],
        onSelectedState: (EntityState state, value) {
          store.dispatch(FilterUsersByState(state));
        },
        onCheckboxPressed: () {
          if (store.state.userListState.isInMultiselect()) {
            store.dispatch(ClearUserMultiselect());
          } else {
            store.dispatch(StartUserMultiselect());
          }
        },
      ),
      floatingActionButton:
          state.prefState.isMobile && userCompany.canCreate(EntityType.user)
              ? FloatingActionButton(
                  heroTag: 'user_fab',
                  backgroundColor: Theme.of(context).primaryColorDark,
                  onPressed: () {
                    createEntityByType(
                        context: context, entityType: EntityType.user);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  tooltip: localization!.newUser,
                )
              : null,
    );
  }
}
