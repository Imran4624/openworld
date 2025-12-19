import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';

class ViewPhotoList implements PersistUI {
  ViewPhotoList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewPhotoList';
  }
}

class ViewPhoto implements PersistUI, PersistPrefs {
  ViewPhoto({
    this.photoId,
    this.force = false,
  });

  final String? photoId;
  final bool force;

  @override
  String toString() {
    return 'ViewPhoto';
  }
}

class EditPhoto implements PersistUI, PersistPrefs {
  EditPhoto({
    required this.photo,
    this.completer,
    this.force = false,
  });

  final PhotoEntity photo;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditPhoto';
  }
}

class UpdatePhoto implements PersistUI {
  UpdatePhoto(this.photo);

  final PhotoEntity photo;

  @override
  String toString() {
    return 'UpdatePhoto';
  }
}

class SetTempPhotoImage implements PersistUI {
  SetTempPhotoImage(this.imageData);

  final Map<String, dynamic> imageData;

  @override
  String toString() {
    return 'SetTempPhotoImage';
  }
}

class LoadPhoto {
  LoadPhoto({this.completer, this.photoId});

  final Completer? completer;
  final String? photoId;

  @override
  String toString() {
    return 'LoadPhoto';
  }
}

class LoadPhotoActivity {
  LoadPhotoActivity({this.completer, this.photoId});

  final Completer? completer;
  final String? photoId;

  @override
  String toString() {
    return 'LoadPhotoActivity';
  }
}

class UpdateLastDocumentAction {
  UpdateLastDocumentAction(this.lastDocument);
  final DocumentSnapshot? lastDocument;

  @override
  String toString() {
    return 'UpdateLastDocumentAction';
  }
}

class LoadPhotoRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadPhotoRequest';
  }
}

class LoadPhotoFailure implements StopLoading {
  LoadPhotoFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadPhotoFailure{error: $error}';
  }
}

class LoadPhotoSuccess implements StopLoading, PersistData {
  LoadPhotoSuccess(this.photo);

  final PhotoEntity photo;

  @override
  String toString() {
    return 'LoadPhotoSuccess';
  }
}

class LoadPhotosRequest implements StartLoading {
  LoadPhotosRequest({this.filter});
  final PhotoFilter? filter;

  @override
  String toString() {
    return 'LoadPhotosRequest';
  }
}

class LoadPhotosFailure implements StopLoading {
  LoadPhotosFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadPhotosFailure{error: $error}';
  }
}

class LoadPhotosSuccess implements StopLoading {
  LoadPhotosSuccess(this.photos, this.isRefresh);

  final BuiltList<PhotoEntity> photos;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadPhotosSuccess';
  }
}

class SavePhotoRequest implements StartSaving {
  SavePhotoRequest({
    this.completer,
    this.photo,
    this.imageData,
  });

  final Completer? completer;
  final PhotoEntity? photo;
  final Map<String, dynamic>? imageData;

  @override
  String toString() {
    return 'SavePhotoRequest';
  }
}

class UploadMultiplePhotosRequest implements StartSaving {
  UploadMultiplePhotosRequest({
    required this.completer,
    required this.category,
    required this.tags,
    required this.imagesData,
    this.eventId,
    this.selectEvent,
    this.existingPhotos = const [],
  });

  final Completer<List<PhotoEntity>> completer;
  final String category;
  final String tags;
  final List<Map<String, dynamic>> imagesData;
  final String? eventId;
  final EventEntity? selectEvent;
  final List<Map<String, dynamic>> existingPhotos;

  @override
  String toString() {
    return 'UploadMultiplePhotosRequest';
  }
}

class UploadMultiplePhotosSuccess implements StopSaving, PersistData {
  UploadMultiplePhotosSuccess(this.photos, {this.isPreview = false});

  final List<PhotoEntity> photos;
  final bool isPreview;

  @override
  String toString() {
    return 'UploadMultiplePhotosSuccess';
  }
}

class UploadMultiplePhotosFailure implements StopSaving {
  UploadMultiplePhotosFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'UploadMultiplePhotosFailure{error: $error}';
  }
}

class SavePhotoSuccess implements StopSaving, PersistData, PersistUI {
  SavePhotoSuccess(this.photo);

  final PhotoEntity photo;

  @override
  String toString() {
    return 'SavePhotoSuccess';
  }
}

class AddPhotoSuccess implements StopSaving, PersistData, PersistUI {
  AddPhotoSuccess(this.photo);

  final PhotoEntity photo;

  @override
  String toString() {
    return 'AddPhotoSuccess';
  }
}

class SavePhotoFailure implements StopSaving {
  SavePhotoFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SavePhotoFailure{error: $error}';
  }
}

class ArchivePhotosRequest implements StartSaving {
  ArchivePhotosRequest(this.completer, this.photoIds);

