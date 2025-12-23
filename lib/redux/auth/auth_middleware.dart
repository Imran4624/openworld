// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';
import 'package:flutter_boilerplate/ui/app/sms_verification.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_load_questions.dart';
import 'package:flutter_boilerplate/ui/profile/editOpw/create_profile_opw.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/widgets.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// Package imports:
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_builder.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

List<Middleware<AppState>> createStoreAuthMiddleware([
  AuthRepository repository = const AuthRepository(),
]) {
  final userLogout = _createUserLogout(repository);
  // final userLogoutAll = _createUserLogoutAll(repository);
  final loginRequest = _createLoginRequest(repository);
  final oauthLoginRequest = _createOAuthLoginRequest(repository);
  final changePassword = _createChangePasswordRequest(repository);
  final signUpRequest = _createSignUpRequest(repository);
  // final oauthSignUpRequest = _createOAuthSignUpRequest(repository);
  final refreshRequest = _createRefreshRequest(repository);
  final recoverRequest = _createRecoverRequest(repository);
  final updateProfileCompletionStatus =
      _updateProfileCompletionStatus(repository);
  final checkProfileCompletion = _checkProfileCompletion(repository);
  final checkExistingProfileByEmail = _checkExistingProfileByEmail(repository);
  final sendVerificationCode = _createSendPhoneVerificationCode(repository);
  final verifyPhoneCode = _createVerifyPhoneCode(repository);
  final updatePhoneStatus = _updatePhoneVerificationStatus(repository);
  // final addCompany = _createCompany(repository);
  // final deleteCompany = _deleteCompany(repository);
  // final setDefaultCompany = _setDefaultCompany(repository);
  // final purgeData = _purgeData(repository);
  final resendConfirmation = _resendConfirmation(repository);
  final isEmailConfirmed = _isEmailConfirmed(repository);
  final createPhoneAuthRequest = _createPhoneAuthRequest(repository);
  final sendEmailLinkRequest = _createSendEmailLinkRequest(repository);
  final emailLinkLoginRequest = _createEmailLinkLoginRequest(repository);

  return [
    TypedMiddleware<AppState, UserLogout>(userLogout),
    // TypedMiddleware<AppState, UserLogoutAll>(userLogoutAll),
    TypedMiddleware<AppState, UserLoginRequest>(loginRequest),
    TypedMiddleware<AppState, PhoneAuthRequest>(createPhoneAuthRequest),
    TypedMiddleware<AppState, OAuthLoginRequest>(oauthLoginRequest),
    TypedMiddleware<AppState, ChangePassword>(changePassword),
    TypedMiddleware<AppState, UserSignUpRequest>(signUpRequest),
    // TypedMiddleware<AppState, OAuthSignUpRequest>(oauthSignUpRequest),
    TypedMiddleware<AppState, RefreshData>(refreshRequest),
    TypedMiddleware<AppState, RecoverPasswordRequest>(recoverRequest),
    TypedMiddleware<AppState, UpdateProfileCompletionStatus>(
        updateProfileCompletionStatus),
    TypedMiddleware<AppState, CheckProfileCompletionRequest>(
        checkProfileCompletion),
    TypedMiddleware<AppState, CheckExistingProfileByEmailRequest>(
        checkExistingProfileByEmail),
    TypedMiddleware<AppState, SendPhoneVerificationCodeRequest>(
        sendVerificationCode),
    TypedMiddleware<AppState, VerifyPhoneCodeRequest>(verifyPhoneCode),
    TypedMiddleware<AppState, UpdatePhoneVerificationStatus>(updatePhoneStatus),
    // TypedMiddleware<AppState, AddCompany>(addCompany),
    // TypedMiddleware<AppState, DeleteCompanyRequest>(deleteCompany),
    // TypedMiddleware<AppState, SetDefaultCompanyRequest>(setDefaultCompany),
    // TypedMiddleware<AppState, PurgeDataRequest>(purgeData),
    TypedMiddleware<AppState, ResendConfirmation>(resendConfirmation),
    TypedMiddleware<AppState, IsEmailConfirmed>(isEmailConfirmed),
    TypedMiddleware<AppState, SendEmailLinkRequest>(sendEmailLinkRequest),
    TypedMiddleware<AppState, EmailLinkLoginRequest>(emailLinkLoginRequest),
  ];
}

