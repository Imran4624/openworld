import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/profile_operations/empty_state_widget.dart';
import 'package:flutter_boilerplate/ui/app/profile_operations/profile_operation_tabs.dart';
import 'package:flutter_boilerplate/ui/app/tables/profile_list.dart';
import 'package:flutter_boilerplate/ui/profile/profile_presenter.dart';
import 'package:flutter_boilerplate/ui/profile/profile_list_item.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ProfileOperationListBuilder extends StatefulWidget {
  const ProfileOperationListBuilder({super.key});

  @override
  _ProfileOperationListBuilderState createState() =>
      _ProfileOperationListBuilderState();
}

class _ProfileOperationListBuilderState
    extends State<ProfileOperationListBuilder> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      final activeTab = store.state.profileOperationState.activeTab;
      store.dispatch(LoadProfileOperations(
        isRefresh: true,
        tabType: activeTab,
      ));
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    if (state.isLoading) return;

    final currentTabProfiles =
        state.profileOperationState.getActiveTabProfileList();
    if (currentTabProfiles.isEmpty) return;

    setState(() {
      _isLoadingMore = true;
    });

    final completer = Completer<void>();
    store.dispatch(LoadProfileOperations(
      completer: completer,
      tabType: state.profileOperationState.activeTab,
      isRefresh: false,
    ));

    completer.future.then((_) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
      printL('Error loading more data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileOperationListVM>(
      converter: ProfileOperationListVM.fromStore,
      builder: (context, viewModel) {
        return Column(
          children: [
            ProfileOperationTabs(
              activeTab: viewModel.activeTab,
              onTabChanged: viewModel.onTabChanged,
            ),
            Expanded(
              child: viewModel.profileList.isEmpty
                  ? _buildEmptyState(context, viewModel.activeTab)
                  : ProfileList(
                      entityType: EntityType.profileOperation,
                      presenter: ProfileOperationPresenter(),
                      isProfileOperation: true,
                      state: viewModel.state,
                      entityList: viewModel.profileList,
                      tableColumns: viewModel.tableColumns,
                      onRefreshed: viewModel.onRefreshed,
                      onSortColumn: viewModel.onSortColumn,
                      viewType: ViewType.grid,
                      onClearMultiselect: viewModel.onClearMultiselect,
                      itemBuilder: (BuildContext context, index) {
                        if (index >= viewModel.profileList.length) {
                          return SizedBox.shrink();
                        }

                        final profileId = viewModel.profileList[index];
                        if (!viewModel.profileMap.containsKey(profileId)) {
                          return SizedBox.shrink();
                        }

                        final profile = viewModel.profileMap[profileId]!;
                        return ProfileListItem(
                          user: viewModel.state.user,
                          filter: viewModel.filter,
                          profile: profile.profileEntity!,
                          isChecked: false,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String activeTab) {
    String message;
    IconData icon;
    String? actionText;
    Function()? onActionPressed;

    switch (activeTab) {
      case 'I Liked':
        message = 'You haven\'t liked any profiles yet';
        icon = Icons.favorite_border;
        actionText =
             'Explore Profiles';
        onActionPressed = () {
          viewEntitiesByType(entityType: EntityType.profile);
        };
        break;
      case 'Liked Me':
        message =
            'No one has liked your profile yet.\nKeep improving your profile to get more likes!';
        icon = Icons.person_outline;
        break;
      case 'Matches':
        message =
            'You don\'t have any matches yet.\nStart liking profiles to get matches!';
        icon = Icons.people_outline;
        actionText =
           'Start Matching';
        onActionPressed = () {
          viewEntitiesByType(entityType: EntityType.profile);
        };
        break;
      case 'Passes':
        message = 'You haven\'t passed on any profiles yet';
        icon = Icons.not_interested;
        break;
      case 'Comments':
        message = 'No comments yet';
        icon = Icons.chat_bubble_outline;
        break;
      default:
        message = 'No records found';
        icon = Icons.info_outline;
    }

    return EmptyStateWidget(
      message: message,
      icon: icon,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }
}

class ProfileOperationListVM {
  ProfileOperationListVM({
    required this.state,
    required this.userCompany,
    required this.operationList,
    required this.operationMap,
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
    required this.activeTab,
    required this.onTabChanged,
  });

  static ProfileOperationListVM fromStore(Store<AppState> store) {
    final state = store.state;
    final profileOperationState = state.profileOperationState;

    Future<void> handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();
      final activeTab = state.profileOperationState.activeTab;

      store.dispatch(LoadProfileOperations(
          completer: completer,
          filter: store.state.profileOperationState.filter,
          tabType: activeTab,
          isRefresh: false));

      return completer.future;
    }

    final profileList =
        profileOperationState.getActiveTabProfileList().toList();
    final profileMap = profileOperationState.getActiveTabProfileMap();
    return ProfileOperationListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.profileOperationListState,
      operationList: memoizedFilteredProfileOperationList(
        state.getUISelection(EntityType.profileOperation),
        state.profileOperationState.map,
        state.profileOperationState.list,
        state.profileOperationListState,
      ),
      operationMap: state.profileOperationState.map,
      profileList: profileList,
      profileMap: profileMap,
      isLoading: state.profileOperationState.isLoading,
      filter: state.profileOperationState.filter.searchTerm,
      activeTab: state.profileOperationState.activeTab,
      onTabChanged: (String tab) {
        store.dispatch(UpdateProfileOperationActiveTab(tab));
        if (state.prefState.isDesktop && state.prefState.isPreviewVisible) {
          store.dispatch(TogglePreviewSidebar());
        }
      },
      onEntityAction: (BuildContext context, List<BaseEntity> profileOperations,
              EntityAction action) =>
          handleProfileOperationAction(context, profileOperations, action),
      onRefreshed: (context) => handleRefresh(context),
      tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.profile) ??
              ProfilePresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdateProfileOperationFilter(
        state.profileOperationState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending =
              state.profileOperationState.filter.sortField == field
                  ? !state.profileOperationState.filter.sortAscending
                  : true),
      )),
      onClearMultiselect: () =>
          store.dispatch(ClearProfileOperationMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> operationList;
  final BuiltMap<String, ProfileOperationEntity> operationMap;
  final List<String> profileList;
  final BuiltMap<String, ProfileOperationEntity> profileMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
  final String activeTab;
  final Function(String) onTabChanged;
}
