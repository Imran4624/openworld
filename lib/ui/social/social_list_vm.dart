import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/tables/improvedEntityList.dart';
import 'package:flutter_boilerplate/ui/social/social_list_item.dart';
import 'package:flutter_boilerplate/ui/social/social_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/social/social_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/social/social_actions.dart';

class SocialListBuilder extends StatelessWidget {
  const SocialListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SocialListVM>(
      converter: SocialListVM.fromStore,
      builder: (context, viewModel) {
        return ImprovedEntityList(
          entityType: EntityType.social,
          presenter: SocialPresenter(),
          state: viewModel.state,
          entityList: viewModel.socialList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.list,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final state = viewModel.state;
            final socialId = viewModel.socialList[index];
            final social = viewModel.socialMap[socialId]!;
            final listState = state.getListState(EntityType.social);
            final isInMultiselect = listState.isInMultiselect();

            return SocialListItem(
              user: viewModel.state.user,
              filter: viewModel.filter,
              social: social,
              isChecked: isInMultiselect && listState.isSelected(social.id),
            );
          },
        );
      },
    );
  }
}

class SocialListVM {
  SocialListVM({
    required this.state,
    required this.userCompany,
    required this.socialList,
    required this.socialMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static SocialListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadSocials(
          completer: completer, filter: store.state.socialState.filter));

      return completer.future;
    }

    final state = store.state;

    return SocialListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.socialListState,
      socialList: memoizedFilteredSocialList(
        state.getUISelection(EntityType.social),
        state.socialState.map,
        state.socialState.list,
        state.socialListState,
      ),
      socialMap: state.socialState.map,
      isLoading: state.isLoading,
      filter: state.socialState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> socials,
              EntityAction action) =>
          handleSocialAction(context, socials, action),
      onRefreshed: (context) => _handleRefresh(context),
      tableColumns:
          state.userCompany.settings?.getTableColumns(EntityType.social) ??
              SocialPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateSocialFilter(
        state.socialState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.socialState.filter.sortField == field
              ? !state.socialState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearSocialMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> socialList;
  final BuiltMap<String, SocialEntity> socialMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
