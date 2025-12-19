import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_state.dart';

EntityUIState photoUIReducer(PhotoUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(photoListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action)
    ..defaultImageData = defaultImageDataReducer(state.defaultImageData, action));
}

Map<String, dynamic>? defaultImageDataReducer(
    Map<String, dynamic>? defaultImageData, dynamic action) {
  if (action is SetTempPhotoImage) {
    return action.imageData;
  } else if (action is SavePhotoSuccess) {
    return null;
  }
  return defaultImageData;
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewPhoto>((completer, action) => true),
  TypedReducer<bool?, ViewPhotoList>((completer, action) => false),
  TypedReducer<bool?, FilterPhotosByState>((completer, action) => false),
  TypedReducer<bool?, FilterPhotos>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdatePhotoTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchivePhotosSuccess>((completer, action) => ''),
  TypedReducer<String?, DeletePhotosSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgePhotosSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.photo ? action.entityId : selectedId),
  TypedReducer<String?, ViewPhoto>(
      (String? selectedId, dynamic action) => action.photoId),
  TypedReducer<String?, AddPhotoSuccess>(
      (String? selectedId, dynamic action) => action.photo.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortPhotos>((selectedId, action) => ''),
  TypedReducer<String?, FilterPhotos>((selectedId, action) => ''),
  TypedReducer<String?, FilterPhotosByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.photo
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<PhotoEntity?>([
  TypedReducer<PhotoEntity?, SavePhotoSuccess>(_updateEditing),
  TypedReducer<PhotoEntity?, AddPhotoSuccess>(_updateEditing),
  TypedReducer<PhotoEntity?, RestorePhotosSuccess>((photos, action) {
    return action.photos[0];
  }),
  TypedReducer<PhotoEntity?, ArchivePhotosSuccess>((photos, action) {
    return action.photos[0];
  }),
  TypedReducer<PhotoEntity?, DeletePhotosSuccess>((photos, action) {
    return action.photos[0];
  }),
  TypedReducer<PhotoEntity?, PurgePhotosSuccess>((photos, action) {
    return action.photos[0];
  }),
  TypedReducer<PhotoEntity?, EditPhoto>(_updateEditing),
  TypedReducer<PhotoEntity?, UpdatePhoto>((photo, action) {
    return action.photo.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<PhotoEntity?, DiscardChanges>(_clearEditing),
]);

PhotoEntity _clearEditing(PhotoEntity? photo, dynamic action) {
  return PhotoEntity();
}

PhotoEntity? _updateEditing(PhotoEntity? photo, dynamic action) {
  return action.photo;
}

final photoListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortPhotos>(_sortPhotos),
  TypedReducer<ListUIState, FilterPhotosByState>(_filterPhotosByState),
  TypedReducer<ListUIState, FilterPhotos>(_filterPhotos),
  TypedReducer<ListUIState, StartPhotoMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToPhotoMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromPhotoMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearPhotoMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewPhotoList>(_viewPhotoList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewPhotoList(ListUIState photoListState, ViewPhotoList action) {
  return photoListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterPhotosByState(
    ListUIState photoListState, FilterPhotosByState action) {
  if (photoListState.stateFilters.contains(action.state)) {
    return photoListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return photoListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterPhotos(ListUIState photoListState, FilterPhotos action) {
  return photoListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : photoListState.filterClearedAt);
}

ListUIState _sortPhotos(ListUIState photoListState, SortPhotos action) {
  return photoListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartPhotoMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToPhotoMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromPhotoMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearPhotoMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final photosReducer = combineReducers<PhotoState>([
  TypedReducer<PhotoState, SavePhotoSuccess>(_updatePhoto),
  TypedReducer<PhotoState, AddPhotoSuccess>(_addPhoto),
  TypedReducer<PhotoState, LoadPhotosSuccess>(_setLoadedPhotos),
  TypedReducer<PhotoState, LoadPhotoSuccess>(_setLoadedPhoto),
  TypedReducer<PhotoState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<PhotoState, UpdatePhotoFilter>(_updatePhotoFilter),
  TypedReducer<PhotoState, UploadMultiplePhotosSuccess>(
      _handleMultiplePhotoUploadSuccess),
  // TypedReducer<PhotoState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<PhotoState, ArchivePhotosSuccess>(_archivePhotoSuccess),
  TypedReducer<PhotoState, DeletePhotosSuccess>(_deletePhotoSuccess),
  TypedReducer<PhotoState, PurgePhotosSuccess>(_purgePhotoSuccess),
  TypedReducer<PhotoState, RestorePhotosSuccess>(_restorePhotoSuccess),
]);

PhotoState _handleMultiplePhotoUploadSuccess(
    PhotoState photoState, UploadMultiplePhotosSuccess action) {
  if (action.isPreview) {
    return photoState;
  }
  return photoState.rebuild((b) {
    for (final photo in action.photos) {
      b.map[photo.id] = photo;
      b.list.insert(0, photo.id);
    }
  });
}

PhotoState _archivePhotoSuccess(
    PhotoState photoState, ArchivePhotosSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return photoState.rebuild((b) {
    for (final photo in action.photos) {
      b.map[photo.id] =
          photoState.map[photo.id]!.rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

PhotoState _updatePhotoFilter(PhotoState photoState, UpdatePhotoFilter action) {
  return photoState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// PhotoState _deletePhotoSuccess(PhotoState photoState, DeletePhotosSuccess action) {
//   return photoState.rebuild((b) {
//     for (final photo in action.photos) {
//       b.map[photo.id] = photo;
//     }
//   });
// }

PhotoState _deletePhotoSuccess(
    PhotoState photoState, DeletePhotosSuccess action) {
  return photoState.rebuild((b) {
    for (final photo in action.photos) {
      b.map[photo.id] =
          photoState.map[photo.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

PhotoState _purgePhotoSuccess(
    PhotoState photoState, PurgePhotosSuccess action) {
  return photoState.rebuild((b) {
    for (final photo in action.photos) {
      b.map.remove(photo.id);
      b.list.remove(photo.id);
    }
  });
}

PhotoState _restorePhotoSuccess(
    PhotoState photoState, RestorePhotosSuccess action) {
  return photoState.rebuild((b) {
    for (final photo in action.photos) {
      b.map[photo.id] = photoState.map[photo.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

PhotoState _addPhoto(PhotoState photoState, AddPhotoSuccess action) {
  return photoState.rebuild((b) => b
    ..map[action.photo.id] = action.photo
    ..list.add(action.photo.id));
}

PhotoState _updatePhoto(PhotoState photoState, SavePhotoSuccess action) {
  return photoState.rebuild((b) => b..map[action.photo.id] = action.photo);
}

PhotoState _updateLastDocument(
    PhotoState photoState, UpdateLastDocumentAction action) {
  return photoState.rebuild((b) => b..lastDocument = action.lastDocument);
}

PhotoState _setLoadedPhoto(PhotoState photoState, LoadPhotoSuccess action) {
  return photoState.rebuild((b) => b..map[action.photo.id] = action.photo);
}

PhotoState _setLoadedPhotos(PhotoState photoState, LoadPhotosSuccess action) {
  return photoState.rebuild((b) {
    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }
    action.photos.forEach((photo) {
      b.map[photo.id] = photo;
      if (!b.list.build().contains(photo.id)) {
        b.list.add(photo.id);
      }
    });
  });
}

// PhotoState _setLoadedCompany(PhotoState photoState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return photoState.loadPhotos(company.photos);
// }
