import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_list_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_presenter.dart';

import 'profile_operation_screen_vm.dart';

class ProfileOperationScreen extends StatelessWidget {
  const ProfileOperationScreen({
    super.key,
    required this.viewModel,
  });

  static const String route = '/profile_operation';

  final ProfileOperationScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;

    return ListScaffold(
      entityType: EntityType.profileOperation,
      onHamburgerLongPress: () =>
          store.dispatch(StartProfileOperationMultiselect()),
      appBarTitle: Text(
        'Connections',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      onCheckboxPressed: () {
        if (store.state.profileOperationListState.isInMultiselect()) {
          store.dispatch(ClearProfileOperationMultiselect());
        } else {
          store.dispatch(StartProfileOperationMultiselect());
        }
      },
      body: const ProfileOperationListBuilder(),
      bottomNavigationBar: ProjectConfig
              .showBottomCheckBoxAndFiltersByEntityType(
                  EntityType.profileOperation, isAdmin(state)) && isAuthenticated(state)
          ? AppBottomBar(
              entityType: EntityType.profileOperation,
              tableColumns:
                  ProfileOperationPresenter.getAllTableFields(userCompany),
              defaultTableColumns:
                  ProfileOperationPresenter.getDefaultTableFields(userCompany),
              onSelectedSortField: (field) {
                final ascending =
                    state.profileOperationState.filter.sortField == field
                        ? !state.profileOperationState.filter.sortAscending
                        : true;
                store.dispatch(UpdateProfileOperationFilter(
                  state.profileOperationState.filter.rebuild((b) => b
                    ..sortField = field
                    ..sortAscending = ascending),
                ));
              },
              sortFields: const [
                // STARTER: constant fields - do not remove comment
                ProfileOperationFields.status,
                ProfileOperationFields.comment,
                ProfileOperationFields.type,
              ],
              onSelectedState: (EntityState filterState, bool? value) {
                store.dispatch(FilterProfileOperationsByState(filterState));
                if (value ?? false) {
                  store.dispatch(UpdateProfileOperationFilter(
                    state.profileOperationState.filter
                        .rebuild((b) => b..stateFilter = filterState),
                  ));
                }
              },
              onCheckboxPressed: () {
                if (store.state.profileOperationListState.isInMultiselect()) {
                  store.dispatch(ClearProfileOperationMultiselect());
                } else {
                  store.dispatch(StartProfileOperationMultiselect());
                }
              },
            )
          : null,
    );
  }
}
