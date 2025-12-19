import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/ui/entity_ui_state.dart';
import 'package:flutter_boilerplate/redux/social/social_actions.dart';
import 'package:flutter_boilerplate/redux/ui/list_ui_state.dart';
import 'package:flutter_boilerplate/redux/social/social_state.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart'
    as operations;

EntityUIState socialUIReducer(SocialUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(socialListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)!)
    ..selectedId = selectedIdReducer(state.selectedId, action)
    ..forceSelected = forceSelectedReducer(state.forceSelected, action)
    ..tabIndex = tabIndexReducer(state.tabIndex, action));
}

final forceSelectedReducer = combineReducers<bool?>([
  TypedReducer<bool?, ViewSocial>((completer, action) => true),
  TypedReducer<bool?, ViewSocialList>((completer, action) => false),
  TypedReducer<bool?, FilterSocialsByState>((completer, action) => false),
  TypedReducer<bool?, FilterSocials>((completer, action) => false),
]);

final tabIndexReducer = combineReducers<int?>([
  TypedReducer<int?, UpdateSocialTab>((completer, action) => action.tabIndex),
  TypedReducer<int?, PreviewEntity>((completer, action) => 0),
]);

Reducer<String?> selectedIdReducer = combineReducers([
  TypedReducer<String?, ArchiveSocialsSuccess>((completer, action) => ''),
  TypedReducer<String?, DeleteSocialsSuccess>((completer, action) => ''),
  TypedReducer<String?, PurgeSocialsSuccess>((completer, action) => ''),
  TypedReducer<String?, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.social ? action.entityId : selectedId),
  TypedReducer<String?, ViewSocial>(
      (String? selectedId, dynamic action) => action.socialId),
  TypedReducer<String?, AddSocialSuccess>(
      (String? selectedId, dynamic action) => action.social.id),
  TypedReducer<String?, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String?, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String?, SortSocials>((selectedId, action) => ''),
  TypedReducer<String?, FilterSocials>((selectedId, action) => ''),
  TypedReducer<String?, FilterSocialsByState>((selectedId, action) => ''),
  TypedReducer<String?, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.social
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<SocialEntity?>([
  TypedReducer<SocialEntity?, SaveSocialSuccess>(_updateEditing),
  TypedReducer<SocialEntity?, AddSocialSuccess>(_updateEditing),
  TypedReducer<SocialEntity?, RestoreSocialsSuccess>((socials, action) {
    return action.socials[0];
  }),
  TypedReducer<SocialEntity?, ArchiveSocialsSuccess>((socials, action) {
    return action.socials[0];
  }),
  TypedReducer<SocialEntity?, DeleteSocialsSuccess>((socials, action) {
    return action.socials[0];
  }),
  TypedReducer<SocialEntity?, PurgeSocialsSuccess>((socials, action) {
    return action.socials[0];
  }),
  TypedReducer<SocialEntity?, EditSocial>(_updateEditing),
  TypedReducer<SocialEntity?, UpdateSocial>((social, action) {
    return action.social.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<SocialEntity?, DiscardChanges>(_clearEditing),
]);

SocialEntity _clearEditing(SocialEntity? social, dynamic action) {
  return SocialEntity();
}

SocialEntity? _updateEditing(SocialEntity? social, dynamic action) {
  return action.social;
}

final socialListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortSocials>(_sortSocials),
  TypedReducer<ListUIState, FilterSocialsByState>(_filterSocialsByState),
  TypedReducer<ListUIState, FilterSocials>(_filterSocials),
  TypedReducer<ListUIState, StartSocialMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToSocialMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromSocialMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearSocialMultiselect>(_clearListMultiselect),
  TypedReducer<ListUIState, ViewSocialList>(_viewSocialList),
  TypedReducer<ListUIState, FilterByEntity>((state, action) => state.rebuild(
        (b) => b
          ..filter = null
          ..filterClearedAt = DateTime.now().millisecondsSinceEpoch,
      )),
]);

ListUIState _viewSocialList(
    ListUIState socialListState, ViewSocialList action) {
  return socialListState.rebuild((b) => b
    ..selectedIds = null
    ..filter = null
    ..filterClearedAt = DateTime.now().millisecondsSinceEpoch);
}

ListUIState _filterSocialsByState(
    ListUIState socialListState, FilterSocialsByState action) {
  if (socialListState.stateFilters.contains(action.state)) {
    return socialListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(EntityState.active));
  } else {
    return socialListState.rebuild((b) => b
      ..stateFilters.clear()
      ..stateFilters.add(action.state));
  }
}

