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

class ViewSocialList implements PersistUI {
  ViewSocialList({this.force = false, this.page = 0});

  final bool force;
  final int page;

  @override
  String toString() {
    return 'ViewSocialList';
  }
}

class ViewSocial implements PersistUI, PersistPrefs {
  ViewSocial({
    this.socialId,
    this.force = false,
  });

  final String? socialId;
  final bool force;

  @override
  String toString() {
    return 'ViewSocial';
  }
}

class EditSocial implements PersistUI, PersistPrefs {
  EditSocial({
    required this.social,
    this.completer,
    this.force = false,
  });

  final SocialEntity social;
  final Completer? completer;
  final bool force;

  @override
  String toString() {
    return 'EditSocial';
  }
}

class UpdateSocial implements PersistUI {
  UpdateSocial(this.social);

  final SocialEntity social;

  @override
  String toString() {
    return 'UpdateSocial';
  }
}

class LoadSocial {
  LoadSocial({this.completer, this.socialId});

  final Completer? completer;
  final String? socialId;

  @override
  String toString() {
    return 'LoadSocial';
  }
}

class LoadSocialActivity {
  LoadSocialActivity({this.completer, this.socialId});

  final Completer? completer;
  final String? socialId;

  @override
  String toString() {
    return 'LoadSocialActivity';
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

class LoadSocialRequest implements StartLoading {
  @override
  String toString() {
    return 'LoadSocialRequest';
  }
}

class LoadSocialFailure implements StopLoading {
  LoadSocialFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadSocialFailure{error: $error}';
  }
}

class LoadSocialSuccess implements StopLoading, PersistData {
  LoadSocialSuccess(this.social);

  final SocialEntity social;

  @override
  String toString() {
    return 'LoadSocialSuccess';
  }
}

// class LoadSocialsRequest implements StartLoading {}

class LoadSocialsFailure implements StopLoading {
  LoadSocialsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadSocialsFailure{error: $error}';
  }
}

class LoadSocialsSuccess implements StopLoading {
  LoadSocialsSuccess(this.socials, this.isRefresh);

  final BuiltList<SocialEntity> socials;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadSocialsSuccess';
  }
}

class SaveSocialRequest implements StartSaving {
  SaveSocialRequest({this.completer, this.social});

  final Completer? completer;
  final SocialEntity? social;

  @override
  String toString() {
    return 'SaveSocialRequest';
  }
}

class SaveSocialSuccess implements StopSaving, PersistData, PersistUI {
  SaveSocialSuccess(this.social);

  final SocialEntity social;

  @override
  String toString() {
    return 'SaveSocialSuccess';
  }
}

class AddSocialSuccess implements StopSaving, PersistData, PersistUI {
  AddSocialSuccess(this.social);

  final SocialEntity social;

  @override
  String toString() {
    return 'AddSocialSuccess';
  }
}

class SaveSocialFailure implements StopSaving {
  SaveSocialFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveSocialFailure{error: $error}';
  }
}

class ArchiveSocialsRequest implements StartSaving {
  ArchiveSocialsRequest(this.completer, this.socialIds);

  final Completer completer;
  final List<String> socialIds;

  @override
  String toString() {
    return 'ArchiveSocialsRequest';
  }
}

class ArchiveSocialsSuccess implements StopSaving, PersistData {
  ArchiveSocialsSuccess(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'ArchiveSocialsSuccess';
  }
}

class ArchiveSocialsFailure implements StopSaving {
  ArchiveSocialsFailure(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'ArchiveSocialsFailure{socials: $socials}';
  }
}

class DeleteSocialsRequest implements StartSaving {
  DeleteSocialsRequest(this.completer, this.socialIds);

  final Completer completer;
  final List<String> socialIds;

  @override
  String toString() {
    return 'DeleteSocialsRequest';
  }
}

class PurgeSocialsRequest implements StartSaving {
  PurgeSocialsRequest(this.completer, this.socialIds);

  final Completer completer;
  final List<String> socialIds;

  @override
  String toString() {
    return 'PurgeSocialsRequest';
  }
}

class DeleteSocialsSuccess implements StopSaving, PersistData {
  DeleteSocialsSuccess(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'DeleteSocialsSuccess';
  }
}

class PurgeSocialsSuccess implements StopSaving, PersistData {
  PurgeSocialsSuccess(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'PurgeSocialsSuccess';
  }
}

class DeleteSocialsFailure implements StopSaving {
  DeleteSocialsFailure(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'DeleteSocialsFailure{socials: $socials}';
  }
}

class PurgeSocialsFailure implements StopSaving {
  PurgeSocialsFailure(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'PurgeSocialsFailure{socials: $socials}';
  }
}

