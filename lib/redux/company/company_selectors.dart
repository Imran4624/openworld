// Package imports:
import 'package:memoize/memoize.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/company/company_state.dart';

var memoizedHasMultipleCurrencies =
    memo1((CompanyEntity? company) => hasMultipleCurrencies(company));

bool hasMultipleCurrencies(CompanyEntity? company) =>
    memoizedGetCurrencyIds(company).length > 1;

var memoizedGetCurrencyIds =
    memo1((CompanyEntity? company) => getCurrencyIds(company!));

List<String> getCurrencyIds(CompanyEntity company) {
  final currencyIds = <String>[company.currencyId];

  if (currencyIds.isEmpty) {
    return [kCurrencyUSDollar];
  } else if (currencyIds.length > 1) {
    return [kCurrencyAll, ...currencyIds];
  } else {
    return currencyIds;
  }
}

var memoizedFilteredSelector = memo2((String? filter, UserCompanyState state) =>
    filteredSelector(filter, state));

List<BaseEntity> filteredSelector(String? filter, UserCompanyState state) {
  final List<BaseEntity> list = [];
  // ..addAll(state.productState.list
  //     .map((productId) => state.productState.map[productId]!)
  //     .where((product) {
  //   return product.matchesFilter(filter);
  // }).toList())

  list.sort((BaseEntity? entityA, BaseEntity? entityB) {
    return entityA!.listDisplayName.compareTo(entityB!.listDisplayName);
  });

  return list;
}

String localeSelector(AppState state, {bool twoLetter = false}) {
  var languageId = state.company.languageId;
  if (state.user.languageId.isNotEmpty) {
    languageId = state.user.languageId;
  }

  final languageMap = state.staticState.languageMap;
  final locale = languageMap[languageId]?.locale ?? 'en';

  // https://github.com/flutter/flutter/issues/32090
  if (locale == 'mk_MK' || locale == 'sq') {
    return 'en';
  } else if (twoLetter) {
    return locale.split('_').first;
  } else {
    return locale;
  }
}

String clientPortalUrlSelector(AppState state, {String route = 'login'}) {
  const String url = 'test_url_add_logic';
  return url;
}
