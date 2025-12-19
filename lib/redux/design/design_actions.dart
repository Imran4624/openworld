// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_actions_dialog.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ViewDesignList implements PersistUI {
  ViewDesignList({
    this.force = false,
  });

  final bool force;

  @override
  String toString() {
    return 'ViewDesignList';
  }
}

class ViewDesign implements PersistUI, PersistPrefs {
  ViewDesign({
    required this.designId,
    this.force = false,
  });

  final String? designId;
  final bool force;

  @override
  String toString() {
    return 'ViewDesign';
  }
}

class EditDesign implements PersistUI, PersistPrefs {
  EditDesign(
      {required this.design,
      this.completer,
      this.cancelCompleter,
      this.force = false});

  final DesignEntity design;
  final Completer? completer;
  final Completer? cancelCompleter;
  final bool force;

  @override
  String toString() {
    return 'EditDesign';
  }
}

class UpdateDesign implements PersistUI {
  UpdateDesign(this.design);

  final DesignEntity design;

  @override
  String toString() {
    return 'UpdateDesign';
  }
}

class LoadDesign {
  LoadDesign({this.completer, this.designId});

  final Completer? completer;
  final String? designId;

  @override
  String toString() {
    return 'LoadDesign';
  }
}

class LoadDesignActivity {
  LoadDesignActivity({this.completer, this.designId});

  final Completer? completer;
  final String? designId;

  @override
  String toString() {
    return 'LoadDesignActivity';
  }
}

class LoadDesigns {
  LoadDesigns({this.completer});

  final Completer? completer;

  @override
  String toString() {
    return 'LoadDesigns';
  }
}

class LoadDesignRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadDesignRequest';
  }
}

class LoadDesignFailure implements StopLoading {
  LoadDesignFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadDesignFailure{error: $error}';
  }
}

class LoadDesignSuccess implements StopLoading, PersistData {
  LoadDesignSuccess(this.design);

  final DesignEntity design;

  @override
  String toString() {
    return 'LoadDesignSuccess';
  }
}

class LoadDesignsRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadDesignsRequest';
  }
}

class LoadDesignsFailure implements StopLoading {
  LoadDesignsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadDesignsFailure{error: $error}';
  }
}

class LoadDesignsSuccess implements StopLoading {
  LoadDesignsSuccess(this.designs);

  final BuiltList<DesignEntity> designs;

  @override
  String toString() {
    return 'LoadDesignsSuccess';
  }
}

class SaveDesignRequest implements StartSaving {
  SaveDesignRequest({this.completer, this.design});

  final Completer? completer;
  final DesignEntity? design;

  @override
  String toString() {
    return 'SaveDesignRequest';
  }
}

class SaveDesignSuccess implements StopSaving, PersistData, PersistUI {
  SaveDesignSuccess(this.design);

  final DesignEntity design;

  @override
  String toString() {
    return 'SaveDesignSuccess';
  }
}

class AddDesignSuccess implements StopSaving, PersistData, PersistUI {
  AddDesignSuccess(this.design);

  final DesignEntity design;

  @override
  String toString() {
    return 'AddDesignSuccess';
  }
}

class SaveDesignFailure implements StopSaving {
  SaveDesignFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveDesignFailure{error: $error}';
  }
}

class ArchiveDesignsRequest implements StartSaving {
  ArchiveDesignsRequest(this.completer, this.designIds);

  final Completer completer;
  final List<String> designIds;

  @override
  String toString() {
    return 'ArchiveDesignsRequest';
  }
}

class ArchiveDesignsSuccess implements StopSaving, PersistData {
  ArchiveDesignsSuccess(this.designs);

  final List<DesignEntity> designs;

  @override
  String toString() {
    return 'ArchiveDesignsSuccess';
  }
}

class ArchiveDesignsFailure implements StopSaving {
  ArchiveDesignsFailure(this.designs);

  final List<DesignEntity?> designs;

  @override
  String toString() {
    return 'ArchiveDesignsFailure{designs: $designs}';
  }
}

class DeleteDesignsRequest implements StartSaving {
  DeleteDesignsRequest(this.completer, this.designIds);

  final Completer completer;
  final List<String> designIds;

  @override
  String toString() {
    return 'DeleteDesignsRequest';
  }
}

class DeleteDesignsSuccess implements StopSaving, PersistData {
  DeleteDesignsSuccess(this.designs);

  final List<DesignEntity> designs;

  @override
  String toString() {
    return 'DeleteDesignsSuccess';
  }
}

