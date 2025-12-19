// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:memoize/memoize.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/static/font_model.dart';

var memoizedCountryList = memo1(
    (BuiltMap<String, CountryEntity> countryMap) => countryList(countryMap));

List<String?> countryList(BuiltMap<String, CountryEntity> countryMap) {
  final list = countryMap.keys.toList();

  list.sort((idA, idB) => countryMap[idA]!
      .listDisplayName
      .compareTo(countryMap[idB]!.listDisplayName));

  return list;
}

var memoizedCountryIso2Map = memo1(
    (BuiltMap<String, CountryEntity> countryMap) => countryIso2Map(countryMap));

Map<String, CountryEntity> countryIso2Map(
    BuiltMap<String, CountryEntity> countryMap) {
  final map = <String, CountryEntity>{};
  countryMap.keys.forEach((countryId) {
    final country = countryMap[countryId]!;
    map[country.iso2] = country;
  });
  return map;
}

var memoizedLanguageList = memo1(
    (BuiltMap<String, LanguageEntity> languageMap) =>
        languageList(languageMap));

List<String?> languageList(BuiltMap<String, LanguageEntity> languageMap) {
  final list = languageMap.keys.toList();

  list.sort((idA, idB) => languageMap[idA]!
      .listDisplayName
      .compareTo(languageMap[idB]!.listDisplayName));

  return list;
}

var memoizedCurrencyList = memo1(
    (BuiltMap<String, CurrencyEntity> currencyMap) =>
        currencyList(currencyMap));

List<String?> currencyList(BuiltMap<String, CurrencyEntity> currencyMap) {
  final list = currencyMap.keys.toList();

  list.sort((idA, idB) => currencyMap[idA]!
      .listDisplayName
      .compareTo(currencyMap[idB]!.listDisplayName));

  return list;
}

var memoizedTimezoneList = memo1(
    (BuiltMap<String, TimezoneEntity> timezoneMap) =>
        timezoneList(timezoneMap));

List<String?> timezoneList(BuiltMap<String, TimezoneEntity> timezoneMap) {
  final list = timezoneMap.keys.toList();

  list.sort((idA, idB) => timezoneMap[idA]!
      .listDisplayName
      .compareTo(timezoneMap[idB]!.listDisplayName));

  return list;
}

var memoizedDateFormatList = memo1(
    (BuiltMap<String, DateFormatEntity> dateFormatMap) =>
        dateFormatList(dateFormatMap));

List<String?> dateFormatList(BuiltMap<String, DateFormatEntity> dateFormatMap) {
  final list = dateFormatMap.keys.toList();

  list.sort((idA, idB) => dateFormatMap[idA]!
      .listDisplayName
      .compareTo(dateFormatMap[idB]!.listDisplayName));

  return list;
}

var memoizedIndustryList = memo1(
    (BuiltMap<String?, IndustryEntity?> industryMap) =>
        industryList(industryMap));

List<String?> industryList(BuiltMap<String?, IndustryEntity?> industryMap) {
  final list = industryMap.keys.toList();

  list.sort((idA, idB) => industryMap[idA]!
      .listDisplayName
      .compareTo(industryMap[idB]!.listDisplayName));

  return list;
}

var memoizedSizeList =
    memo1((BuiltMap<String, SizeEntity> sizeMap) => sizeList(sizeMap));

List<String?> sizeList(BuiltMap<String, SizeEntity> sizeMap) {
  final list = sizeMap.keys.toList();

  list.sort((idA, idB) => sizeMap[idA]!.id.compareTo(sizeMap[idB]!.id));

  return list;
}

var memoizedFontMap = memo1((List<dynamic> fontList) => fontMap(fontList));

BuiltMap<String, SelectableEntity> fontMap(List<dynamic> fonts) {
  return BuiltMap<String, SelectableEntity>.from(
      Map<String?, SelectableEntity>.fromIterable(fonts,
          key: (dynamic v) => v['value'],
          value: (dynamic v) => FontEntity(id: v['value'], name: v['label'])));
}
