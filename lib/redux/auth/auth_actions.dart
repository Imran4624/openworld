// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class LoadStateRequest {
  LoadStateRequest(this.context);

  final BuildContext context;

  @override
  String toString() {
    return 'LoadStateRequest';
  }
}

class LoadStateSuccess {
  LoadStateSuccess(this.state);

  final AppState state;

  @override
  String toString() {
    return 'LoadStateSuccess';
  }
}

class OAuthLoginRequest implements StartLoading {
  OAuthLoginRequest({
    required this.completer,
    required this.url,
    required this.secret,
    required this.platform,
    required this.provider,
    required this.oneTimePassword,
    this.idToken,
    this.accessToken,
    this.authCode,
    this.email,
    this.isDialogLogin = false,
  });

  final Completer completer;
  final String? email; // TODO remove this property, break up _saveAuthLocal
  final String? idToken;
  final String? accessToken;
  final String url;
  final String secret;
  final String platform;
  final String provider;
  final String oneTimePassword;
  final String? authCode;
  final bool isDialogLogin;

  @override
  String toString() {
    return 'OAuthLoginRequest';
  }
}

class UserLoadUrl {
  UserLoadUrl({this.url});

  final String? url;

  @override
  String toString() {
    return 'UserLoadUrl';
  }
}

class UserLoginRequest implements StartLoading {
  UserLoginRequest({
    required this.completer,
    required this.email,
    required this.password,
    required this.url,
    required this.secret,
    required this.platform,
    required this.oneTimePassword,
    this.isDialogLogin = false,
  });

  final Completer completer;
  final String email;
  final String password;
  final String url;
  final String secret;
  final String platform;
  final String oneTimePassword;
  final bool isDialogLogin;

  @override
  String toString() {
    return 'UserLoginRequest';
  }
}

class UserLoginSuccess implements StopLoading {
  @override
  String toString() {
    return 'UserLoginSuccess';
  }
}

class UserLoginFailure implements StopLoading {
  UserLoginFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'UserLoginFailure{error: $error}';
  }
}

class RecoverPasswordRequest implements StartLoading {
  RecoverPasswordRequest({
    required this.completer,
    required this.email,
    required this.url,
    required this.secret,
  });

  final Completer completer;
  final String email;
  final String url;
  final String secret;

  @override
  String toString() {
    return 'RecoverPasswordRequest';
  }
}

class UpdateAuthStateAction {
  UpdateAuthStateAction({
    required this.currentUserName,
    required this.currentUserId,
    required this.email,
    required this.isArchived,
    required this.setProfileCompleted,
    required this.isAdmin,
    this.isEmailVerified,
  });
  final String currentUserName;
  final String currentUserId;
  final String email;
  final bool isArchived;
  final bool setProfileCompleted;
  final bool isAdmin;
  final bool? isEmailVerified;

  @override
  String toString() {
    return 'UpdateAuthStateAction';
  }
}

class SetPopupLoginState {
  SetPopupLoginState({required this.isDialogLogin});
  final bool isDialogLogin;

  @override
  String toString() {
    return 'SetPopupLoginState';
  }
}

class RecoverPasswordSuccess implements StopLoading {
  @override
  String toString() {
    return 'RecoverPasswordSuccess';
  }
}

class RecoverPasswordFailure implements StopLoading {
  RecoverPasswordFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'RecoverPasswordFailure{error: $error}';
  }
}

class UserLogout implements PersistData, PersistUI {
  @override
  String toString() {
    return 'UserLogout';
  }
}

class SetOriginator implements PersistUI {
  SetOriginator(this.originator);

  final String originator;

  @override
  String toString() {
    return 'SetOriginator{originator: $originator}';
  }
}

class UserLogoutAll implements StartLoading {
  const UserLogoutAll({this.completer});

  final Completer? completer;

  @override
  String toString() {
    return 'UserLogoutAll';
  }
}

class UserLogoutAllSuccess implements StopLoading {
  @override
  String toString() {
    return 'UserLogoutAllSuccess';
  }
}

class UserLogoutAllFailure implements StopLoading {
  const UserLogoutAllFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'UserLogoutAllFailure{error: $error}';
  }
}

class UserSignUpRequest implements StartLoading {
  UserSignUpRequest({
    required this.completer,
    required this.email,
    required this.password,
    this.isDialogLogin = false,
  });

  final Completer completer;
  final String email;
  final String password;
  final bool isDialogLogin;

  @override
  String toString() {
    return 'UserSignUpRequest';
  }
}

class ChangePassword implements StartLoading {
  ChangePassword({
    required this.completer,
    required this.oldPassword,
    required this.newPassword,
  });

  final Completer completer;
  final String oldPassword;
  final String newPassword;

  @override
  String toString() {
    return 'ChangePassword';
  }
}

class OAuthSignUpRequest implements StartLoading {
  OAuthSignUpRequest({
    required this.url,
    required this.completer,
    required this.provider,
    required this.idToken,
    this.accessToken,
    this.firstName,
    this.lastName,
  });

  final Completer completer;
  final String? idToken;
  final String url;
  final String? accessToken;
  final String provider;
  final String? firstName;
  final String? lastName;

  @override
  String toString() {
    return 'OAuthSignUpRequest';
  }
}

class UserVerifiedPassword {
  @override
  String toString() {
    return 'UserVerifiedPassword';
  }
}

class UserUnverifiedPassword {
  @override
  String toString() {
    return 'UserUnverifiedPassword';
  }
}

class CheckProfileCompletionRequest {
  CheckProfileCompletionRequest({
    this.completer,
    required this.context,
    required this.isSignUp,
  });

  final Completer? completer;
  final BuildContext context;
  final bool isSignUp;

  @override
  String toString() {
    return 'CheckProfileCompletionRequest';
  }
}

