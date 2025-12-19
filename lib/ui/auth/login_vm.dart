// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/ui/auth/login_view_opw.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// Project imports:
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/auth/auth_state.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/app_builder.dart';
import 'package:flutter_boilerplate/ui/auth/login_view.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/oauth.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, LoginVM>(
        converter: LoginVM.fromStore,
        builder: (context, viewModel) {
          if (ProjectConfig.appType == AppType.opw) {
            return LoginViewOpw(
              viewModel: viewModel,
            );
            
          }
          return LoginView(
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}

class LoginVM {
  LoginVM({
    required this.state,
    required this.isLoading,
    required this.authState,
    required this.onLoginPressed,
    required this.onRecoverPressed,
    required this.onSignUpPressed,
    required this.onGoogleLoginPressed,
    required this.onPhoneAuthPressed,
    required this.onGoogleSignUpPressed,
    required this.onMicrosoftLoginPressed,
    required this.onMicrosoftSignUpPressed,
    required this.onAppleLoginPressed,
    required this.onAppleSignUpPressed,
    required this.onTokenLoginPressed,
    required this.onEmailLinkLoginPressed,
    required this.onSendEmailLinkPressed,
  });

  AppState state;
  bool isLoading;
  AuthState authState;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    required String email,
    required String password,
    required String url,
    required String secret,
    required String oneTimePassword,
    bool isDialogLogin,
  }) onLoginPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    required String email,
    required String url,
    required String secret,
  }) onRecoverPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    required String email,
    required String password,
  }) onSignUpPressed;

  final Function(
    BuildContext context, {
    required String phoneNumber,
    String? url,
    String? secret,
    bool isDialogLogin,
  }) onPhoneAuthPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    required String token,
  }) onTokenLoginPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    required String email,
  }) onEmailLinkLoginPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    required String email,
  }) onSendEmailLinkPressed;

  final Function(BuildContext, Completer<Null> completer,
      {String url,
      String secret,
      String oneTimePassword,
      bool isDialogLogin}) onGoogleLoginPressed;
  final Function(BuildContext, Completer<Null> completer, String url)
      onGoogleSignUpPressed;

  final Function(BuildContext, Completer<Null> completer,
      {String url,
      String secret,
      String oneTimePassword}) onMicrosoftLoginPressed;
  final Function(BuildContext, Completer<Null> completer, String url)
      onMicrosoftSignUpPressed;

  final Function(BuildContext, Completer<Null> completer,
      {String url,
      String secret,
      String oneTimePassword,
      bool isDialogLogin}) onAppleLoginPressed;
  final Function(BuildContext, Completer<Null> completer, String url)
      onAppleSignUpPressed;

  static LoginVM fromStore(Store<AppState> store) {
    Null handleLogin({required BuildContext context, bool isSignUp = false}) {
      final layout = calculateLayout(context);
      final moduleLayout =
          layout == AppLayout.desktop ? ModuleLayout.table : ModuleLayout.list;
      store.dispatch(UpdateUserPreferences(
        appLayout: layout,
        moduleLayout: isSignUp ? moduleLayout : null,
      ));
      AppBuilder.of(context)!.rebuild();

      WidgetsBinding.instance.addPostFrameCallback((duration) async {
        final completer = Completer<Null>();
        try {
          store.dispatch(RegisterDeviceRequest());

          // final isDialogLogin = store.state.authState.isDialogLogin;

          // if (isDialogLogin) {
          //   printL(' Popup login detected - skipping navigation');
          //   completer.complete();
          //   return;
          // }

          if (layout == AppLayout.mobile) {
            if (isSignUp) {
              store.dispatch(
                  UpdateUserPreferences(moduleLayout: ModuleLayout.list));
            }
            final profileCompleter = Completer<Null>();
            store.dispatch(CheckProfileCompletionRequest(
                context: navigatorKey.currentContext!,
                completer: profileCompleter,
                isSignUp: isSignUp));

            profileCompleter.future.then((_) {
              store.dispatch(UpdateAuthState());
              store.dispatch(UserLoginSuccess());
            }).catchError((error) {
              printL('Error updating profile completion status: $error');
              store.dispatch(UserLoginSuccess());
            });
          } else {
            if (ProjectConfig.enablePhoneLogin()) {
              final profileCompleter = Completer<Null>();
              store.dispatch(CheckProfileCompletionRequest(
                  context: navigatorKey.currentContext!,
                  completer: profileCompleter,
                  isSignUp: isSignUp));

              profileCompleter.future.then((_) {
                store.dispatch(ViewMainScreen());
                store.dispatch(UserLoginSuccess());
              }).catchError((error) {
                printL('Error updating profile completion status: $error');
                store.dispatch(ViewMainScreen());
                store.dispatch(UserLoginSuccess());
              });
            } else {
              store.dispatch(ViewMainScreen());
              store.dispatch(UserLoginSuccess());
            }
          }

          completer.complete();
        } catch (e) {
          printL('Error during login flow: $e');
          store.dispatch(UserLoginFailure(e));
          completer.complete();
        }
      });
    }

    String _formatApiUrl(String url) {
      url = url.trim();

      if (url.isEmpty) {
        url = kAppProductionUrl;
      } else if (!url.startsWith('http')) {
        url = 'https://' + url;
      }

      return formatApiUrl(url);
    }

    return LoginVM(
      state: store.state,
      isLoading: store.state.isLoading,
      authState: store.state.authState,
      onGoogleLoginPressed: (
        BuildContext context,
        Completer<Null> completer, {
        String url = '',
        String secret = '',
        String oneTimePassword = '',
        bool isDialogLogin = false,
      }) async {
        try {
          final signedIn = await GoogleOAuth.signIn((idToken, accessToken) {
            if (idToken.isEmpty && accessToken.isEmpty) {
              completer.completeError(
                  AppLocalization.of(context)!.anErrorOccurredTryAgain);
              return;
            }

            store.dispatch(OAuthLoginRequest(
              completer: completer,
              idToken: idToken,
              accessToken: accessToken,
              url: _formatApiUrl(url),
              secret: secret.trim(),
              platform: getPlatform(context),
              provider: UserEntity.OAUTH_PROVIDER_GOOGLE,
              oneTimePassword: oneTimePassword,
              isDialogLogin: isDialogLogin,
            ));

            completer.future.then<Null>((_) {
              if (!isDialogLogin) {
                handleLogin(context: context);
              } else {
                Navigator.of(context).pop();
              }
            }).catchError((error) {
              printL(' Error in Google login future: $error');
            });
          });

          if (!signedIn) {
            printL(' Google sign in was cancelled or failed');
            completer.completeError(
                AppLocalization.of(navigatorKey.currentContext!)!
                    .anErrorOccurredTryAgain);
          }
        } catch (error) {
          printL(' ERROR in onGoogleLoginPressed: $error');
          completer.completeError(error);
        }
      },
      onGoogleSignUpPressed:
          (BuildContext context, Completer<Null> completer, String url) async {
        try {
          final signedIn = await GoogleOAuth.signUp((idToken, accessToken) {
            if (idToken.isEmpty || accessToken.isEmpty) {
              completer.completeError(
                  AppLocalization.of(context)!.anErrorOccurredTryAgain);
              return;
            }

            store.dispatch(OAuthSignUpRequest(
              url: url,
              completer: completer,
              idToken: idToken,
              accessToken: accessToken,
              provider: UserEntity.OAUTH_PROVIDER_GOOGLE,
            ));

            completer.future.then<Null>((_) {
              printL(' Google sign up successful, handling login flow...');
              handleLogin(context: context, isSignUp: true);
            }).catchError((error) {
              printL(' Error in Google sign up future: $error');
            });
          });

          if (!signedIn) {
            printL(' Google sign up was cancelled or failed');
            completer.completeError(
                AppLocalization.of(navigatorKey.currentContext!)!
                    .anErrorOccurredTryAgain);
          }
        } catch (error) {
          printL(' ERROR in onGoogleSignUpPressed: $error');
          completer.completeError(error);
        }
      },
      onPhoneAuthPressed: (
        BuildContext context, {
        required String phoneNumber,
        String? url,
        String? secret,
        bool isDialogLogin = false,
      }) {
        final completer = Completer<Null>();
        store.dispatch(PhoneAuthRequest(
          completer: completer,
          phoneNumber: phoneNumber,
          url: url,
          secret: secret,
          isDialogLogin: isDialogLogin,
        ));
        if (!isDialogLogin) {
          completer.future.then<Null>((_) => handleLogin(context: context));
        }
        return completer;
      },
      onMicrosoftLoginPressed: (
        BuildContext context,
        Completer<Null> completer, {
        String url = '',
        String secret = '',
        String oneTimePassword = '',
      }) async {
        try {
          WebUtils.microsoftLogin((idToken, accessToken) {
            store.dispatch(OAuthLoginRequest(
              completer: completer,
              idToken: idToken,
              accessToken: accessToken,
              url: _formatApiUrl(url),
              secret: secret.trim(),
              platform: getPlatform(context),
              provider: UserEntity.OAUTH_PROVIDER_MICROSOFT,
              oneTimePassword: oneTimePassword,
            ));
            completer.future.then<Null>((_) => handleLogin(context: context));
          }, (dynamic error) {
            completer.completeError(error);
          });
        } catch (error) {
          completer.completeError(error);
          printL(' onMicrosoftLoginPressed: $error');
        }
      },
      onMicrosoftSignUpPressed:
          (BuildContext context, Completer<Null> completer, String url) async {
        try {
          WebUtils.microsoftLogin((idToken, accessToken) {
            store.dispatch(OAuthSignUpRequest(
              url: url,
              completer: completer,
              idToken: idToken,
              provider: UserEntity.OAUTH_PROVIDER_MICROSOFT,
              accessToken: accessToken,
            ));
            completer.future.then<Null>(
                (_) => handleLogin(context: context, isSignUp: true));
          }, (dynamic error) {
            completer.completeError(error);
          });
        } catch (error) {
          completer.completeError(error);
          printL(' onMicrosoftSignUpPressed: $error');
        }
      },
      onAppleLoginPressed: (
        BuildContext context,
        Completer<Null> completer, {
        String url = '',
        String secret = '',
        String oneTimePassword = '',
        bool isDialogLogin = false,
      }) async {
        try {
          final credentials = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              clientId: kAppleOAuthClientId,
              redirectUri: Uri.parse(kAppleOAuthRedirectUrl),
            ),
          );

          store.dispatch(OAuthLoginRequest(
            completer: completer,
            url: _formatApiUrl(url),
            secret: secret.trim(),
            platform: getPlatform(navigatorKey.currentContext!),
            provider: UserEntity.OAUTH_PROVIDER_APPLE,
            oneTimePassword: oneTimePassword,
            email: credentials.email,
            authCode: credentials.authorizationCode,
            idToken: credentials.identityToken,
            isDialogLogin: isDialogLogin,
          ));
          if (!isDialogLogin) {
            completer.future.then<Null>((_) => handleLogin(context: context));
          }
        } catch (error) {
          completer.completeError(error);
          printL(' onAppleLoginPressed: $error');
        }
      },
      onAppleSignUpPressed:
          (BuildContext context, Completer<Null> completer, String url) async {
        try {
          final credentials = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              clientId: kAppleOAuthClientId,
              redirectUri: Uri.parse(kAppleOAuthRedirectUrl),
            ),
          );

          store.dispatch(OAuthSignUpRequest(
            url: url,
            completer: completer,
            provider: UserEntity.OAUTH_PROVIDER_APPLE,
            idToken: credentials.identityToken,
            firstName: credentials.givenName,
            lastName: credentials.familyName,
          ));
          completer.future
              .then<Null>((_) => handleLogin(context: context, isSignUp: true));
        } catch (error) {
          completer.completeError(error);
          printL(' onAppleSignUpPressed: $error');
        }
      },
      onSignUpPressed: (
        BuildContext context,
        Completer<Null> completer, {
        required String email,
        required String password,
      }) async {
        if (store.state.isLoading) {
          return;
        }

        store.dispatch(UserSignUpRequest(
          completer: completer,
          email: email.trim(),
          password: password.trim(),
        ));
        completer.future
            .then<Null>((_) => handleLogin(context: context, isSignUp: true));
      },
      onRecoverPressed: (
        BuildContext context,
        Completer<Null> completer, {
        required String email,
        required String url,
        required String secret,
      }) async {
        if (store.state.isLoading) {
          return;
        }

        store.dispatch(RecoverPasswordRequest(
          completer: completer,
          email: email.trim(),
          url: _formatApiUrl(url),
          secret: secret.trim(),
        ));
      },
      onLoginPressed: (
        BuildContext context,
        Completer<Null> completer, {
        required String email,
        required String password,
        required String url,
        required String secret,
        required String oneTimePassword,
        bool isDialogLogin = false,
      }) async {
        if (store.state.isLoading) {
          return;
        }

        store.dispatch(UserLoginRequest(
          completer: completer,
          email: email.trim(),
          password: password.trim(),
          url: _formatApiUrl(url),
          secret: secret.trim(),
          platform: getPlatform(context),
          oneTimePassword: oneTimePassword.trim(),
          isDialogLogin: isDialogLogin,
        ));
        if (!isDialogLogin) {
          completer.future.then<Null>((_) => handleLogin(context: context));
        }
      },
      onTokenLoginPressed: (BuildContext context, Completer<Null> completer,
          {required String token}) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString(kSharedPrefToken, TokenEntity.obscureToken(token));
        prefs.setString(kSharedPrefUrl, kAppProductionUrl);
      },
      onEmailLinkLoginPressed: (BuildContext context, Completer<Null> completer,
          {required String email}) async {
        store.dispatch(EmailLinkLoginRequest(
          completer: completer,
          email: email,
        ));
        completer.future.then<Null>((_) => handleLogin(context: context));
      },
      onSendEmailLinkPressed: (BuildContext context, Completer<Null> completer,
          {required String email}) async {
        store.dispatch(SendEmailLinkRequest(
          completer: completer,
          email: email,
        ));
      },
    );
  }
}
