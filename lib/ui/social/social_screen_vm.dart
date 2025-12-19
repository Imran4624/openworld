import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/social/social_actions.dart';
import 'package:flutter_boilerplate/redux/social/social_selectors.dart';
import 'package:redux/redux.dart';

import 'social_screen.dart';

class SocialScreenBuilder extends StatelessWidget {
  const SocialScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SocialScreenVM>(
      converter: SocialScreenVM.fromStore,
      builder: (context, vm) {
        return SocialScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class SocialScreenVM {
  SocialScreenVM({
    required this.isInMultiselect,
    required this.socialList,
    required this.userCompany,
    required this.onEntityAction,
    required this.socialMap,
  });

  final bool isInMultiselect;
  final UserCompanyEntity userCompany;
  final List<String> socialList;
  final Function(BuildContext, List<BaseEntity>, EntityAction) onEntityAction;
  final BuiltMap<String, SocialEntity> socialMap;

  static SocialScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return SocialScreenVM(
      socialMap: state.socialState.map,
      socialList: memoizedFilteredSocialList(
        state.getUISelection(EntityType.social),
        state.socialState.map,
        state.socialState.list,
        state.socialListState,
      ),
      userCompany: state.userCompany,
      isInMultiselect: state.socialListState.isInMultiselect(),
      onEntityAction: (BuildContext context, List<BaseEntity> socials,
              EntityAction action) =>
          handleSocialAction(context, socials, action),
    );
  }
}