  final Completer completer;
  final List<String> photoIds;

  @override
  String toString() {
    return 'ArchivePhotosRequest';
  }
}

class ArchivePhotosSuccess implements StopSaving, PersistData {
  ArchivePhotosSuccess(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'ArchivePhotosSuccess';
  }
}

class ArchivePhotosFailure implements StopSaving {
  ArchivePhotosFailure(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'ArchivePhotosFailure{photos: $photos}';
  }
}

class DeletePhotosRequest implements StartSaving {
  DeletePhotosRequest(this.completer, this.photoIds);

  final Completer completer;
  final List<String> photoIds;

  @override
  String toString() {
    return 'DeletePhotosRequest';
  }
}

class PurgePhotosRequest implements StartSaving {
  PurgePhotosRequest(this.completer, this.photoIds);

  final Completer completer;
  final List<String> photoIds;

  @override
  String toString() {
    return 'PurgePhotosRequest';
  }
}

class DeletePhotosSuccess implements StopSaving, PersistData {
  DeletePhotosSuccess(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'DeletePhotosSuccess';
  }
}

class PurgePhotosSuccess implements StopSaving, PersistData {
  PurgePhotosSuccess(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'PurgePhotosSuccess';
  }
}

class DeletePhotosFailure implements StopSaving {
  DeletePhotosFailure(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'DeletePhotosFailure{photos: $photos}';
  }
}

class PurgePhotosFailure implements StopSaving {
  PurgePhotosFailure(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'PurgePhotosFailure{photos: $photos}';
  }
}

class RestorePhotosRequest implements StartSaving {
  RestorePhotosRequest(this.completer, this.photoIds);

  final Completer completer;
  final List<String> photoIds;

  @override
  String toString() {
    return 'RestorePhotosRequest';
  }
}

class RestorePhotosSuccess implements StopSaving, PersistData {
  RestorePhotosSuccess(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'RestorePhotosSuccess';
  }
}

class RestorePhotosFailure implements StopSaving {
  RestorePhotosFailure(this.photos);

  final List<PhotoEntity> photos;

  @override
  String toString() {
    return 'RestorePhotosFailure{photos: $photos}';
  }
}

class FilterPhotos implements PersistUI {
  FilterPhotos(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterPhotos';
  }
}

class SortPhotos implements PersistUI, PersistPrefs {
  SortPhotos(this.field);

  final String field;

  @override
  String toString() {
    return 'SortPhotos';
  }
}

class FilterPhotosByState implements PersistUI {
  FilterPhotosByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterPhotosByState';
  }
}

class StartPhotoMultiselect {
  StartPhotoMultiselect();

  @override
  String toString() {
    return 'StartPhotoMultiselect';
  }
}

class AddToPhotoMultiselect {
  AddToPhotoMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToPhotoMultiselect';
  }
}

class RemoveFromPhotoMultiselect {
  RemoveFromPhotoMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromPhotoMultiselect';
  }
}

class ClearPhotoMultiselect {
  ClearPhotoMultiselect();

  @override
  String toString() {
    return 'ClearPhotoMultiselect';
  }
}

class UpdatePhotoTab implements PersistUI {
  UpdatePhotoTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdatePhotoTab';
  }
}

class UpdatePhotoFilter implements PersistUI {
  UpdatePhotoFilter(this.filter);
  final PhotoFilter filter;

  @override
  String toString() {
    return 'UpdatePhotoFilter';
  }
}

class LoadPhotos {
  LoadPhotos({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final PhotoFilter? filter;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadPhotos';
  }
}

void handlePhotoAction(
    BuildContext context, List<BaseEntity> photos, EntityAction action) {
  if (photos.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final photo = photos.first as PhotoEntity;
  final photoIds = photos.map((photo) => photo.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: photo);
      break;
    case EntityAction.restore:
      store.dispatch(RestorePhotosRequest(
          snackBarCompleter<Null>(localization.restoredPhoto), photoIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchivePhotosRequest(
          snackBarCompleter<Null>(localization.archivedPhoto), photoIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeletePhotosRequest(
          snackBarCompleter<Null>(localization.deletedPhoto), photoIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgePhotosRequest(
          snackBarCompleter<Null>(localization.deletedPhoto), photoIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.photoListState.isInMultiselect()) {
        store.dispatch(StartPhotoMultiselect());
      }

      if (photos.isEmpty) {
        break;
      }

      for (final photo in photos) {
        if (!store.state.photoListState.isSelected(photo.id)) {
          store.dispatch(AddToPhotoMultiselect(entity: photo));
        } else {
          store.dispatch(RemoveFromPhotoMultiselect(entity: photo));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [photo],
      );
      break;
    default:
      logError(' unhandled action $action in photo_actions');
      break;
  }
}
