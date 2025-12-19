import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/tables/entity_list.dart';
import 'package:flutter_boilerplate/ui/app/tables/profile_list.dart';
import 'package:flutter_boilerplate/ui/profile/profile_list_item.dart';
import 'package:flutter_boilerplate/ui/profile/profile_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/redux/profile/profile_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';

class ProfileListBuilder extends StatelessWidget {
  const ProfileListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileListVM>(
      converter: ProfileListVM.fromStore,
      builder: (context, viewModel) {
        return ProfileList(
          entityType: EntityType.profile,
          presenter: ProfilePresenter(),
          state: viewModel.state,
          entityList: viewModel.profileList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.grid,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final profileId = viewModel.profileList[index];
            final profile = viewModel.profileMap[profileId]!;
            final listState = state.getListState(EntityType.profile);
            final isInMultiselect = listState.isInMultiselect();

            return ProfileListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              profile: profile,
              isChecked: isInMultiselect && listState.isSelected(profile.id),
            );
          },
        );
      },
    );
  }
}

class ProfileListVM {
  ProfileListVM({
    required this.state,
    required this.userCompany,
    required this.profileList,
    required this.profileMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static ProfileListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadProfiles(
          completer: completer, filter: store.state.profileState.filter));

      return completer.future;
    }

    final state = store.state;
    final currentUserId = state.user.id;
    final profileList = memoizedFilteredProfileList(
      state.getUISelection(EntityType.profile),
      state.profileState.map,
      state.profileState.list,
      state.profileListState,
    ).where((profileId) {
      // Filter out the current user's profile
      final profile = state.profileState.map[profileId];
      return profile?.id != currentUserId &&
          profile?.id != getLoggedInUserId(store);
    }).toList();

    return ProfileListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.profileListState,
      profileList: profileList,
      profileMap: state.profileState.map,
      isLoading: state.isLoading,
      filter: state.profileState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> profiles,
              EntityAction action) =>
          handleProfileAction(context, profiles, action),
      onRefreshed: (context) => _handleRefresh(context),
      tableColumns:
          state.userCompany.settings?.getTableColumns(EntityType.profile) ??
              ProfilePresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateProfileFilter(
        state.profileState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.profileState.filter.sortField == field
              ? !state.profileState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearProfileMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> profileList;
  final BuiltMap<String, ProfileEntity> profileMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
