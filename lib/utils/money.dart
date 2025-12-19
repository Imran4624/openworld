// Package imports:
import 'package:built_collection/built_collection.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/static/currency_model.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

double getExchangeRate(BuiltMap<String, CurrencyEntity>? currencyMap,
    {String? fromCurrencyId, String? toCurrencyId}) {
  if ((fromCurrencyId ?? '').isEmpty || (toCurrencyId ?? '').isEmpty) {
    return 1;
  }
  final fromCurrency = currencyMap![fromCurrencyId];
  final toCurrency = currencyMap[toCurrencyId];
  // TODO replace with data from server
  final baseCurrency = currencyMap[kCurrencyUSDollar];

  if (fromCurrencyId == null) {
    logError(' Error currency $fromCurrencyId not found');
    return 1;
  }

  if (toCurrencyId == null) {
    logError(' Error currency $toCurrencyId not found');
    return 1;
  }

  if (fromCurrency == baseCurrency) {
    return toCurrency!.exchangeRate;
  }

  if (toCurrency == baseCurrency) {
    return 1 / (fromCurrency?.exchangeRate ?? 1);
  }

  return toCurrency!.exchangeRate * (1 / fromCurrency!.exchangeRate);
}
