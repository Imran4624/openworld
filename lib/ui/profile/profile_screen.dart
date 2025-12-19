import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/profile/profile_list_vm.dart';
import 'package:flutter_boilerplate/ui/profile/profile_presenter.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

import 'profile_screen_vm.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/profile';

  final ProfileScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context)!;

    return ListScaffold(
      entityType: EntityType.profile,
      onHamburgerLongPress: () => store.dispatch(StartProfileMultiselect()),
      appBarTitle: ListFilter(
        key: ValueKey('__filter_${state.profileListState.filterClearedAt}__'),
        entityType: EntityType.profile,
        entityIds: viewModel.profileList,
        filter: state.profileState.filter.searchTerm,
        onFilterChanged: (value) {
          store.dispatch(FilterProfiles(value!));
          store.dispatch(UpdateProfileFilter(
            state.profileState.filter
                .rebuild((b) => b..searchTerm = value),
          ));
        },
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterProfilesByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdateProfileFilter(
              state.profileState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
          // printL('profileFilter state ==> ${state.profileState}');
        },
        selectedStateFilter: state.profileState.filter.stateFilter,
      ),
      onCheckboxPressed: () {
        if (store.state.profileListState.isInMultiselect()) {
          store.dispatch(ClearProfileMultiselect());
        } else {
          store.dispatch(StartProfileMultiselect());
        }
      },
      body: ProfileListBuilder(),
      bottomNavigationBar: isAdmin(state) || ProjectConfig.appType == AppType.boilerplate
          ? AppBottomBar(
              entityType: EntityType.profile,
              tableColumns: ProfilePresenter.getAllTableFields(userCompany),
              defaultTableColumns:
                  ProfilePresenter.getDefaultTableFields(userCompany),
              onSelectedSortField: (field) {
                final ascending = state.profileState.filter.sortField == field
                    ? !state.profileState.filter.sortAscending
                    : true;
                store.dispatch(UpdateProfileFilter(
                  state.profileState.filter.rebuild((b) => b
                    ..sortField = field
                    ..sortAscending = ascending),
                ));
              },
              sortFields: [
                // STARTER: constant fields - do not remove comment
                ProfileFields.name,
              ],
              onSelectedState: (EntityState filterState, bool? value) {
                store.dispatch(FilterProfilesByState(filterState));
                if (value ?? false) {
                  store.dispatch(UpdateProfileFilter(
                    state.profileState.filter
                        .rebuild((b) => b..stateFilter = filterState),
                  ));
                }
              },
              onCheckboxPressed: () {
                if (store.state.profileListState.isInMultiselect()) {
                  store.dispatch(ClearProfileMultiselect());
                } else {
                  store.dispatch(StartProfileMultiselect());
                }
              },
              // // customValues1: userCompany.getCustomFieldValues(CustomFieldType.profile1,
              // //     excludeBlank: true),
              // // customValues2: userCompany.getCustomFieldValues(CustomFieldType.profile2,
              // //     excludeBlank: true),
              // // customValues3: userCompany.getCustomFieldValues(CustomFieldType.profile3,
              // //     excludeBlank: true),
              // // customValues4: userCompany.getCustomFieldValues(CustomFieldType.profile4,
              //     excludeBlank: true),
              // onSelectedCustom1: (value) =>
              //     store.dispatch(FilterProfilesByCustom1(value)),
              // onSelectedCustom2: (value) =>
              //     store.dispatch(FilterProfilesByCustom2(value)),
              // onSelectedCustom3: (value) =>
              //     store.dispatch(FilterProfilesByCustom3(value)),
              // onSelectedCustom4: (value) =>
              //     store.dispatch(FilterProfilesByCustom4(value)),
            )
          : null,
      floatingActionButton: state.prefState.isMenuFloated &&
              userCompany.canCreate(EntityType.profile) &&
              ProjectConfig.showFloatingCreateButton(EntityType.profile)
          ? FloatingActionButton(
              heroTag: 'profile_fab',
              backgroundColor: Theme.of(context).primaryColorDark,
              onPressed: () {
                createEntityByType(
                    context: context, entityType: EntityType.profile);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: localization.newProfile,
            )
          : null,
    );
  }
}
