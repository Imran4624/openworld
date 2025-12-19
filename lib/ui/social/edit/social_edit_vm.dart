import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/redux/social/social_actions.dart';
import 'package:flutter_boilerplate/ui/social/edit/social_edit.dart';
import 'package:flutter_boilerplate/ui/social/social_screen.dart'; 
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class SocialEditScreen extends StatelessWidget {
  const SocialEditScreen({Key? key}) : super(key: key);
  static const String route = '/social/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SocialEditVM>(
      converter: (Store<AppState> store) {
        return SocialEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return SocialEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.social.updatedAt),
        );
      },
    );
  }
}

class SocialEditVM {
  SocialEditVM({
    required this.state,
    required this.social,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origSocial,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory SocialEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final social = state.socialUIState.editing;

    return SocialEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origSocial: state.socialState.map[social!.id],
      social: social,
      company: state.company,
      onChanged: (SocialEntity social) {
        store.dispatch(UpdateSocial(social));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: SocialEntity(), force: true);
        if (state.socialUIState.cancelCompleter != null) {
          state.socialUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(SocialScreen.route));
          if (state.prefState.isMobile) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              SocialScreen.route, 
              (Route<dynamic> route) => false
            );
          }
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() {
          final social = store.state.socialUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<SocialEntity> completer = Completer<SocialEntity>();
          
          final navigator = Navigator.of(context);
          
          store.dispatch(
              SaveSocialRequest(completer: completer, social: social));
          
          return completer.future.then((savedSocial) {
            showToast(social.isNew
                ? localization.createdSocial
                : localization.updatedSocial);
            
            store.dispatch(UpdateCurrentRoute(SocialScreen.route));
            
            if (social.isNew) {
              navigator.pushNamedAndRemoveUntil(
                  SocialScreen.route, (route) => false);
            } else {
              navigator.pop(savedSocial);
            }
          }).catchError((Object error) {
            if (context.mounted) {
              showDialog<ErrorDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(error);
                  });
            }
          });
        });
      },
    );
  }

  final SocialEntity social;
  final CompanyEntity? company;
  final Function(SocialEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final SocialEntity? origSocial;
  final AppState state;
}