class CheckExistingProfileByEmailRequest implements StartLoading {
  CheckExistingProfileByEmailRequest({
    required this.email,
    required this.context,
    this.completer,
  });

  final String email;
  final BuildContext context;
  final Completer? completer;

  @override
  String toString() {
    return 'CheckExistingProfileByEmailRequest{email: $email}';
  }
}

class CheckProfileCompletionSuccess implements StopLoading {
  CheckProfileCompletionSuccess({
    required this.isProfileCompleted,
  });

  final bool isProfileCompleted;

  @override
  String toString() {
    return 'CheckProfileCompletionSuccess';
  }
}

class CheckProfileCompletionFailure implements StopLoading {
  CheckProfileCompletionFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'CheckProfileCompletionFailure{error: $error}';
  }
}

class CheckExistingProfileByEmailSuccess implements StopLoading {
  CheckExistingProfileByEmailSuccess({
    required this.hasProfile,
    this.user,
    this.profile,
  });

  final bool hasProfile;
  final Map<String, dynamic>? user;
  final dynamic profile;

  @override
  String toString() {
    return 'CheckExistingProfileByEmailSuccess{hasProfile: $hasProfile}';
  }
}

class CheckExistingProfileByEmailFailure implements StopLoading {
  CheckExistingProfileByEmailFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'CheckExistingProfileByEmailFailure{error: $error}';
  }
}

class UpdateProfileCompletionStatus {
  UpdateProfileCompletionStatus({
    required this.completer,
  });

  final Completer completer;

  @override
  String toString() {
    return 'UpdateProfileCompletionStatus';
  }
}

class UpdateProfileCompletionStatusSuccess implements StopLoading {
  @override
  String toString() {
    return 'UpdateProfileCompletionStatusSuccess';
  }
}

class SetArchivedUserStatus {
  SetArchivedUserStatus(this.isArchived);
  final bool isArchived;

  @override
  String toString() {
    return 'SetArchivedUserStatus';
  }
}

class UpdateProfileCompletionStatusFailure implements StopLoading {
  UpdateProfileCompletionStatusFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'UpdateProfileCompletionStatusFailure{error: $error}';
  }
}

class SendPhoneVerificationCodeRequest implements StartLoading {
  SendPhoneVerificationCodeRequest({
    required this.completer,
    required this.phoneNumber,
  });

  final Completer completer;
  final String phoneNumber;

  @override
  String toString() {
    return 'SendPhoneVerificationCodeRequest';
  }
}

class SendPhoneVerificationCodeSuccess implements StopLoading {
  SendPhoneVerificationCodeSuccess({
    required this.verificationId,
  });

  final String verificationId;

  @override
  String toString() {
    return 'SendPhoneVerificationCodeSuccess';
  }
}

class SendPhoneVerificationCodeFailure implements StopLoading {
  SendPhoneVerificationCodeFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SendPhoneVerificationCodeFailure{error: $error}';
  }
}

class VerifyPhoneCodeRequest implements StartLoading {
  VerifyPhoneCodeRequest({
    required this.completer,
    required this.verificationId,
    required this.smsCode,
  });

  final Completer completer;
  final String verificationId;
  final String smsCode;

  @override
  String toString() {
    return 'VerifyPhoneCodeRequest';
  }
}

class VerifyPhoneCodeSuccess implements StopLoading {
  VerifyPhoneCodeSuccess({this.isVerified = false});
  final bool isVerified;

  @override
  String toString() {
    return 'VerifyPhoneCodeSuccess';
  }
}

class VerifyPhoneCodeFailure implements StopLoading {
  VerifyPhoneCodeFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'VerifyPhoneCodeFailure{error: $error}';
  }
}

class UpdatePhoneVerificationStatus implements StartLoading {
  UpdatePhoneVerificationStatus({
    required this.completer,
    required this.isVerified,
  });

  final Completer completer;
  final bool isVerified;

  @override
  String toString() {
    return 'UpdatePhoneVerificationStatus';
  }
}

class UpdatePhoneVerificationStatusSuccess implements StopLoading {
  @override
  String toString() {
    return 'UpdatePhoneVerificationStatusSuccess';
  }
}

class UpdatePhoneVerificationStatusFailure implements StopLoading {
  UpdatePhoneVerificationStatusFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'UpdatePhoneVerificationStatusFailure{error: $error}';
  }
}

class PhoneAuthRequest implements StartLoading {
  PhoneAuthRequest({
    required this.completer,
    required this.phoneNumber,
    this.url,
    this.secret,
    this.isDialogLogin = false,
  });

  final Completer completer;
  final String phoneNumber;
  final String? url;
  final String? secret;
  final bool isDialogLogin;

  @override
  String toString() {
    return 'PhoneAuthRequest';
  }
}

class PhoneVerificationSuccess {
  PhoneVerificationSuccess({
    required this.verificationId,
    required this.phoneNumber,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  String toString() {
    return 'PhoneVerificationSuccess';
  }
}

class SetEmailLinkAuthenticationEmail {
  SetEmailLinkAuthenticationEmail({required this.email});

  final String email;

  @override
  String toString() {
    return 'SetEmailLinkAuthenticationEmail{email: $email}';
  }
}

class SendEmailLinkRequest implements StartLoading {
  SendEmailLinkRequest({
    required this.completer,
    required this.email,
  });

  final Completer completer;
  final String email;

  @override
  String toString() {
    return 'SendEmailLinkRequest{email: $email}';
  }
}

class EmailLinkLoginRequest implements StartLoading {
  EmailLinkLoginRequest({
    required this.completer,
    required this.email,
  });

  final Completer completer;
  final String email;

  @override
  String toString() {
    return 'EmailLinkLoginRequest{email: $email}';
  }
}