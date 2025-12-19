// Package imports:
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

part 'settings_state.g.dart';

abstract class SettingsUIState extends Object
    implements Built<SettingsUIState, SettingsUIStateBuilder> {
  factory SettingsUIState(
      {CompanyEntity? company,
      UserEntity? user,
      CompanyEntity? origCompany,
      UserEntity? origUser,
      String? section}) {
    return _$SettingsUIState._(
      company: company ?? CompanyEntity(),
      user: user ?? UserEntity(),
      entityType: EntityType.company,
      origCompany: origCompany ?? CompanyEntity(),
      origUser: origUser ?? UserEntity(),
      isChanged: false,
      showNewSettings: false,
      showPdfPreview: false,
      updatedAt: 0,
      filterClearedAt: 0,
      tabIndex: 0,
      selectedTemplate: EmailTemplate.invoice,
      section: section ?? kSettingsDeviceSettings,
    );
  }

  SettingsUIState._();

  @override
  @memoized
  int get hashCode;

  CompanyEntity get company;

  CompanyEntity get origCompany;

  UserEntity get user;

  UserEntity get origUser;

  EntityType get entityType;

  bool get isChanged;

  int get updatedAt;

  String get section;

  int get tabIndex;

  EmailTemplate get selectedTemplate;

  String? get filter;

  int get filterClearedAt;

  bool get showNewSettings;

  bool get showPdfPreview;

  bool get isFiltered => entityType != EntityType.company;

  SettingsEntity get settings {
    return company.settings;
  }

  // ignore: unused_element
  static void _initializeBuilder(SettingsUIStateBuilder builder) => builder
    ..selectedTemplate = EmailTemplate.invoice
    ..showNewSettings = false
    ..showPdfPreview = false;

  static Serializer<SettingsUIState> get serializer =>
      _$settingsUIStateSerializer;
}
