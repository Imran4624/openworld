import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart'
    as eventActions;
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/photo/photo_screen.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:flutter_boilerplate/ui/photo/view/photo_view_vm.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/photo_repository.dart';

List<Middleware<AppState>> createStorePhotosMiddleware([
  PhotoRepository repository = const PhotoRepository(),
]) {
  final viewPhotoList = _viewPhotoList();
  final viewPhoto = _viewPhoto();
  final editPhoto = _editPhoto();
  final loadPhotos = _loadPhotos(repository);
  final loadPhoto = _loadPhoto(repository);
  final savePhoto = _savePhoto(repository);
  final uploadMultiplePhotos = _uploadMultiplePhotos(repository);
  final archivePhoto = _archivePhoto(repository);
  final deletePhoto = _deletePhoto(repository);
  final purgePhoto = _purgePhoto(repository);
  final restorePhoto = _restorePhoto(repository);
  final updateFilter = _updateFilter(repository);

  return [
    TypedMiddleware<AppState, ViewPhotoList>(viewPhotoList),
    TypedMiddleware<AppState, ViewPhoto>(viewPhoto),
    TypedMiddleware<AppState, EditPhoto>(editPhoto),
    TypedMiddleware<AppState, LoadPhotos>(loadPhotos),
    TypedMiddleware<AppState, LoadPhoto>(loadPhoto),
    TypedMiddleware<AppState, SavePhotoRequest>(savePhoto),
    TypedMiddleware<AppState, UploadMultiplePhotosRequest>(
        uploadMultiplePhotos),
    TypedMiddleware<AppState, ArchivePhotosRequest>(archivePhoto),
    TypedMiddleware<AppState, DeletePhotosRequest>(deletePhoto),
    TypedMiddleware<AppState, PurgePhotosRequest>(purgePhoto),
    TypedMiddleware<AppState, RestorePhotosRequest>(restorePhoto),
    TypedMiddleware<AppState, UpdatePhotoFilter>(updateFilter),
  ];
}

Middleware<AppState> _editPhoto() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditPhoto;

    next(action);

    store.dispatch(UpdateCurrentRoute(PhotoEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(PhotoEditScreen.route);
    }
  };
}

Middleware<AppState> _viewPhoto() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewPhoto;

    next(action);

    // Pass the full URL with photo ID parameter to UpdateCurrentRoute
    final fullRoute =
        ProjectConfig.getEntityDetailUrl(EntityType.photo, action.photoId!);

    store.dispatch(UpdateCurrentRoute(fullRoute));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(PhotoViewScreen.route);
    }
  };
}

Middleware<AppState> _viewPhotoList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewPhotoList;

    next(action);

    // if (store.state.staticState.isStale) {
    //   store.dispatch(RefreshData());
    // }

    store.dispatch(UpdateCurrentRoute(PhotoScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          PhotoScreen.route, (Route<dynamic> route) => false);
    }
    store.dispatch(UpdatePhotoFilter(
      store.state.photoState.filter.rebuild((b) => b..searchTerm = ''),
    ));
  };
}

