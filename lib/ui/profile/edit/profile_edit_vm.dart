import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit_opw.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);
  static const String route = '/profile/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileEditVM>(
      converter: (Store<AppState> store) {
        return ProfileEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        if (ProjectConfig.appType == AppType.opw) {
          return ProfileEditOpw(
            viewModel: viewModel,
            key: ValueKey(viewModel.profile.updatedAt),
          );
          
        }
        return ProfileEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.profile.updatedAt),
        );
      },
    );
  }
}

class ProfileEditVM {
  ProfileEditVM({
    required this.state,
    required this.profile,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origProfile,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory ProfileEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final profile = state.profileUIState.editing;

    return ProfileEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origProfile: state.profileState.map[profile!.id],
      profile: profile,
      company: state.company,
      onChanged: (ProfileEntity profile) {
        store.dispatch(UpdateProfile(profile));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: ProfileEntity(), force: true);
        if (state.profileUIState.cancelCompleter != null) {
          state.profileUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() async {
          final profile = store.state.profileUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<ProfileEntity> completer = Completer<ProfileEntity>();

          store.dispatch(
              SaveProfileRequest(completer: completer, profile: profile));

          try {
            if (context.mounted) {
              showToast(
                profile.isNew
                    ? localization.createdProfile
                    : localization.updatedProfile,
                context: context,
              );
            }
          } catch (error) {
            if (context.mounted) {
              showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(error);
                },
              );
            }
          }
        });
      },
    );
  }

  final ProfileEntity profile;
  final CompanyEntity? company;
  final Function(ProfileEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final ProfileEntity? origProfile;
  final AppState state;
}