ListUIState _filterSocials(ListUIState socialListState, FilterSocials action) {
  return socialListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : socialListState.filterClearedAt);
}

ListUIState _sortSocials(ListUIState socialListState, SortSocials action) {
  return socialListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending!
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState productListState, StartSocialMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState productListState, AddToSocialMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState productListState, RemoveFromSocialMultiselect action) {
  return productListState
      .rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState productListState, ClearSocialMultiselect action) {
  return productListState.rebuild((b) => b..selectedIds = null);
}

final socialsReducer = combineReducers<SocialState>([
  TypedReducer<SocialState, SaveSocialSuccess>(_updateSocial),
  TypedReducer<SocialState, AddSocialSuccess>(_addSocial),
  TypedReducer<SocialState, LoadSocialsSuccess>(_setLoadedSocials),
  TypedReducer<SocialState, LoadSocialSuccess>(_setLoadedSocial),
  TypedReducer<SocialState, UpdateLastDocumentAction>(_updateLastDocument),
  TypedReducer<SocialState, UpdateSocialFilter>(_updateSocialFilter),
  // TypedReducer<SocialState, LoadCompanySuccess>(_setLoadedCompany), //uncomment this if you its dependant on selected company
  TypedReducer<SocialState, ArchiveSocialsSuccess>(_archiveSocialSuccess),
  TypedReducer<SocialState, DeleteSocialsSuccess>(_deleteSocialSuccess),
  TypedReducer<SocialState, PurgeSocialsSuccess>(_purgeSocialSuccess),
  TypedReducer<SocialState, RestoreSocialsSuccess>(_restoreSocialSuccess),

  // Add entity operation reducers - THESE WERE MISSING!
  TypedReducer<SocialState, operations.LikeEntitySuccess>(
      _handleLikeEntitySuccess),
  TypedReducer<SocialState, operations.CommentEntitySuccess>(
      _handleCommentEntitySuccess),
  TypedReducer<SocialState, operations.ReportEntitySuccess>(
      _handleReportEntitySuccess),
]);

SocialState _handleLikeEntitySuccess(
    SocialState socialState, operations.LikeEntitySuccess action) {
  if (action.entityType != EntityType.social) {
    return socialState;
  }

  final targetId = action.data['targetId'] as String;
  final newLikesMap = action.data['likesMap'] as Map<String, dynamic>;
  final newLikeCount = action.data['likeCount'] as int;
  final currentSocial = socialState.map[targetId];

  if (currentSocial == null) {
    return socialState;
  }

  return socialState.rebuild((b) {
    final updatedSocial = currentSocial.rebuild((sb) => sb
      ..likesMap = Map<String, dynamic>.from(newLikesMap)
      ..likeCount = newLikeCount);

    b.map[targetId] = updatedSocial;
  });
}

SocialState _handleCommentEntitySuccess(
    SocialState socialState, operations.CommentEntitySuccess action) {
  if (action.entityType != EntityType.social) {
    return socialState;
  }

  final targetId = action.data['targetId'] as String;
  final newCommentsMap = action.data['commentsMap'] as Map<String, dynamic>;
  final newCommentCount = action.data['commentCount'] as int;
  final currentSocial = socialState.map[targetId];

  if (currentSocial == null) {
    return socialState;
  }

  return socialState.rebuild((b) {
    final updatedSocial = currentSocial.rebuild((sb) => sb
      ..commentsMap = Map<String, dynamic>.from(newCommentsMap)
      ..commentCount = newCommentCount);

    b.map[targetId] = updatedSocial;
  });
}

