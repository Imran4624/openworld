import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/photo/photo_selectors.dart';
import 'package:redux/redux.dart';

import 'photo_screen.dart';

class PhotoScreenBuilder extends StatelessWidget {
  const PhotoScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PhotoScreenVM>(
      converter: PhotoScreenVM.fromStore,
      builder: (context, vm) {
        return PhotoScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class PhotoScreenVM {
  PhotoScreenVM({
    required this.isInMultiselect,
    required this.photoList,
    required this.userCompany,
    required this.onEntityAction,
    required this.photoMap,
    this.selectedEvent,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> photoList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, PhotoEntity> photoMap;
  final EventEntity? selectedEvent;

  static PhotoScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return PhotoScreenVM(
      photoMap: state.photoState.map,
      photoList: memoizedFilteredPhotoList(
        state.getUISelection(EntityType.photo),
        state.photoState.map,
        state.photoState.list,
        state.photoListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.photoListState.isInMultiselect(),
      selectedEvent: _getSelectedEvent(state),
      onEntityAction: (BuildContext context, List<BaseEntity> photos,
              EntityAction action) =>
          handlePhotoAction(context, photos, action),
    );
  }

  static EventEntity? _getSelectedEvent(AppState state) {
    final selectionState = state.getUISelection(EntityType.photo);
    final filterEntityType = selectionState.filterEntityType;
    
    if (filterEntityType == EntityType.event && selectionState.filterEntityId != null) {
      return state.eventState.map[selectionState.filterEntityId] ?? 
             EventEntity(id: selectionState.filterEntityId);
    }
    
    if (state.uiState.currentRoute.contains('/event/view')) {
      final selectedEventId = state.eventUIState.selectedId;
      if (selectedEventId != null && selectedEventId.isNotEmpty) {
        return state.eventState.map[selectedEventId] ?? 
               EventEntity(id: selectedEventId);
      }
    }
    
    return null;
  }
}
