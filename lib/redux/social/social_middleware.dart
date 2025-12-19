import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/social/social_screen.dart';
import 'package:flutter_boilerplate/ui/social/edit/social_edit_vm.dart';
import 'package:flutter_boilerplate/ui/social/view/social_view_vm.dart';
import 'package:flutter_boilerplate/redux/social/social_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/repositories/social_repository.dart';

List<Middleware<AppState>> createStoreSocialsMiddleware([
  SocialRepository repository = const SocialRepository(),
]) {
  final viewSocialList = _viewSocialList();
  final viewSocial = _viewSocial();
  final editSocial = _editSocial();
  final loadSocials = _loadSocials(repository);
  final loadSocial = _loadSocial(repository);
  final saveSocial = _saveSocial(repository);
  final archiveSocial = _archiveSocial(repository);
  final deleteSocial = _deleteSocial(repository);
  final purgeSocial = _purgeSocial(repository);
  final restoreSocial = _restoreSocial(repository);
  final updateFilter = _updateFilter(repository);

  return [
    TypedMiddleware<AppState, ViewSocialList>(viewSocialList),
    TypedMiddleware<AppState, ViewSocial>(viewSocial),
    TypedMiddleware<AppState, EditSocial>(editSocial),
    TypedMiddleware<AppState, LoadSocials>(loadSocials),
    TypedMiddleware<AppState, LoadSocial>(loadSocial),
    TypedMiddleware<AppState, SaveSocialRequest>(saveSocial),
    TypedMiddleware<AppState, ArchiveSocialsRequest>(archiveSocial),
    TypedMiddleware<AppState, DeleteSocialsRequest>(deleteSocial),
    TypedMiddleware<AppState, PurgeSocialsRequest>(purgeSocial),
    TypedMiddleware<AppState, RestoreSocialsRequest>(restoreSocial),
    TypedMiddleware<AppState, UpdateSocialFilter>(updateFilter),
  ];
}

Middleware<AppState> _editSocial() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EditSocial;

    next(action);

    store.dispatch(UpdateCurrentRoute(SocialEditScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(SocialEditScreen.route);
    }
  };
}

Middleware<AppState> _viewSocial() {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ViewSocial;

    next(action);

    store.dispatch(UpdateCurrentRoute(SocialViewScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamed(SocialViewScreen.route);
    }
  };
}

Middleware<AppState> _viewSocialList() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ViewSocialList;

    next(action);

    if (store.state.staticState.isStale) {
      store.dispatch(RefreshData());
    }

    store.dispatch(UpdateCurrentRoute(SocialScreen.route));

    if (store.state.prefState.isMobile) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          SocialScreen.route, (Route<dynamic> route) => false);
    }
    store.dispatch(UpdateSocialFilter(
      store.state.socialState.filter.rebuild((b) => b..searchTerm = ''),
    ));
  };
}

Middleware<AppState> _archiveSocial(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ArchiveSocialsRequest;
    final prevSocials = action.socialIds
        .map((id) => store.state.socialState.map[id])
        .whereType<SocialEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.socialIds, EntityAction.archive)
        .then((List<SocialEntity> socials) {
      store.dispatch(ArchiveSocialsSuccess(socials));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(ArchiveSocialsFailure(prevSocials));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _deleteSocial(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as DeleteSocialsRequest;
    final prevSocials = action.socialIds
        .map((id) => store.state.socialState.map[id])
        .whereType<SocialEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.socialIds, EntityAction.delete)
        .then((List<SocialEntity> socials) {
      store.dispatch(DeleteSocialsSuccess(socials));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(DeleteSocialsFailure(prevSocials));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _purgeSocial(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PurgeSocialsRequest;
    final prevSocials = action.socialIds
        .map((id) => store.state.socialState.map[id])
        .whereType<SocialEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.socialIds, EntityAction.purge)
        .then((List<SocialEntity> socials) {
      store.dispatch(PurgeSocialsSuccess(socials));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(PurgeSocialsFailure(prevSocials));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _restoreSocial(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RestoreSocialsRequest;
    final prevSocials = action.socialIds
        .map((id) => store.state.socialState.map[id])
        .whereType<SocialEntity>()
        .toList();

    repository
        .bulkAction(
            store.state.credentials, action.socialIds, EntityAction.restore)
        .then((List<SocialEntity> socials) {
      store.dispatch(RestoreSocialsSuccess(socials));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(RestoreSocialsFailure(prevSocials));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveSocial(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SaveSocialRequest;

    final state = store.state;
    final selectionState = state.getUISelection(EntityType.photo);
    final filterEntityType = selectionState.filterEntityType;
    var selectedEvent = EventEntity();
    if (filterEntityType == EntityType.event) {
      selectedEvent = state.eventState.map[selectionState.filterEntityId] ??
          EventEntity(id: selectionState.filterEntityId);
    }
    final updatedSocial = action.social!.rebuild((b) => b
      ..createdUserId = getLoggedInUserId(store)
      ..userDisplayName = store.state.authState.currentUserName
      ..category = selectedEvent.name.isNotEmpty ? selectedEvent.name : '');
    repository
        .saveData(store.state.credentials, updatedSocial)
        .then((SocialEntity social) {
      if (action.social!.isNew) {
        store.dispatch(AddSocialSuccess(social));
      } else {
        store.dispatch(SaveSocialSuccess(social));
      }

      action.completer?.complete(social);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SaveSocialFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadSocial(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadSocial;

    store.dispatch(LoadSocialRequest());
    repository
        .loadItem(store.state.credentials, action.socialId!)
        .then((social) {
      store.dispatch(LoadSocialSuccess(social));
      action.completer?.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadSocialFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadSocials(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    if (store.state.isLoading) {
      return;
    }

    final action = dynamicAction as LoadSocials;
    final state = store.state; // Get current state filter from listUIState
    final stateFilters = state.socialListState.stateFilters;
    final currentFilter = action.filter ?? state.socialState.filter;
    final selectionState = state.getUISelection(EntityType.social);
    final filterEntityType = selectionState.filterEntityType;
    var selectedEvent = EventEntity();
    if (filterEntityType == EntityType.event) {
      selectedEvent = state.eventState.map[selectionState.filterEntityId] ??
          EventEntity(id: selectionState.filterEntityId);
    }

    // Update filter with current state filter from listUIState
    final filter = currentFilter.rebuild((b) {
      if (stateFilters.isNotEmpty) {
        b.stateFilter = stateFilters.first; // Use the first state filter
      } else {
        b.stateFilter = EntityState.active; // Default to active
      }
    });
    store.dispatch(LoadSocialsRequest(filter: filter));

    var lastDocument = state.socialState.lastDocument;
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
      currentUserId: getLoggedInUserId(store),
    )
        .then((response) {
      final socials = response['socials'] as BuiltList<SocialEntity>;
      final newLastDocument = response['lastDocument'] as DocumentSnapshot?;

      store.dispatch(LoadSocialsSuccess(socials, action.isRefresh));
      if (socials.isNotEmpty) {
        store.dispatch(UpdateLastDocumentAction(newLastDocument));
      }
      action.completer?.complete(null);
    }).catchError((Object error) {
      logError(' Error in loadSocials middleware: $error');
      store.dispatch(LoadSocialsFailure(error));
      action.completer?.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _updateFilter(SocialRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UpdateSocialFilter;

    next(action);

    store.dispatch(LoadSocials(
      filter: action.filter,
      isRefresh: true,
    ));
  };
}
