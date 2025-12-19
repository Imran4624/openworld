// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/loading_indicator.dart';

// Project imports:
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/app/buttons/elevated_button.dart';
import 'package:flutter_boilerplate/ui/settings/account_management_vm.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AccountManagement extends StatelessWidget {
  const AccountManagement({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final AccountManagementVM viewModel;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final companies = viewModel.state.companies;
    final company = viewModel.company;
    final theme = Theme.of(context);
    final store = StoreProvider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.accountManagement),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.check),
        //     onPressed: () => viewModel.onSavePressed(context),
        //   ),
        // ],
      ),
      body: store.state.isLoading || store.state.isSaving
          ? LoadingIndicator()
        :ScrollableListView(
        primary: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: AppButton(
                label: localization.changePassword.toUpperCase(),
                color: theme.primaryColor,
                iconData: isMobile(context) ? null : Icons.lock,
                onPressed: () {
                  showChangePasswordDialog(
                      message: AppLocalization.of(context)!.changePassword,
                      context: context,
                      callback: (oldPassword, newPassword) async {
                        // Handle the password change logic here
                        store.dispatch(ChangePassword(
                            oldPassword: oldPassword!,
                            newPassword: newPassword!,
                            completer: Completer()));
                      });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: AppButton(
                label: (companies.length == 1)
                    ? localization.cancelAccount.toUpperCase()
                    : localization.deleteCompany.toUpperCase(),
                color: Colors.red,
                iconData: isMobile(context) ? null : Icons.delete,
                onPressed: () {
                  String message = (companies.length == 1)
                      ? localization.cancelAccountMessage
                      : localization.deleteCompanyMessage;

                  message = message.replaceFirst(
                      ':company',
                      company.displayName.isEmpty
                          ? localization.newCompany
                          : company.displayName);

                  confirmCallback(
                    context: context,
                    message: message,
                    typeToConfirm: localization.delete.toLowerCase(),
                    askForReason: true,
                    callback: (String? reason) {
                      final completer = Completer<Null>();
                      
                      completer.future.then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.deletedAccount)),
                        );
                        
                        Future.delayed(Duration(milliseconds: 1500), () {
                          store.dispatch(UserLogout());
                        });
                      }).catchError((error) {
                        print('Error purging profile: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting profile: $error'),
                          ),
                        );
                      });
                      
                      store.dispatch(PurgeProfilesRequest(
                        completer,
                        [getLoggedInUserId(store)].toList(),
                        true,
                      ));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
