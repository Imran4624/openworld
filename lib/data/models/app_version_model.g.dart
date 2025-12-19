// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppVersionEntity> _$appVersionEntitySerializer =
    new _$AppVersionEntitySerializer();

class _$AppVersionEntitySerializer
    implements StructuredSerializer<AppVersionEntity> {
  @override
  final Iterable<Type> types = const [AppVersionEntity, _$AppVersionEntity];
  @override
  final String wireName = 'AppVersionEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, AppVersionEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'latest',
      serializers.serialize(object.latest,
          specifiedType: const FullType(String)),
      'minimum',
      serializers.serialize(object.minimum,
          specifiedType: const FullType(String)),
      'update_url',
      serializers.serialize(object.updateUrl,
          specifiedType: const FullType(String)),
      'release_notes',
      serializers.serialize(object.releaseNotes,
          specifiedType: const FullType(String)),
      'is_update_required',
      serializers.serialize(object.isUpdateRequired,
          specifiedType: const FullType(bool)),
      'maintenance_mode',
      serializers.serialize(object.maintenanceMode,
          specifiedType: const FullType(bool)),
      'maintenance_message',
      serializers.serialize(object.maintenanceMessage,
          specifiedType: const FullType(String)),
      'feature_flags',
      serializers.serialize(object.featureFlags,
          specifiedType: const FullType(
              Map, const [const FullType(String), const FullType(dynamic)])),
    ];

    return result;
  }

  @override
  AppVersionEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppVersionEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'latest':
          result.latest = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'minimum':
          result.minimum = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'update_url':
          result.updateUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'release_notes':
          result.releaseNotes = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'is_update_required':
          result.isUpdateRequired = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'maintenance_mode':
          result.maintenanceMode = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'maintenance_message':
          result.maintenanceMessage = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'feature_flags':
          result.featureFlags = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ]))! as Map<String, dynamic>;
          break;
      }
    }

    return result.build();
  }
}

class _$AppVersionEntity extends AppVersionEntity {
  @override
  final String latest;
  @override
  final String minimum;
  @override
  final String updateUrl;
  @override
  final String releaseNotes;
  @override
  final bool isUpdateRequired;
  @override
  final bool maintenanceMode;
  @override
  final String maintenanceMessage;
  @override
  final Map<String, dynamic> featureFlags;

  factory _$AppVersionEntity(
          [void Function(AppVersionEntityBuilder)? updates]) =>
      (new AppVersionEntityBuilder()..update(updates))._build();

  _$AppVersionEntity._(
      {required this.latest,
      required this.minimum,
      required this.updateUrl,
      required this.releaseNotes,
      required this.isUpdateRequired,
      required this.maintenanceMode,
      required this.maintenanceMessage,
      required this.featureFlags})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        latest, r'AppVersionEntity', 'latest');
    BuiltValueNullFieldError.checkNotNull(
        minimum, r'AppVersionEntity', 'minimum');
    BuiltValueNullFieldError.checkNotNull(
        updateUrl, r'AppVersionEntity', 'updateUrl');
    BuiltValueNullFieldError.checkNotNull(
        releaseNotes, r'AppVersionEntity', 'releaseNotes');
    BuiltValueNullFieldError.checkNotNull(
        isUpdateRequired, r'AppVersionEntity', 'isUpdateRequired');
    BuiltValueNullFieldError.checkNotNull(
        maintenanceMode, r'AppVersionEntity', 'maintenanceMode');
    BuiltValueNullFieldError.checkNotNull(
        maintenanceMessage, r'AppVersionEntity', 'maintenanceMessage');
    BuiltValueNullFieldError.checkNotNull(
        featureFlags, r'AppVersionEntity', 'featureFlags');
  }

  @override
  AppVersionEntity rebuild(void Function(AppVersionEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppVersionEntityBuilder toBuilder() =>
      new AppVersionEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppVersionEntity &&
        latest == other.latest &&
        minimum == other.minimum &&
        updateUrl == other.updateUrl &&
        releaseNotes == other.releaseNotes &&
        isUpdateRequired == other.isUpdateRequired &&
        maintenanceMode == other.maintenanceMode &&
        maintenanceMessage == other.maintenanceMessage &&
        featureFlags == other.featureFlags;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, latest.hashCode);
    _$hash = $jc(_$hash, minimum.hashCode);
    _$hash = $jc(_$hash, updateUrl.hashCode);
    _$hash = $jc(_$hash, releaseNotes.hashCode);
    _$hash = $jc(_$hash, isUpdateRequired.hashCode);
    _$hash = $jc(_$hash, maintenanceMode.hashCode);
    _$hash = $jc(_$hash, maintenanceMessage.hashCode);
    _$hash = $jc(_$hash, featureFlags.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppVersionEntity')
          ..add('latest', latest)
          ..add('minimum', minimum)
          ..add('updateUrl', updateUrl)
          ..add('releaseNotes', releaseNotes)
          ..add('isUpdateRequired', isUpdateRequired)
          ..add('maintenanceMode', maintenanceMode)
          ..add('maintenanceMessage', maintenanceMessage)
          ..add('featureFlags', featureFlags))
        .toString();
  }
}

