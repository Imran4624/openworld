import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';

class GoogleLoginButton extends StatelessWidget {
  final BuildContext parentContext;
  final LoginVM viewModel;
  final VoidCallback? onLoginSuccess;
  final bool isLoading;
  final Color? borderColor;
  final bool isDialogLogin;

  const GoogleLoginButton({
    super.key,
    required this.parentContext,
    required this.viewModel,
    this.onLoginSuccess,
    this.isLoading = false,
    this.borderColor,
    this.isDialogLogin = false,
  });

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.asset(
          'assets/images/google_logo.png',
          height: 24,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: borderColor ?? Colors.grey, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                final currentContext = parentContext;

                try {
                  final completer = Completer<Null>();
                  viewModel.onGoogleLoginPressed(currentContext, completer,
                      isDialogLogin: isDialogLogin);

                  completer.future.then((_) {
                    if (onLoginSuccess != null) onLoginSuccess!();
                  }).catchError((error) {
                    logError(' Google login error: $error');

                    if (currentContext.mounted) {
                      showDialog(
                        context: currentContext,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Login Error'),
                            content: Text(
                                'Failed to sign in with Google: ${error.toString()}'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                } catch (error) {
                  printL(' Unexpected error in Google login: $error');
                }
              },
      ),
    );
  }
}
