import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/ui/profile_operation/edit/profile_operation_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ProfileOperationEditScreen extends StatelessWidget {
  const ProfileOperationEditScreen({Key? key}) : super(key: key);
  static const String route = '/profile_operation/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileOperationEditVM>(
      converter: (Store<AppState> store) {
        return ProfileOperationEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return ProfileOperationEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.profileOperation.updatedAt),
        );
      },
    );
  }
}

class ProfileOperationEditVM {
  ProfileOperationEditVM({
    required this.state,
    required this.profileOperation,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origProfileOperation,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  factory ProfileOperationEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final profileOperation = state.profileOperationUIState.editing;

    return ProfileOperationEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origProfileOperation:
          state.profileOperationState.map[profileOperation!.id],
      profileOperation: profileOperation,
      company: state.company,
      onChanged: (ProfileOperationEntity profileOperation) {
        store.dispatch(UpdateProfileOperation(profileOperation));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: ProfileOperationEntity(), force: true);
        if (state.profileOperationUIState.cancelCompleter != null) {
          state.profileOperationUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
        }
      },
      onSavePressed: (BuildContext context) {
        Debouncer.runOnComplete(() {
          final profileOperation = store.state.profileOperationUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<ProfileOperationEntity> completer =
              Completer<ProfileOperationEntity>();
          store.dispatch(SaveProfileOperationRequest(
              completer: completer, profileOperation: profileOperation));
          return completer.future.then((savedProfileOperation) {
            showToast(profileOperation.isNew
                ? localization.createdProfileOperation
                : localization.updatedProfileOperation);
            if (state.prefState.isMobile) {
              store.dispatch(
                  UpdateCurrentRoute(ProfileOperationViewScreen.route));
              if (profileOperation.isNew) {
                Navigator.of(context)
                    .pushReplacementNamed(ProfileOperationViewScreen.route);
              } else {
                Navigator.of(context).pop(savedProfileOperation);
              }
            } else {
              viewEntity(entity: savedProfileOperation, force: true);
            }
          }).catchError((Object error) {
            showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(error);
                });
          });
        });
      },
    );
  }

  final ProfileOperationEntity profileOperation;
  final CompanyEntity? company;
  final Function(ProfileOperationEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final ProfileOperationEntity? origProfileOperation;
  final AppState state;
}
