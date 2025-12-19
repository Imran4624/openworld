// Package imports:
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_version_model.g.dart';

abstract class AppVersionEntity
    implements Built<AppVersionEntity, AppVersionEntityBuilder> {
  factory AppVersionEntity([void Function(AppVersionEntityBuilder) updates]) =
      _$AppVersionEntity;

  AppVersionEntity._();

  @override
  @memoized
  int get hashCode;

  String get latest;

  String get minimum;

  @BuiltValueField(wireName: 'update_url')
  String get updateUrl;

  @BuiltValueField(wireName: 'release_notes')
  String get releaseNotes;

  @BuiltValueField(wireName: 'is_update_required')
  bool get isUpdateRequired;

  @BuiltValueField(wireName: 'maintenance_mode')
  bool get maintenanceMode;

  @BuiltValueField(wireName: 'maintenance_message')
  String get maintenanceMessage;

  @BuiltValueField(wireName: 'feature_flags')
  Map<String, dynamic> get featureFlags;

  static Serializer<AppVersionEntity> get serializer =>
      _$appVersionEntitySerializer;
} 