class RestoreSocialsRequest implements StartSaving {
  RestoreSocialsRequest(this.completer, this.socialIds);

  final Completer completer;
  final List<String> socialIds;

  @override
  String toString() {
    return 'RestoreSocialsRequest';
  }
}

class RestoreSocialsSuccess implements StopSaving, PersistData {
  RestoreSocialsSuccess(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'RestoreSocialsSuccess';
  }
}

class RestoreSocialsFailure implements StopSaving {
  RestoreSocialsFailure(this.socials);

  final List<SocialEntity> socials;

  @override
  String toString() {
    return 'RestoreSocialsFailure{socials: $socials}';
  }
}

class FilterSocials implements PersistUI {
  FilterSocials(this.filter);

  final String filter;

  @override
  String toString() {
    return 'FilterSocials';
  }
}

class SortSocials implements PersistUI, PersistPrefs {
  SortSocials(this.field);

  final String field;

  @override
  String toString() {
    return 'SortSocials';
  }
}

class FilterSocialsByState implements PersistUI {
  FilterSocialsByState(this.state);

  final EntityState state;

  @override
  String toString() {
    return 'FilterSocialsByState';
  }
}

// class FilterSocialsByCustom1 implements PersistUI {
//   FilterSocialsByCustom1(this.value);

//   final String value;
// }

// class FilterSocialsByCustom2 implements PersistUI {
//   FilterSocialsByCustom2(this.value);

//   final String value;
// }

// class FilterSocialsByCustom3 implements PersistUI {
//   FilterSocialsByCustom3(this.value);

//   final String value;
// }

// class FilterSocialsByCustom4 implements PersistUI {
//   FilterSocialsByCustom4(this.value);

//   final String value;
// }

class StartSocialMultiselect {
  StartSocialMultiselect();

  @override
  String toString() {
    return 'StartSocialMultiselect';
  }
}

class AddToSocialMultiselect {
  AddToSocialMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'AddToSocialMultiselect';
  }
}

class RemoveFromSocialMultiselect {
  RemoveFromSocialMultiselect({required this.entity});

  final BaseEntity entity;

  @override
  String toString() {
    return 'RemoveFromSocialMultiselect';
  }
}

class ClearSocialMultiselect {
  ClearSocialMultiselect();

  @override
  String toString() {
    return 'ClearSocialMultiselect';
  }
}

class UpdateSocialTab implements PersistUI {
  UpdateSocialTab({this.tabIndex});

  final int? tabIndex;

  @override
  String toString() {
    return 'UpdateSocialTab';
  }
}

class UpdateSocialFilter implements PersistUI {
  UpdateSocialFilter(this.filter);
  final SocialFilter filter;

  @override
  String toString() {
    return 'UpdateSocialFilter';
  }
}

class LoadSocials {
  LoadSocials({
    this.completer,
    this.filter,
    this.page = 0,
    this.isRefresh = false,
  });

  final Completer? completer;
  final SocialFilter? filter;
  final int page;
  final bool isRefresh;

  @override
  String toString() {
    return 'LoadSocials';
  }
}

class LoadSocialsRequest implements StartLoading {
  LoadSocialsRequest({this.filter});
  final SocialFilter? filter;

  @override
  String toString() {
    return 'LoadSocialsRequest';
  }
}

void handleSocialAction(
    BuildContext context, List<BaseEntity> socials, EntityAction action) {
  if (socials.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context)!;
  final social = socials.first as SocialEntity;
  final socialIds = socials.map((social) => social.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(entity: social);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreSocialsRequest(
          snackBarCompleter<Null>(localization.restoredSocial), socialIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveSocialsRequest(
          snackBarCompleter<Null>(localization.archivedSocial), socialIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteSocialsRequest(
          snackBarCompleter<Null>(localization.deletedSocial), socialIds));
      break;
    case EntityAction.purge:
      store.dispatch(PurgeSocialsRequest(
          snackBarCompleter<Null>(localization.deletedSocial), socialIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.socialListState.isInMultiselect()) {
        store.dispatch(StartSocialMultiselect());
      }

      if (socials.isEmpty) {
        break;
      }

      for (final social in socials) {
        if (!store.state.socialListState.isSelected(social.id)) {
          store.dispatch(AddToSocialMultiselect(entity: social));
        } else {
          store.dispatch(RemoveFromSocialMultiselect(entity: social));
        }
      }
      break;
    case EntityAction.more:
      showEntityActionsDialog(
        entities: [social],
      );
      break;
    default:
      logError('unhandled action $action in social_actions');
      break;
  }
}
