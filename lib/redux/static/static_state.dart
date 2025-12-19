// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

part 'static_state.g.dart';

abstract class StaticState implements Built<StaticState, StaticStateBuilder> {
  factory StaticState() {
    return _$StaticState._(
      currencyMap: BuiltMap<String, CurrencyEntity>(),
      sizeMap: BuiltMap<String, SizeEntity>(),
      industryMap: BuiltMap<String, IndustryEntity>(),
      timezoneMap: BuiltMap<String, TimezoneEntity>(),
      dateFormatMap: BuiltMap<String, DateFormatEntity>(),
      languageMap: BuiltMap<String, LanguageEntity>(),
      countryMap: BuiltMap<String, CountryEntity>(),
      templateMap: BuiltMap<String, TemplateEntity>(),
      bulkUpdates: BuiltMap<String, BuiltList<String>>(),
    );
  }

  StaticState._();

  @override
  @memoized
  int get hashCode;

  int? get updatedAt;

  bool get isLoaded => updatedAt != null && updatedAt! > 0;

  bool get isStale {
    if (!isLoaded) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch - updatedAt! >
        kMillisecondsToRefreshStaticData;
  }

  BuiltMap<String, CurrencyEntity> get currencyMap;

  BuiltMap<String, SizeEntity> get sizeMap;

  BuiltMap<String, IndustryEntity> get industryMap;

  BuiltMap<String, TimezoneEntity> get timezoneMap;

  BuiltMap<String, DateFormatEntity> get dateFormatMap;

  BuiltMap<String, LanguageEntity> get languageMap;

  BuiltMap<String, CountryEntity> get countryMap;

  BuiltMap<String, TemplateEntity> get templateMap;

  BuiltMap<String, BuiltList<String>> get bulkUpdates;

  // ignore: unused_element
  static void _initializeBuilder(StaticStateBuilder builder) =>
      builder..bulkUpdates.replace(BuiltMap<String, List<String>>());

  static Serializer<StaticState> get serializer => _$staticStateSerializer;
}
