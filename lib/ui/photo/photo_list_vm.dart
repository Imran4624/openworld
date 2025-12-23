import 'dart:async';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/tables/improvedEntityList.dart';
import 'package:flutter_boilerplate/ui/photo/photo_grid_item.dart';
import 'package:flutter_boilerplate/ui/photo/photo_presenter.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_selectors.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';

class PhotoListBuilder extends StatelessWidget {
  const PhotoListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PhotoListVM>(
      converter: PhotoListVM.fromStore,
      builder: (context, viewModel) {
        return ImprovedEntityList(
          entityType: EntityType.photo,
          presenter: PhotoPresenter(),
          state: viewModel.state,
          entityList: viewModel.photoList,
          tableColumns: viewModel.tableColumns,
          onRefreshed: viewModel.onRefreshed,
          onSortColumn: viewModel.onSortColumn,
          viewType: ViewType.grid,
          onClearMultiselect: viewModel.onClearMultiselect,
          itemBuilder: (BuildContext context, index) {
            final photoId = viewModel.photoList[index];
            final photo = viewModel.photoMap[photoId]!;
            return PhotoGridItem(
              photo: photo,
            );
          },
        );
      },
    );
  }
}

class PhotoListVM {
  PhotoListVM({
    required this.state,
    required this.userCompany,
    required this.photoList,
    required this.photoMap,
    required this.filter,
    required this.isLoading,
    required this.listState,
    required this.onRefreshed,
    required this.onEntityAction,
    required this.tableColumns,
    required this.onSortColumn,
    required this.onClearMultiselect,
  });

  static PhotoListVM fromStore(Store<AppState> store) {
    Future<void> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<void>.value();
      }

      final completer = Completer<void>();

      store.dispatch(LoadPhotos(
          completer: completer, filter: store.state.photoState.filter));

      return completer.future;
    }

    final state = store.state;

    return PhotoListVM(
      state: state,
      userCompany: state.userCompany,
      listState: state.photoListState,
      photoList: memoizedFilteredPhotoList(
        state.getUISelection(EntityType.photo),
        state.photoState.map,
        state.photoState.list,
        state.photoListState,
      ),
      photoMap: state.photoState.map,
      isLoading: state.isLoading,
      filter: state.photoState.filter.searchTerm,
      onEntityAction: (BuildContext context, List<BaseEntity> photos,
              EntityAction action) =>
          handlePhotoAction(context, photos, action),
      onRefreshed: (context) => _handleRefresh(context),
        tableColumns:
          state.userCompany.settings.getTableColumns(EntityType.photo) ??
              PhotoPresenter.getDefaultTableFields(state.userCompany),
      onSortColumn: (field) => store.dispatch(UpdatePhotoFilter(
        state.photoState.filter.rebuild((b) => b
          ..sortField = field
          ..sortAscending = state.photoState.filter.sortField == field
              ? !state.photoState.filter.sortAscending
              : true),
      )),
      onClearMultiselect: () => store.dispatch(ClearPhotoMultiselect()),
    );
  }

  final AppState state;
  final UserCompanyEntity userCompany;
  final List<String> photoList;
  final BuiltMap<String, PhotoEntity> photoMap;
  final ListUIState listState;
  final String? filter;
  final bool isLoading;
  final Function(BuildContext) onRefreshed;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final List<String> tableColumns;
  final Function(String) onSortColumn;
  final Function onClearMultiselect;
}