void _saveAuthLocal(String url) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(kSharedPrefUrl, formatApiUrl(url));
}

Middleware<AppState> _createUserLogout(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as UserLogout?;

    next(action);
    await repository.logout();
    store.dispatch(UnRegisterDeviceRequest());

    navigatorKey.currentState!.pushNamedAndRemoveUntil(
        ProjectConfig.defaultRouteForGuestUser,
        (Route<dynamic> route) => false);

    updateAuthState(store,
        userName: '',
        email: '',
        isArchived: false,
        isAdmin: false,
        currentUserId: '',
        setProfileCompleted: false);

    store.dispatch(UpdateCurrentRoute(ProjectConfig.defaultRouteForGuestUser));

    WidgetUtils.clearData();
  };
}

Middleware<AppState> _createLoginRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UserLoginRequest;

    // if (action.isDialogLogin) {
    //   store.dispatch(SetPopupLoginState(isDialogLogin: true));
    // }

    repository
        .login(email: action.email, password: action.password)
        .then((result) async {
      final loginResponse = result.loginResponse;
      final isEmailVerified = result.isEmailVerified;
      if (loginResponse.userCompanies.isNotEmpty) {
        final userName = result.userName;
        final email = result.email;
        final loggedInUserProfile = result.signedUpUserProfile;
        updateLoggedInUserProfile(store, loggedInUserProfile);
        final isPhoneVerified = await repository.checkPhoneVerificationStatus();
        if (isPhoneVerified != store.state.authState.phoneVerified) {
          store.dispatch(VerifyPhoneCodeSuccess(isVerified: isPhoneVerified));
        }
        final isEmailConfirmed = await repository.isEmailConfirmed();
        _saveAuthLocal(action.url);
        updateAuthState(store,
            userName: userName,
            currentUserId: loggedInUserProfile.id,
            email: email,
            isArchived: loggedInUserProfile.isArchived,
            isAdmin: loggedInUserProfile.isAdmin,
            setProfileCompleted: loggedInUserProfile.isProfileCompleted,
            isEmailVerified: isEmailConfirmed);
        // if (action.isDialogLogin) {
        //   store.dispatch(UserLoginSuccess());
        //   action.completer.complete();
        //   return;
        // }
        if (ProjectConfig.emailConfirmationEnabled && !isEmailVerified) {
          // if (!action.isDialogLogin) {
          store.dispatch(ViewMainScreen());
          // }
          store.dispatch(UserLoginSuccess());
          store.dispatch(
            LoadAccountSuccess(
              completer: action.completer,
              loginResponse: loginResponse,
            ),
          );
        } else {
          // Proceed with normal login flow
          store.dispatch(
            LoadAccountSuccess(
              completer: action.completer,
              loginResponse: loginResponse,
            ),
          );
        }

        store.dispatch(UserVerifiedPassword());
      } else {
        String message = ProjectConfig.accountIsDeletedMessageOnLogin;
        if (result.isDeleted == false) {
          message = 'Account not found';
        }
        showToast(message);
        action.completer.completeError(message);
        store.dispatch(UserLoginFailure(message));
      }
    }).catchError((Object error) {
      logError(' Login errors: $error');
      final message = _mapFirebaseErrorToMessage(error);
      showToast(message);
      action.completer.completeError(message);
      store.dispatch(UserLoginFailure(message));

      if ('$error'.startsWith('Error ::')) {
        throw error;
      }
    });

    next(action);
  };
}