class DeleteDesignsFailure implements StopSaving {
  DeleteDesignsFailure(this.designs);

  final List<DesignEntity?> designs;

  @override
  String toString() {
    return 'DeleteDesignsFailure{designs: $designs}';
  }
}

class RestoreDesignsRequest implements StartSaving {
  RestoreDesignsRequest(this.completer, this.designIds);

  final Completer completer;
  final List<String> designIds;

  @override
  String toString() {
    return 'RestoreDesignsRequest';
  }
}

class RestoreDesignsSuccess implements StopSaving, PersistData {
  RestoreDesignsSuccess(this.designs);

  final List<DesignEntity> designs;

  @override
  String toString() {
    return 'RestoreDesignsSuccess';
  }
}

class RestoreDesignsFailure implements StopSaving {
  RestoreDesignsFailure(this.designs);

  final List<DesignEntity?> designs;

  @override
  String toString() {
    return 'RestoreDesignsFailure{designs: $designs}';
  }
}

class FilterDesigns implements PersistUI {
  FilterDesigns(this.filter);

  final String? filter;

  @override
  String toString() {
    return 'FilterDesigns';
  }
}

class SortDesigns implements PersistUI, PersistPrefs {
  SortDesigns(this.field);

  final String field;

  @override
  String toString() {
    return 'SortDesigns';
  }
}

class FilterDesignsByState implements PersistUI {
  FilterDesignsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterDesignsByState';
  }
}

class FilterDesignsByCustom1 implements PersistUI {
  FilterDesignsByCustom1(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterDesignsByCustom1';
  }
}

class FilterDesignsByCustom2 implements PersistUI {
  FilterDesignsByCustom2(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterDesignsByCustom2';
  }
}

class FilterDesignsByCustom3 implements PersistUI {
  FilterDesignsByCustom3(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterDesignsByCustom3';
  }
}

class FilterDesignsByCustom4 implements PersistUI {
  FilterDesignsByCustom4(this.value);

  final String value;

  @override
  String toString() {
    return 'FilterDesignsByCustom4';
  }
}

void handleDesignAction(
    BuildContext? context, List<BaseEntity> designs, EntityAction? action) {
  if (designs.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context!);
  final localization = AppLocalization.of(context);
  final design = designs.first as DesignEntity;
  final designIds = designs.map((design) => design.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: design);
      break;
    case EntityAction.clone:
      createEntity(entity: design.clone);
      break;
    case EntityAction.restore:
      final message = designIds.length > 1
          ? localization!.restoredDesigns
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', designIds.length.toString())
          : localization!.restoredDesign;
      store.dispatch(
          RestoreDesignsRequest(snackBarCompleter<Null>(message), designIds));
      break;
    case EntityAction.archive:
      final message = designIds.length > 1
          ? localization!.archivedDesigns
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', designIds.length.toString())
          : localization!.archivedDesign;
      store.dispatch(
          ArchiveDesignsRequest(snackBarCompleter<Null>(message), designIds));
      break;
    case EntityAction.delete:
      final message = designIds.length > 1
          ? localization!.deletedDesigns
              .replaceFirst(':value', ':count')
              .replaceFirst(':count', designIds.length.toString())
          : localization!.deletedDesign;
      store.dispatch(
          DeleteDesignsRequest(snackBarCompleter<Null>(message), designIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.designListState.isInMultiselect()) {
        store.dispatch(StartDesignMultiselect());
      }

      if (designs.isEmpty) {
        break;
      }

      for (final design in designs) {
        if (!store.state.designListState.isSelected(design.id)) {
          store.dispatch(AddToDesignMultiselect(entity: design));
        } else {
          store.dispatch(RemoveFromDesignMultiselect(entity: design));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [design],
      );
      break;
  }
}

class StartDesignMultiselect {
  StartDesignMultiselect();

  @override
  String toString() {
    return 'StartDesignMultiselect';
  }
}

class AddToDesignMultiselect {
  AddToDesignMultiselect({required this.entity});

  final BaseEntity? entity;

  @override
  String toString() {
    return 'AddToDesignMultiselect';
  }
}

class RemoveFromDesignMultiselect {
  RemoveFromDesignMultiselect({required this.entity});

  final BaseEntity? entity;

  @override
  String toString() {
    return 'RemoveFromDesignMultiselect';
  }
}

class ClearDesignMultiselect {
  ClearDesignMultiselect();

  @override
  String toString() {
    return 'ClearDesignMultiselect';
  }
}
