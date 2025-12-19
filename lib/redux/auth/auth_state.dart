// Package imports:
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';

part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  factory AuthState({String? url, String? referralCode}) {
    return _$AuthState._(
      email: '',
      currentUserName: '',
      currentUserId: '',
      url: url ?? '',
      isAuthenticated: false,
      isInitialized: false,
      phoneVerified: false,
      isEmailVerified: false,
      setProfileCompleted: false,
      isArchived: false,
      phoneVerificationId: '',
      isAdmin: false,
      lastEnteredPasswordAt: 0,
      referralCode: referralCode ?? '',
      isDialogLogin: false,
      emailLinkAuthEmail: '',
      isEmailLinkAuth: false,
      originator: OriginatorType.defaultType.value,
    );
  }

  AuthState._();

  @override
  @memoized
  int get hashCode;

  String get email;

  String get currentUserName;

  String get currentUserId;

  String get url;

  bool get isInitialized;

  bool get isAdmin;

  bool get isAuthenticated;

  int get lastEnteredPasswordAt;

  String get referralCode;

  bool get phoneVerified;

  bool get isEmailVerified;

  bool get setProfileCompleted;

  bool get isArchived;

  String get phoneVerificationId;

  bool get isDialogLogin;

  String get emailLinkAuthEmail;

  bool get isEmailLinkAuth;

  String get originator;

  bool get isHosted {
    final cleanUrl = cleanApiUrl(url);

    if (cleanUrl.isEmpty) {
      return true;
    }

    if ([
      kAppProductionUrl,
      kFlutterDemoUrl,
      kAppStagingUrl,
      kAppStagingNetUrl,
    ].contains(cleanUrl)) {
      return true;
    }

    // Handle if a user logs in with their subdomain
    if (cleanUrl.endsWith('.invoicing.co')) {
      return true;
    }

    return false;
  }

  bool get isSelfHost => !isHosted;

  bool get isStaging => cleanApiUrl(url) == kAppStagingUrl;

  bool get isStagingNet => cleanApiUrl(url) == kAppStagingNetUrl;

  bool get isLargeTest => cleanApiUrl(url) == kAppLargeTestUrl;

  // ignore: unused_element
  static void _initializeBuilder(AuthStateBuilder builder) => builder
    ..referralCode = ''
    ..phoneVerified = false
    ..isEmailVerified = false
    ..setProfileCompleted = false
    ..isArchived = false
    ..phoneVerificationId = ''
    ..isDialogLogin = false
    ..emailLinkAuthEmail = ''
    ..isEmailLinkAuth = false
    ..originator = OriginatorType.defaultType.value;

  static Serializer<AuthState> get serializer => _$authStateSerializer;
}