Middleware<AppState> _createSendEmailLinkRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SendEmailLinkRequest;

    repository.sendEmailLink(email: action.email).then((_) {
      showToast('Email sent! Check your inbox and click the link to continue.');
      action.completer.complete();
    }).catchError((Object error) {
      logError('Send email link error: $error');
      final message = _mapFirebaseErrorToMessage(error);
      showToast(message);
      action.completer.completeError(message);

      if ('$error'.startsWith('Error ::')) {
        throw error;
      }
    });

    next(action);
  };
}

Middleware<AppState> _createEmailLinkLoginRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as EmailLinkLoginRequest;

    repository
        .loginOrCreateFromEmailLink(email: action.email)
        .then((result) async {
      final loginResponse = result.loginResponse;
      final isEmailVerified = result.isEmailVerified;
      if (loginResponse.userCompanies.isNotEmpty) {
        final userName = result.userName;
        final email = result.email;
        final loggedInUserProfile = result.signedUpUserProfile;
        updateLoggedInUserProfile(store, loggedInUserProfile);
        final isPhoneVerified = await repository.checkPhoneVerificationStatus();
        if (isPhoneVerified != store.state.authState.phoneVerified) {
          store.dispatch(VerifyPhoneCodeSuccess(isVerified: isPhoneVerified));
        }
        final isEmailConfirmed = await repository.isEmailConfirmed();
        _saveAuthLocal('');
        updateAuthState(store,
            userName: userName,
            currentUserId: loggedInUserProfile.id,
            email: email,
            isArchived: loggedInUserProfile.isArchived,
            isAdmin: loggedInUserProfile.isAdmin,
            setProfileCompleted: loggedInUserProfile.isProfileCompleted,
            isEmailVerified:
                ProjectConfig.appType == AppType.opw ? true : isEmailConfirmed);

        if ((ProjectConfig.appType == AppType.opw &&
                store.state.authState.isEmailLinkAuth) ||
            (ProjectConfig.emailConfirmationEnabled && !isEmailVerified)) {
          store.dispatch(ViewMainScreen());
          store.dispatch(UserLoginSuccess());
          store.dispatch(
            LoadAccountSuccess(
              completer: action.completer,
              loginResponse: loginResponse,
            ),
          );
        } else {
          store.dispatch(
            LoadAccountSuccess(
              completer: action.completer,
              loginResponse: loginResponse,
            ),
          );
        }

        store.dispatch(UserVerifiedPassword());

        if (ProjectConfig.appType == AppType.opw) {
          store.dispatch(RefreshData(
              completer: Completer<Null>()
                ..future.then<Null>((_) {
                  AppBuilder.of(navigatorKey.currentContext!)!.rebuild();
                  store.dispatch(UpdatedSetting());
                })));
        }

        Future.delayed(const Duration(seconds: 2), () {
          if (store.state.authState.isAuthenticated) {
            store.dispatch(SetEmailLinkAuthenticationEmail(email: ''));
          }
        });
      } else {
        String message = ProjectConfig.accountIsDeletedMessageOnLogin;
        if (result.isDeleted == false) {
          message = 'Account not found';
        }
        showToast(message);
        action.completer.completeError(message);
        store.dispatch(UserLoginFailure(message));
      }
    }).catchError((Object error) {
      logError('Email link login error: $error');
      final message = _mapFirebaseErrorToMessage(error);
      showToast(message);
      action.completer.completeError(message);
      store.dispatch(UserLoginFailure(message));

      if ('$error'.startsWith('Error ::')) {
        throw error;
      }
    });

    next(action);
  };
}

Middleware<AppState> _createChangePasswordRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as ChangePassword;

    repository
        .changePassword(
            currentPassword: action.oldPassword,
            newPassword: action.newPassword)
        .then((_) {
      store.dispatch(ChangePasswordSuccess());
      action.completer.complete(null);
      showToast('Password Changed successfully');
    }).catchError((Object error) {
      logError(' Change password error: $error');
      final message = _mapFirebaseErrorToMessage(error);
      showToast(message);
      if ('$error'.startsWith('Error ::')) {
        throw error;
      }
    });

    next(action);
  };
}