SocialState _handleReportEntitySuccess(
    SocialState socialState, operations.ReportEntitySuccess action) {
  if (action.entityType != EntityType.social) {
    return socialState;
  }

  final targetId = action.data['targetId'] as String;
  final newReportsMap = action.data['reportsMap'] as Map<String, dynamic>;
  final reported = action.data['reported'] as bool;
  final currentSocial = socialState.map[targetId];

  if (currentSocial == null) {
    return socialState;
  }

  return socialState.rebuild((b) {
    final updatedSocial = currentSocial.rebuild((sb) => sb
      ..reportsMap = Map<String, dynamic>.from(newReportsMap)
      ..reported = reported);

    b.map[targetId] = updatedSocial;
  });
}

SocialState _archiveSocialSuccess(
    SocialState socialState, ArchiveSocialsSuccess action) {
  final int currentTime = DateTime.now().millisecondsSinceEpoch;
  return socialState.rebuild((b) {
    for (final social in action.socials) {
      b.map[social.id] = socialState.map[social.id]!
          .rebuild((b) => b..archivedAt = currentTime);
    }
  });
}

SocialState _updateSocialFilter(
    SocialState socialState, UpdateSocialFilter action) {
  return socialState.rebuild((b) => b..filter = action.filter.toBuilder());
}

// SocialState _deleteSocialSuccess(SocialState socialState, DeleteSocialsSuccess action) {
//   return socialState.rebuild((b) {
//     for (final social in action.socials) {
//       b.map[social.id] = social;
//     }
//   });
// }

SocialState _deleteSocialSuccess(
    SocialState socialState, DeleteSocialsSuccess action) {
  return socialState.rebuild((b) {
    for (final social in action.socials) {
      b.map[social.id] =
          socialState.map[social.id]!.rebuild((b) => b..isDeleted = true);
    }
  });
}

SocialState _purgeSocialSuccess(
    SocialState socialState, PurgeSocialsSuccess action) {
  return socialState.rebuild((b) {
    for (final social in action.socials) {
      b.map.remove(social.id);
      b.list.remove(social.id);
    }
  });
}

SocialState _restoreSocialSuccess(
    SocialState socialState, RestoreSocialsSuccess action) {
  return socialState.rebuild((b) {
    for (final social in action.socials) {
      b.map[social.id] = socialState.map[social.id]!.rebuild((b) => b
        ..isDeleted = false
        ..archivedAt = 0);
    }
  });
}

SocialState _addSocial(SocialState socialState, AddSocialSuccess action) {
  return socialState.rebuild((b) => b
    ..map[action.social.id] = action.social
    ..list.insert(0, action.social.id));
}

SocialState _updateSocial(SocialState socialState, SaveSocialSuccess action) {
  return socialState.rebuild((b) => b..map[action.social.id] = action.social);
}

SocialState _updateLastDocument(
    SocialState socialState, UpdateLastDocumentAction action) {
  return socialState.rebuild((b) => b..lastDocument = action.lastDocument);
}

SocialState _setLoadedSocial(
    SocialState socialState, LoadSocialSuccess action) {
  return socialState.rebuild((b) => b..map[action.social.id] = action.social);
}

SocialState _setLoadedSocials(
    SocialState socialState, LoadSocialsSuccess action) {
  return socialState.rebuild((b) {
    if (action.isRefresh) {
      b.map.clear();
      b.list.clear();
    }
    action.socials.forEach((social) {
      b.map[social.id] = social;
      if (!b.list.build().contains(social.id)) {
        b.list.add(social.id);
      }
    });
  });
}

// SocialState _setLoadedCompany(SocialState socialState, LoadCompanySuccess action) {
//   final company = action.userCompany.company;
//   return socialState.loadSocials(company.socials);
// }