Middleware<AppState> _archivePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchivePhotosRequest;
    final prevPhotos = action.photoIds
        .map((id) => store.state.photoState.map[id])
        .whereType<PhotoEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.photoIds, EntityAction.archive)
        .then((List<PhotoEntity> photos) {
      store.dispatch(ArchivePhotosSuccess(photos));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(ArchivePhotosFailure(prevPhotos));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deletePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeletePhotosRequest;
    final prevPhotos = action.photoIds
        .map((id) => store.state.photoState.map[id])
        .whereType<PhotoEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.photoIds, EntityAction.delete)
        .then((List<PhotoEntity> photos) {
      store.dispatch(DeletePhotosSuccess(photos));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(DeletePhotosFailure(prevPhotos));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgePhotosRequest;
    final prevPhotos = action.photoIds
        .map((id) => store.state.photoState.map[id])
        .whereType<PhotoEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.photoIds, EntityAction.purge)
        .then((List<PhotoEntity> photos) {
      store.dispatch(PurgePhotosSuccess(photos));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(PurgePhotosFailure(prevPhotos));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restorePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestorePhotosRequest;
    final prevPhotos = action.photoIds
        .map((id) => store.state.photoState.map[id])
        .whereType<PhotoEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.photoIds, EntityAction.restore)
        .then((List<PhotoEntity> photos) {
      store.dispatch(RestorePhotosSuccess(photos));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(RestorePhotosFailure(prevPhotos));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _savePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SavePhotoRequest;
    final state = store.state;
    final selectionState = state.getUISelection(EntityType.photo);
    final filterEntityType = selectionState.filterEntityType;
    var selectedEvent = EventEntity();
    if (filterEntityType == EntityType.event) {
      selectedEvent = state.eventState.map[selectionState.filterEntityId] ??
          EventEntity(id: selectionState.filterEntityId);
    }
    final updatedPhoto = action.photo!.rebuild((b) => b
      ..createdUserId = getLoggedInUserId(store)
      ..category = selectedEvent.name.isNotEmpty ? selectedEvent.name : '');
    repository
        .saveData(store.state.credentials, updatedPhoto, action.imageData,
            currentUserEmail: store.state.authState.email,
            selectedEvent: selectedEvent)
        .then((PhotoEntity photo) {
      if (action.photo!.isNew) {
        store.dispatch(AddPhotoSuccess(photo));
      } else {
        store.dispatch(SavePhotoSuccess(photo));
      }

      action.completer?.complete(photo);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SavePhotoFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _uploadMultiplePhotos(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UploadMultiplePhotosRequest;
    final state = store.state;
    final selectionState = state.getUISelection(EntityType.photo);
    final filterEntityType = selectionState.filterEntityType;
    var selectedEvent = EventEntity();
    if (filterEntityType == EntityType.event && action.selectEvent == null) {
      selectedEvent = state.eventState.map[selectionState.filterEntityId] ??
          EventEntity(id: selectionState.filterEntityId);
    } else if (action.selectEvent != null) {
      selectedEvent = action.selectEvent!;
    }

    final isGuestOriginator =
        store.state.authState.originator == OriginatorType.guest.value &&
            selectedEvent.createdUserId != getLoggedInUserId(store);

    repository
        .uploadMultiplePhotos(
            store.state.credentials,
            selectedEvent.name.isNotEmpty
                ? selectedEvent.name
                : action.category,
            action.eventId ?? selectedEvent.id,
            action.tags,
            getLoggedInUserId(store),
            action.imagesData,
            existingPhotos: action.existingPhotos,
            isGuestOriginator: isGuestOriginator,
            currentUserEmail: store.state.authState.email,
            selectedEvent: selectedEvent)
        .then((List<PhotoEntity> photos) {
      if (photos.isEmpty) {
        action.completer.completeError(
            AppLocalization.of(navigatorKey.currentContext!)!
                .anErrorOccurredTryAgain);

        store.dispatch(UploadMultiplePhotosFailure(
            AppLocalization.of(navigatorKey.currentContext!)!
                .anErrorOccurredTryAgain));
      } else {
        final isPreview = selectedEvent.id.contains('_isPreview');

        store.dispatch(
            UploadMultiplePhotosSuccess(photos, isPreview: isPreview));
        action.completer.complete(photos);
        if (selectedEvent.id.isNotEmpty) {
          final Images? images = selectedEvent.images;
          final hasHeader = images != null && images.header.isNotEmpty;
          if (!hasHeader && photos.isNotEmpty) {
            final updatedImages = (images ?? Images((b) {}))
                .rebuild((b) => b..header = photos.first.url);
            final updatedEvent =
                selectedEvent.rebuild((b) => b..images.replace(updatedImages));
            store.dispatch(eventActions.SaveEventRequest(
                event: updatedEvent, isPreview: isPreview));
          }
        }
      }
    }).catchError((Object error) {
      logError('upload photos error $error');
      store.dispatch(UploadMultiplePhotosFailure(error));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadPhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadPhoto;

    store.dispatch(LoadPhotoRequest());
    repository.loadItem(store.state.credentials, action.photoId!).then((photo) {
      store.dispatch(LoadPhotoSuccess(photo));
      action.completer?.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadPhotoFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadPhotos(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadPhotos;
    final state = store.state;
    final stateFilters = state.photoListState.stateFilters;
    final currentFilter = action.filter ?? state.photoState.filter;
    final selectionState = state.getUISelection(EntityType.photo);
    final filterEntityType = selectionState.filterEntityType;
    var selectedEvent = EventEntity();
    if (filterEntityType == EntityType.event) {
      selectedEvent = state.eventState.map[selectionState.filterEntityId] ??
          EventEntity(id: selectionState.filterEntityId);
    }

    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first;
      } else {
        b.stateFilter = EntityState.active;
      }
    });

    store.dispatch(LoadPhotosRequest(filter: filter));

    var lastDocument = state.photoState.lastDocument;
    if (action.isRefresh) {
      lastDocument = null;
      store.dispatch(UpdateLastDocumentAction(null));
    }

    repository
        .loadListWithPagination(
      lastDocument: lastDocument,
      limit: filter.limit,
      filter: filter,
      selectedEvent: selectedEvent,
      selectedEventId: selectedEvent.id,
      currentUserId: getLoggedInUserId(store),
    )
        .then((response) {
      final photos = response['photos'] as BuiltList<PhotoEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadPhotosSuccess(photos, action.isRefresh));
      if (photos.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }

      action.completer?.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadPhotosFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(PhotoRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdatePhotoFilter;

    next(action);

    store.dispatch(LoadPhotos(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}