Middleware<AppState> _createSignUpRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as UserSignUpRequest;

    // if (action.isDialogLogin) {
    //   store.dispatch(SetPopupLoginState(isDialogLogin: true));
    // }

    repository
        .signUp(email: action.email, password: action.password)
        .then((result) {
      final signupResponse = result.loginResponse;
      final userName = result.userName;
      final email = result.email;

      _saveAuthLocal(kAppProductionUrl);

      final signedUpUserProfile = result.signedUpUserProfile;
      updateLoggedInUserProfile(store, signedUpUserProfile);

      final isProfileCompleted =
          ProjectConfig.onboardingQuestionsOnSignupDisabled ||
              signedUpUserProfile.isProfileCompleted;

      updateAuthState(store,
          userName: userName,
          currentUserId: signedUpUserProfile.id,
          email: email,
          isAdmin: false,
          setProfileCompleted: isProfileCompleted,
          isEmailVerified: !ProjectConfig.emailConfirmationEnabled);
      // if (action.isDialogLogin) {
      //   store.dispatch(UserLoginSuccess());
      //   action.completer.complete();
      //   return;
      // }
      if (ProjectConfig.emailConfirmationEnabled) {
        store.dispatch(ViewMainScreen());
        store.dispatch(UserLoginSuccess());
      } else {
        store.dispatch(
          LoadAccountSuccess(
            completer: action.completer,
            loginResponse: signupResponse,
          ),
        );
      }
      store.dispatch(UserVerifiedPassword());
    }).catchError((Object error) {
      logError(' Signup error: $error');
      final message = _mapFirebaseErrorToMessage(error);
      showToast(message);
      action.completer.completeError(message);
      store.dispatch(UserLoginFailure(message));
      if ('$error'.startsWith('Error ::')) {
        throw error;
      }
    });

    next(action);
  };
}

String _mapFirebaseErrorToMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'invalid-credential':
        return 'Email/Password is incorrect';
      default:
        return 'An unknown error occurred. Please try again later.';
    }
  }
  return 'Error : $error';
}

Middleware<AppState> _createOAuthLoginRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as OAuthLoginRequest;

    // if (action.isDialogLogin) {
    //   store.dispatch(SetPopupLoginState(isDialogLogin: true));
    // }

    repository
        .oauthLogin(
      idToken: action.idToken,
      accessToken: action.accessToken,
      url: action.url,
      secret: action.secret,
      provider: action.provider,
      platform: action.platform,
      authCode: action.authCode,
      email: action.email,
    )
        .then((result) async {
      final loginResponse = result.loginResponse;
      final userName = result.userName;
      final email = result.email;
      final loggedInUserProfile = result.loggedInUserProfile;
      final isEmailVerified = result.isEmailVerified;
      final isAdmin = result.isAdmin;

      updateLoggedInUserProfile(store, loggedInUserProfile);
      final isPhoneVerified = await repository.checkPhoneVerificationStatus();
      if (isPhoneVerified != store.state.authState.phoneVerified) {
        store.dispatch(VerifyPhoneCodeSuccess(isVerified: isPhoneVerified));
      }

      _saveAuthLocal(action.url);

      final isProfileCompleted =
          ProjectConfig.onboardingQuestionsOnSignupDisabled ||
              loggedInUserProfile.isProfileCompleted;

      updateAuthState(store,
          userName: userName,
          currentUserId: loggedInUserProfile.id,
          email: email,
          isArchived: loggedInUserProfile.isArchived,
          isAdmin: isAdmin,
          setProfileCompleted: isProfileCompleted,
          isEmailVerified: isEmailVerified);

      if (action.isDialogLogin) {
        store.dispatch(UserLoginSuccess());
        action.completer.complete();
        return;
      }

      store.dispatch(
        LoadAccountSuccess(
          completer: action.completer,
          loginResponse: loginResponse,
        ),
      );

      store.dispatch(UserVerifiedPassword());
    }).catchError((Object error) {
      logError(' Oauth login error: $error');
      final message = _mapFirebaseErrorToMessage(error);
      showToast(message);
      action.completer.completeError(message);
      store.dispatch(UserLoginFailure(message));

      if ('$error'.startsWith('Error ::')) {
        throw error;
      }
    });

    next(action);
  };
}

