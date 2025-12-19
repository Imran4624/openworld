// Flutter imports:
import 'dart:async';

import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/ui/app/confirm_email.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ConfirmEmailBuilder extends StatelessWidget {
  const ConfirmEmailBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConfirmEmailVM>(
      converter: ConfirmEmailVM.fromStore,
      builder: (context, viewModel) {
        return ConfirmEmail(viewModel: viewModel);
      },
    );
  }
}

class ConfirmEmailVM {
  ConfirmEmailVM({
    this.state,
    this.onRefreshPressed,
    this.onResendPressed,
    this.isEmailConfirmed,
    this.onLogoutPressed,
    this.onUseLastPressed,
    this.onChangeEmail,
  });

  final AppState? state;
  final Function? onResendPressed;
  final Function? isEmailConfirmed;
  final Function? onRefreshPressed;
  final Function? onLogoutPressed;
  final Function(BuildContext, String, String?, String?)? onChangeEmail;
  final Function(BuildContext)? onUseLastPressed;

  static ConfirmEmailVM fromStore(Store<AppState> store) {
    final AppState state = store.state;

    return ConfirmEmailVM(
      state: state,
      onRefreshPressed: () {
        store.dispatch(RefreshData());
      },
      onLogoutPressed: () {
        store.dispatch(UserLogout());
      },
      onResendPressed: () {
        store.dispatch(ResendConfirmation());
      },
      isEmailConfirmed: () {
        final completer = Completer<void>();
        store.dispatch(IsEmailConfirmed(completer: completer));
      },
      onChangeEmail: (context, email, password, idToken) {
        final user = store.state.user.rebuild((b) => b..email = email);
        final completer =
            snackBarCompleter<Null>(AppLocalization.of(context)!.savedSettings);
        store.dispatch(SaveAuthUserRequest(
          user: user,
          password: password,
          idToken: idToken,
          completer: completer,
        ));
      },
      onUseLastPressed: (context) {
        final user = state.user;
        passwordCallback(
            context: context,
            callback: (password, idToken) {
              store.dispatch(
                SaveAuthUserRequest(
                  user: user.rebuild((b) => b..email = user.lastEmailAddress),
                  password: password,
                  idToken: idToken,
                ),
              );
            });
      },
    );
  }
}