class AppVersionEntityBuilder
    implements Builder<AppVersionEntity, AppVersionEntityBuilder> {
  _$AppVersionEntity? _$v;

  String? _latest;
  String? get latest => _$this._latest;
  set latest(String? latest) => _$this._latest = latest;

  String? _minimum;
  String? get minimum => _$this._minimum;
  set minimum(String? minimum) => _$this._minimum = minimum;

  String? _updateUrl;
  String? get updateUrl => _$this._updateUrl;
  set updateUrl(String? updateUrl) => _$this._updateUrl = updateUrl;

  String? _releaseNotes;
  String? get releaseNotes => _$this._releaseNotes;
  set releaseNotes(String? releaseNotes) => _$this._releaseNotes = releaseNotes;

  bool? _isUpdateRequired;
  bool? get isUpdateRequired => _$this._isUpdateRequired;
  set isUpdateRequired(bool? isUpdateRequired) =>
      _$this._isUpdateRequired = isUpdateRequired;

  bool? _maintenanceMode;
  bool? get maintenanceMode => _$this._maintenanceMode;
  set maintenanceMode(bool? maintenanceMode) =>
      _$this._maintenanceMode = maintenanceMode;

  String? _maintenanceMessage;
  String? get maintenanceMessage => _$this._maintenanceMessage;
  set maintenanceMessage(String? maintenanceMessage) =>
      _$this._maintenanceMessage = maintenanceMessage;

  Map<String, dynamic>? _featureFlags;
  Map<String, dynamic>? get featureFlags => _$this._featureFlags;
  set featureFlags(Map<String, dynamic>? featureFlags) =>
      _$this._featureFlags = featureFlags;

  AppVersionEntityBuilder();

  AppVersionEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latest = $v.latest;
      _minimum = $v.minimum;
      _updateUrl = $v.updateUrl;
      _releaseNotes = $v.releaseNotes;
      _isUpdateRequired = $v.isUpdateRequired;
      _maintenanceMode = $v.maintenanceMode;
      _maintenanceMessage = $v.maintenanceMessage;
      _featureFlags = $v.featureFlags;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppVersionEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppVersionEntity;
  }

  @override
  void update(void Function(AppVersionEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppVersionEntity build() => _build();

  _$AppVersionEntity _build() {
    final _$result = _$v ??
        new _$AppVersionEntity._(
            latest: BuiltValueNullFieldError.checkNotNull(
                latest, r'AppVersionEntity', 'latest'),
            minimum: BuiltValueNullFieldError.checkNotNull(
                minimum, r'AppVersionEntity', 'minimum'),
            updateUrl: BuiltValueNullFieldError.checkNotNull(
                updateUrl, r'AppVersionEntity', 'updateUrl'),
            releaseNotes: BuiltValueNullFieldError.checkNotNull(
                releaseNotes, r'AppVersionEntity', 'releaseNotes'),
            isUpdateRequired: BuiltValueNullFieldError.checkNotNull(
                isUpdateRequired, r'AppVersionEntity', 'isUpdateRequired'),
            maintenanceMode: BuiltValueNullFieldError.checkNotNull(
                maintenanceMode, r'AppVersionEntity', 'maintenanceMode'),
            maintenanceMessage: BuiltValueNullFieldError.checkNotNull(
                maintenanceMessage, r'AppVersionEntity', 'maintenanceMessage'),
            featureFlags: BuiltValueNullFieldError.checkNotNull(
                featureFlags, r'AppVersionEntity', 'featureFlags'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
