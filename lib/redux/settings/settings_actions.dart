// Dart imports:
import 'dart:async';

// Flutter imports:

// Package imports:
import 'package:http/http.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/company_model.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/settings_model.dart';
import 'package:flutter_boilerplate/data/models/user_model.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';

class ViewSettings implements PersistUI {
  ViewSettings({
    this.company,
    this.user,
    this.force = false,
    this.clearFilter = false,
    this.section,
    this.tabIndex,
  });

  final CompanyEntity? company;
  final UserEntity? user;
  final bool force;
  final String? section;
  final bool clearFilter;
  final int? tabIndex;

  @override
  String toString() {
    return 'ViewSettings';
  }
}

class ClearSettingsFilter implements PersistUI {
  @override
  String toString() {
    return 'ClearSettingsFilter';
  }
}

class ResetSettings {
  @override
  String toString() {
    return 'ResetSettings';
  }
}

class UpdateSettings implements PersistUI {
  UpdateSettings({required this.settings});

  final SettingsEntity settings;

  @override
  String toString() {
    return 'UpdateSettings';
  }
}

class UpdateSettingsTab implements PersistUI {
  UpdateSettingsTab({required this.tabIndex});

  final int tabIndex;

  @override
  String toString() {
    return 'UpdateSettingsTab';
  }
}

class UpdatedSetting implements PersistUI {
  @override
  String toString() {
    return 'UpdatedSetting';
  }
}

class UpdatedSettingUI implements PersistUI {
  @override
  String toString() {
    return 'UpdatedSettingUI';
  }
}

class UpdateSettingsTemplate implements PersistUI {
  UpdateSettingsTemplate({required this.selectedTemplate});

  final EmailTemplate selectedTemplate;

  @override
  String toString() {
    return 'UpdateSettingsTemplate';
  }
}

class UpdateUserSettings implements PersistUI {
  UpdateUserSettings({required this.user});

  final UserEntity user;

  @override
  String toString() {
    return 'UpdateUserSettings';
  }
}

class UploadLogoRequest implements StartSaving {
  UploadLogoRequest({this.completer, required this.multipartFile, this.type});

  final Completer? completer;
  final MultipartFile multipartFile;
  final EntityType? type;

  @override
  String toString() {
    return 'UploadLogoRequest';
  }
}

class UploadLogoFailure implements StopSaving {
  UploadLogoFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'UploadLogoFailure{error: $error}';
  }
}

class SaveUserSettingsRequest implements StartSaving {
  SaveUserSettingsRequest({
    required this.completer,
    required this.user,
  });

  final Completer completer;
  final UserEntity user;

  @override
  String toString() {
    return 'SaveUserSettingsRequest';
  }
}

class SaveUserSettingsSuccess implements StopSaving, PersistData, PersistUI {
  SaveUserSettingsSuccess(this.userCompany);

  final UserCompanyEntity userCompany;

  @override
  String toString() {
    return 'SaveUserSettingsSuccess';
  }
}

class SaveUserSettingsFailure implements StopSaving {
  SaveUserSettingsFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveUserSettingsFailure{error: $error}';
  }
}

class SaveAuthUserRequest implements StartSaving {
  SaveAuthUserRequest({
    required this.user,
    this.completer,
    this.password,
    this.idToken,
  });

  final Completer? completer;
  final UserEntity user;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'SaveAuthUserRequest';
  }
}

class SaveAuthUserSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  SaveAuthUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'SaveAuthUserSuccess';
  }
}

class SaveAuthUserFailure implements StopSaving {
  SaveAuthUserFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveAuthUserFailure{error: $error}';
  }
}

class ConnecOAuthUserRequest implements StartSaving {
  ConnecOAuthUserRequest({
    required this.provider,
    required this.idToken,
    required this.accessToken,
    this.completer,
    this.password,
  });

  final Completer? completer;
  final String provider;
  final String? password;
  final String idToken;
  final String accessToken;

  @override
  String toString() {
    return 'ConnecOAuthUserRequest';
  }
}

class ConnectOAuthUserSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  ConnectOAuthUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'ConnectOAuthUserSuccess';
  }
}

class ConnecOAuthUserFailure implements StopSaving {
  ConnecOAuthUserFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'ConnecOAuthUserFailure{error: $error}';
  }
}

class DisconnecOAuthUserRequest implements StartSaving {
  DisconnecOAuthUserRequest({
    required this.user,
    required this.idToken,
    required this.completer,
    required this.password,
  });

  final UserEntity? user;
  final Completer completer;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'DisconnecOAuthUserRequest';
  }
}

class DisconnectOAuthUserSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  DisconnectOAuthUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'DisconnectOAuthUserSuccess';
  }
}

class DisconnecOAuthUserFailure implements StopSaving {
  DisconnecOAuthUserFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'DisconnecOAuthUserFailure{error: $error}';
  }
}

class DisconnectOAuthMailerRequest implements StartSaving {
  DisconnectOAuthMailerRequest({
    required this.completer,
    required this.idToken,
    required this.password,
    required this.user,
  });
  final Completer completer;
  final String? password;
  final String? idToken;
  final UserEntity? user;

  @override
  String toString() {
    return 'DisconnectOAuthMailerRequest';
  }
}

class DisconnectOAuthMailerSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  DisconnectOAuthMailerSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'DisconnectOAuthMailerSuccess';
  }
}

class DisconnectOAuthMailerFailure implements StopSaving {
  DisconnectOAuthMailerFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'DisconnectOAuthMailerFailure{error: $error}';
  }
}

class DisableTwoFactorRequest implements StartSaving {
  DisableTwoFactorRequest({
    required this.completer,
    required this.idToken,
    required this.password,
  });

  final Completer completer;
  final String? password;
  final String? idToken;

  @override
  String toString() {
    return 'DisableTwoFactorRequest';
  }
}

class DisableTwoFactorSuccess
    implements StopSaving, PersistData, UserVerifiedPassword {
  @override
  String toString() {
    return 'DisableTwoFactorSuccess';
  }
}

class DisableTwoFactorFailure implements StopSaving {
  DisableTwoFactorFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'DisableTwoFactorFailure{error: $error}';
  }
}

class ConnecGmailUserRequest implements StartSaving {
  ConnecGmailUserRequest({
    required this.serverAuthCode,
    required this.idToken,
    this.completer,
    this.password,
  });

  final Completer? completer;
  final String idToken;
  final String? password;
  final String serverAuthCode;

  @override
  String toString() {
    return 'ConnecGmailUserRequest';
  }
}

class ConnecGmailUserSuccess
    implements StopSaving, PersistData, PersistUI, UserVerifiedPassword {
  ConnecGmailUserSuccess(this.user);

  final UserEntity user;

  @override
  String toString() {
    return 'ConnecGmailUserSuccess';
  }
}

class ConnecGmailUserFailure implements StopSaving {
  ConnecGmailUserFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'ConnecGmailUserFailure{error: $error}';
  }
}

class FilterSettings implements PersistUI {
  FilterSettings(this.filter);

  final String? filter;

  @override
  String toString() {
    return 'FilterSettings';
  }
}

class ToggleShowNewSettings {
  @override
  String toString() {
    return 'ToggleShowNewSettings';
  }
}

class ToggleShowPdfPreview {
  @override
  String toString() {
    return 'ToggleShowPdfPreview';
  }
}