Middleware<AppState> _createRecoverRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as RecoverPasswordRequest;

    repository.resetPassword(email: action.email).then((data) {
      store.dispatch(RecoverPasswordSuccess());
      action.completer.complete(null);
    }).catchError((Object error) {
      store.dispatch(RecoverPasswordFailure(error.toString()));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _createRefreshRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    logInfo('RefreshData is requested');
    final action = dynamicAction as RefreshData;
    final state = store.state;

    if (action.clearData) {
      //
    } else {
      if (state.isSaving) {
        logInfo('Skipping refresh request - pending save');
        next(action);
        return;
      } else if (state.isLoading) {
        logInfo('Skipping refresh request - pending load');
        next(action);
        return;
      } else if (state.company.isLarge && !state.isLoaded) {
        logInfo(' Skipping refresh request - not loaded');
        next(action);
        return;
      }
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        formatApiUrl(prefs.getString(kSharedPrefUrl) ?? state.authState.url);

    // String token = 'Token';
    // bool hasToken = false;
    // if (state.userCompany.token.token.isNotEmpty) {
    //   token = state.userCompany.token.token;
    //   hasToken = true;
    // } else {
    //   token = //TokenEntity.unobscureToken(prefs.getString(kSharedPrefToken)) ??
    //       'TOKEN';
    // }

    // final updatedAt = action.clearData
    //     ? 0
    //     : ((state.userCompanyState.lastUpdated - kMillisecondsToRefreshData) /
    //             1000)
    //         .round();

    store.dispatch(UserLoadUrl(url: url));
    try {
      final userId = getLoggedInUserId(store);
      final loggedInUserProfile = await repository
          .getCurrentUserProfile(userId.isNotEmpty ? userId : null);

      if (loggedInUserProfile == null) {
        if (!(ProjectConfig.appType == AppType.opw &&
            store.state.authState.isEmailLinkAuth)) {
          store.dispatch(UserLogout());
        }
        return;
      }

      updateLoggedInUserProfile(store, loggedInUserProfile);

      if (store.state.authState.phoneVerified) {
        store.dispatch(VerifyPhoneCodeSuccess(
            isVerified: store.state.authState.phoneVerified));
      }

      repository.refresh().then((data) {
        bool permissionsWereChanged = false;
        data.userCompanies.forEach((userCompany) {
          state.userCompanyStates.forEach((userCompanyState) {
            if (userCompany.company.id == userCompanyState.company.id) {
              if (userCompanyState.userCompany.permissionsUpdatedAt > 0 &&
                  userCompany.permissionsUpdatedAt !=
                      userCompanyState.userCompany.permissionsUpdatedAt) {
                permissionsWereChanged = true;
              }
            }
          });
        });

        if (permissionsWereChanged && !action.clearData) {
          store.dispatch(
              RefreshData(completer: action.completer, clearData: true));
        } else {
          if (action.clearData) {
            store.dispatch(ClearData());
          }

          final updatedUser = data.userCompanies.first.user
              .rebuild((b) => b..id = loggedInUserProfile.id);
          final updatedUserCompany = data.userCompanies.first
              .rebuild((b) => b..user = updatedUser.toBuilder());
          final updatedData =
              data.rebuild((b) => b..userCompanies[0] = updatedUserCompany);
          store.dispatch(RefreshDataSuccess(
            completer: action.completer,
            data: updatedData,
          ));

          loadDynamicFieldQuestions(ProjectConfig.onBoardingQuestionType);
        }

        AppBuilder.of(navigatorKey.currentContext!)!.rebuild();
      }).catchError((Object error) {
        if ('$error'.startsWith('403') || '$error'.startsWith('429')) {
          if (!(ProjectConfig.appType == AppType.opw &&
              store.state.authState.isEmailLinkAuth)) {
            store.dispatch(UserLogout());
          }
        } else {
          final message = _parseError('$error');
          if (action.completer != null) {
            action.completer!.completeError(message);
          }

          store.dispatch(RefreshDataFailure(message));

          if ('$error'.startsWith('Error ::')) {
            throw error;
          }
        }
      });
    } catch (e) {
      logError('Error fetching current user data: $e');
      if (!(ProjectConfig.appType == AppType.opw &&
          store.state.authState.isEmailLinkAuth)) {
        store.dispatch(UserLogout());
      }
    }
    next(action);
  };
}

String _parseError(String error) {
  const errorPattern = 'failed due to: Deserializing';
  if (error.contains(errorPattern)) {
    final lastIndex = error.lastIndexOf(errorPattern);
    final secondToLastIndex = secondToLastIndexOf(error, errorPattern);
    error = 'Error :: ' +
        error
            .substring(
                (secondToLastIndex >= 0 ? secondToLastIndex : lastIndex) +
                    errorPattern.length)
            .trim();
  } else if (error.toLowerCase().contains('no host specified')) {
    error = 'An error occurred, please check the URL is correct';
  } else if (error.contains('404')) {
    error += ', you may need to add /public to the URL';
  }

  return error;
}

Middleware<AppState> _checkProfileCompletion(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as CheckProfileCompletionRequest;
    final context = action.context;

    // if (store.state.authState.isDialogLogin) {
    //   logInfo('Skipping profile completion check for popup login');
    //   action.completer?.complete();
    //   next(action);
    //   return;
    // }

    try {
      logInfo('Checking profile completion...');
      final bool isProfileCompleted =
          store.state.authState.setProfileCompleted ||
              store.state.profileState.loggedInUserProfile.isProfileCompleted;
      final bool isUserArchived =
          store.state.profileState.loggedInUserProfile.isArchived;

      RoutingRules.profileCompletionRouting(
          isUserArchived, isProfileCompleted, context, action);

      action.completer?.complete();
    } catch (error) {
      logError(' Error checking profile completion: $error');
      store.dispatch(CheckProfileCompletionFailure(error));
      createEntityByType(
        context: context,
        entityType: EntityType.profile,
      );

      action.completer?.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _checkExistingProfileByEmail(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as CheckExistingProfileByEmailRequest;

    try {
      final result = await repository.checkExistingProfileByEmail(action.email);

      if (result.error != null) {
        store.dispatch(CheckExistingProfileByEmailFailure(result.error!));
        action.completer?.completeError(result.error!);
      } else {
        final hasProfile = result.hasProfile;
        final user = result.userData;
        final profile = result.profile;

        store.dispatch(CheckExistingProfileByEmailSuccess(
          hasProfile: hasProfile,
          user: user,
          profile: profile,
        ));

        if (hasProfile && profile != null) {
          store.dispatch(SetLoggedInUserProfile(profile));
          store.dispatch(UpdateAuthStateAction(
            currentUserName: profile.name.isNotEmpty
                ? profile.name
                : user?['userName'] ?? '',
            currentUserId: profile.id,
            email: action.email,
            isArchived: profile.isArchived,
            isAdmin: profile.isAdmin,
            setProfileCompleted: profile.isProfileCompleted,
            isEmailVerified: true,
          ));

          if (profile.isProfileCompleted) {
            if (ProjectConfig.appType == AppType.opw) {
              store.dispatch(LoadEvents());
            }
            RoutingRules.defaultEntityLoadingRouting();
          } else {
            Navigator.of(action.context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CreateProfileOpw(),
              ),
            );
          }
        } else {
          Navigator.of(action.context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CreateProfileOpw(),
            ),
          );
        }

        action.completer?.complete();
      }
    } catch (error) {
      logError('Error checking existing profile by email: $error');
      store.dispatch(CheckExistingProfileByEmailFailure(error));
      action.completer?.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _updateProfileCompletionStatus(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as UpdateProfileCompletionStatus;
    try {
      final userId = getLoggedInUserId(store);

      await repository.markProfileComplete(userId);

      store.dispatch(UpdateProfileCompletionStatusSuccess());
      action.completer.complete();
    } catch (error) {
      logError(' Error updating profile completion status: $error');
      store.dispatch(UpdateProfileCompletionStatusFailure(error));
      action.completer.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _createSendPhoneVerificationCode(
    AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as SendPhoneVerificationCodeRequest;
    repository.sendPhoneVerificationCode(
      phoneNumber: action.phoneNumber,
      onCodeSent: (String verificationId) {
        store.dispatch(
            SendPhoneVerificationCodeSuccess(verificationId: verificationId));
        action.completer.complete(verificationId);
      },
      onVerificationFailed: (FirebaseAuthException error) {
        logError(' Phone verification failed: ${error.message}');
        store.dispatch(SendPhoneVerificationCodeFailure(
            error.message ?? 'Verification failed'));
        action.completer.completeError(error.message ?? 'Verification failed');
      },
      onVerificationCompleted: (PhoneAuthCredential credential) {
        // Auto-verification completed (rare on most devices)
        logInfo('Auto verification completed');
      },
    );

    next(action);
  };
}

Middleware<AppState> _createVerifyPhoneCode(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as VerifyPhoneCodeRequest;

    try {
      await repository.verifyPhoneCode(
        verificationId: action.verificationId,
        smsCode: action.smsCode,
      );

      await repository.updatePhoneVerificationStatus(isVerified: true);

      store.dispatch(VerifyPhoneCodeSuccess(isVerified: true));
      action.completer.complete();
    } catch (error) {
      logError(' Phone code verification failed: $error');
      store.dispatch(VerifyPhoneCodeFailure(error));
      action.completer.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _updatePhoneVerificationStatus(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as UpdatePhoneVerificationStatus;
    try {
      await repository.updatePhoneVerificationStatus(
        isVerified: action.isVerified,
      );

      store.dispatch(UpdatePhoneVerificationStatusSuccess());
      action.completer.complete();
    } catch (error) {
      logError(' Update phone verification status failed: $error');
      store.dispatch(UpdatePhoneVerificationStatusFailure(error));
      action.completer.completeError(error);
    }

    next(action);
  };
}

Middleware<AppState> _isEmailConfirmed(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as IsEmailConfirmed;
    try {
      final response = await repository.isEmailConfirmed();
      final signInUser = repository.getCurrentUser();
      final userMap = repository.userToMap(signInUser);
      final loginResponse =
          await repository.getLoginResponse(userMap) as LoginResponse;
      if (response) {
        store.dispatch(IsEmailConfirmedSuccess());
        store.dispatch(
          LoadAccountSuccess(
            completer: action.completer,
            loginResponse: loginResponse,
          ),
        );
        logInfo('Email verification status success');
      } else {
        store.dispatch(IsEmailConfirmedFailure('email confirmation failed'));
        logError(' Email verification status failed');
      }
      action.completer.complete();
    } catch (error) {
      store.dispatch(
          IsEmailConfirmedFailure('email confirmation failed => $error'));
      action.completer.complete();
      logError(' Email verification status failed: $error');
    }

    next(action);
  };
}

Middleware<AppState> _resendConfirmation(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction,
      NextDispatcher next) async {
    final action = dynamicAction as ResendConfirmation;

    try {
      final response = await repository.sendConfirmationEmail();
      if (response) {
        store.dispatch(ResendConfirmationSuccess());
      }
    } catch (error) {
      store.dispatch(
          ResendConfirmationFailure('email confirmation failed => $error'));
      logError(' Email verification status failed: $error');
    }

    next(action);
  };
}

Middleware<AppState> _createPhoneAuthRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as PhoneAuthRequest;

    if (!ProjectConfig.enablePhoneLogin()) {
      action.completer.completeError('Phone authentication is not enabled');
      return;
    }

    // if (action.isDialogLogin) {
    //   store.dispatch(SetPopupLoginState(isDialogLogin: true));
    // }

    bool isCompleted = false;

    repository.verifyPhoneNumber(action.phoneNumber).then((verificationId) {
      store.dispatch(PhoneVerificationSuccess(
        verificationId: verificationId,
        phoneNumber: action.phoneNumber,
      ));

      showDialog<String>(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => PhoneVerificationDialog(
          phoneNumber: action.phoneNumber,
          verificationId: verificationId,
          isSignUp: false,
          onVerificationComplete: (smsCode) async {
            try {
              final result = await repository.phoneSignUp(
                phoneNumber: action.phoneNumber,
                verificationId: verificationId,
                smsCode: smsCode,
              );

              final loginResponse = result.loginResponse;
              final userProfile = result.signedUpUserProfile;

              updateLoggedInUserProfile(store, userProfile);

              final userName = userProfile.name.isNotEmpty
                  ? userProfile.name
                  : result.userName;

              final userEmail = result.email;
              final hasEmail = userEmail.isNotEmpty;
              final isEmailVerified = !ProjectConfig.emailConfirmationEnabled ||
                  !hasEmail ||
                  (hasEmail && await repository.isEmailConfirmed());

              final isProfileCompleted =
                  ProjectConfig.onboardingQuestionsOnSignupDisabled ||
                      userProfile.isProfileCompleted;

              updateAuthState(store,
                  userName: userName,
                  currentUserId: userProfile.id,
                  email: userEmail,
                  isArchived: userProfile.isArchived,
                  isAdmin: userProfile.isAdmin,
                  setProfileCompleted: isProfileCompleted,
                  isEmailVerified: isEmailVerified);

              store.dispatch(LoadAccountSuccess(
                completer: action.completer,
                loginResponse: loginResponse,
              ));

              return smsCode;
            } catch (error) {
              throw error;
            }
          },
        ),
      ).then((smsCode) {
        if (smsCode != null && !isCompleted) {
          isCompleted = true;
          // if (action.isDialogLogin ) {
          //   action.completer.complete();
          // }
        }
      }).catchError((error) {
        if (!isCompleted) {
          logError('Phone auth error: $error');
          final errorMessage = _mapPhoneErrorToMessage(error);
          showToast(errorMessage);
          isCompleted = true;
          action.completer.completeError(errorMessage);
          store.dispatch(UserLoginFailure(errorMessage));
        }
      });
    }).catchError((error) {
      if (!isCompleted) {
        logError(' Phone verification error: $error');
        final errorMessage = _mapPhoneErrorToMessage(error);
        showToast(errorMessage);
        isCompleted = true;
        action.completer.completeError(errorMessage);
        store.dispatch(UserLoginFailure(errorMessage));
      }
    });

    next(action);
  };
}

String _mapPhoneErrorToMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-phone-number':
        return 'The phone number is not valid.';
      case 'missing-phone-number':
        return 'The phone number is missing.';
      case 'quota-exceeded':
        return 'The phone verification quota has been exceeded.';
      case 'too-many-requests':
        return 'Too many verification attempts. Please try again later.';
      case 'invalid-app-credential':
        return 'Verification failed. Please try again.';
      case 'invalid-verification-code':
        return 'The verification code is incorrect.';
      case 'invalid-verification-id':
        return 'Verification session expired. Please try again.';
      default:
        return 'An error occurred during phone verification. Please try again.';
    }
  }
  return 'Error: $error';
}
