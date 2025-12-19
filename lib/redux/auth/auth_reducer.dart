// Package imports:
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/auth/auth_state.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/services/analytics_manager.dart';

final _analytics = AnalyticsManager();

Reducer<AuthState> authReducer = combineReducers([
  TypedReducer<AuthState, UserLoadUrl>(userLoadUrlReducer),
  TypedReducer<AuthState, UserLoginRequest>(userLoginRequestReducer),
  TypedReducer<AuthState, UpdateAuthStateAction>(updateAuthStateReducer),
  TypedReducer<AuthState, SetPopupLoginState>(setPopupLoginStateReducer),
  TypedReducer<AuthState, ChangePassword>(changePasswordReducer),
  TypedReducer<AuthState, OAuthLoginRequest>(oauthLoginRequestReducer),
  TypedReducer<AuthState, OAuthSignUpRequest>(oauthSignUpRequestReducer),
  TypedReducer<AuthState, UserSignUpRequest>(userSignUpRequestReducer),
  TypedReducer<AuthState, UserLoginSuccess>(userLoginSuccessReducer),
  TypedReducer<AuthState, UserVerifiedPassword>(userVerifiedPasswordReducer),
  TypedReducer<AuthState, SendPhoneVerificationCodeSuccess>(
      sendPhoneVerificationCodeSuccessReducer),
  TypedReducer<AuthState, VerifyPhoneCodeSuccess>(
      verifyPhoneCodeSuccessReducer),
  TypedReducer<AuthState, UpdatePhoneVerificationStatusSuccess>(
      updatePhoneVerificationStatusSuccessReducer),
  TypedReducer<AuthState, UpdateProfileCompletionStatusSuccess>(
      isProfileCompleted),
  TypedReducer<AuthState, SetArchivedUserStatus>(setArchivedUserStatus),
  TypedReducer<AuthState, IsEmailConfirmedSuccess>(setEmailConfirmationSuccess),
  TypedReducer<AuthState, UserUnverifiedPassword>(
      userUnverifiedPasswordReducer),
  TypedReducer<AuthState, SetEmailLinkAuthenticationEmail>(
      setEmailLinkAuthenticationEmailReducer),
  TypedReducer<AuthState, SetOriginator>(setOriginatorReducer),
]);

AuthState userLoadUrlReducer(AuthState authState, UserLoadUrl action) {
  return authState.rebuild((b) => b..url = formatApiUrl(action.url));
}

AuthState userSignUpRequestReducer(
    AuthState authState, UserSignUpRequest action) {
  return authState.rebuild((b) => b..url = formatApiUrl(kAppProductionUrl));
}

AuthState isProfileCompleted(
    AuthState authState, UpdateProfileCompletionStatusSuccess action) {
  return authState.rebuild((b) => b..setProfileCompleted = true);
}

AuthState setArchivedUserStatus(
    AuthState authState, SetArchivedUserStatus action) {
  return authState.rebuild((b) => b..isArchived = action.isArchived);
}

AuthState setEmailConfirmationSuccess(
    AuthState authState, IsEmailConfirmedSuccess action) {
  return authState.rebuild((b) => b..isEmailVerified = true);
}

AuthState userLoginRequestReducer(
    AuthState authState, UserLoginRequest action) {
  return authState.rebuild((b) => b
    ..url = formatApiUrl(action.url)
    ..email = action.email);
}

AuthState setPopupLoginStateReducer(
    AuthState authState, SetPopupLoginState action) {
  return authState.rebuild((b) => b..isDialogLogin = action.isDialogLogin);
}

AuthState updateAuthStateReducer(
    AuthState authState, UpdateAuthStateAction action) {
  return authState.rebuild((b) => b
    ..currentUserName = action.currentUserName
    ..currentUserId = action.currentUserId
    ..isArchived = action.isArchived
    ..setProfileCompleted = action.setProfileCompleted
    ..email = action.email
    ..isEmailVerified = action.isEmailVerified
    ..isAdmin = action.isAdmin);
}

AuthState changePasswordReducer(AuthState authState, ChangePassword action) {
  return authState.rebuild((b) => b);
}

AuthState oauthLoginRequestReducer(
    AuthState authState, OAuthLoginRequest action) {
  return authState.rebuild((b) => b..url = formatApiUrl(action.url));
}

AuthState oauthSignUpRequestReducer(
    AuthState authState, OAuthSignUpRequest action) {
  return authState.rebuild((b) => b..url = formatApiUrl(kAppProductionUrl));
}

AuthState userLoginSuccessReducer(
    AuthState authState, UserLoginSuccess action) {
  final userEmail = authState.email;
  if (userEmail.isNotEmpty) {
    _analytics.setUserId(userEmail);
    _analytics.setUserProperties(
      userType: 'authenticated',
      registrationDate: DateTime.now()
          .toIso8601String()
          .substring(0, 10),
      customProperties: {
        'login_method':
            'standard', 
      },
    );
  }

  return authState.rebuild((b) => b
    ..isAuthenticated = true
    ..isDialogLogin = authState.isDialogLogin);
}

AuthState userVerifiedPasswordReducer(
    AuthState authState, UserVerifiedPassword action) {
  return authState.rebuild(
      (b) => b..lastEnteredPasswordAt = DateTime.now().millisecondsSinceEpoch);
}

AuthState userUnverifiedPasswordReducer(
    AuthState authState, UserUnverifiedPassword action) {
  return authState.rebuild((b) => b..lastEnteredPasswordAt = 0);
}

AuthState sendPhoneVerificationCodeSuccessReducer(
    AuthState authState, SendPhoneVerificationCodeSuccess action) {
  return authState
      .rebuild((b) => b..phoneVerificationId = action.verificationId);
}

AuthState verifyPhoneCodeSuccessReducer(
    AuthState authState, VerifyPhoneCodeSuccess action) {
  return authState.rebuild((b) => b..phoneVerified = action.isVerified);
}

AuthState updatePhoneVerificationStatusSuccessReducer(
    AuthState authState, UpdatePhoneVerificationStatusSuccess action) {
  return authState;
}

AuthState setEmailLinkAuthenticationEmailReducer(
    AuthState authState, SetEmailLinkAuthenticationEmail action) {
  return authState.rebuild((b) => b
    ..emailLinkAuthEmail = action.email
    ..isEmailLinkAuth = true);
}

AuthState setOriginatorReducer(AuthState authState, SetOriginator action) {
  return authState.rebuild((b) => b..originator = action.originator);
}
