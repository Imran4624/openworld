// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class WebUtils {
  static String? get apiUrl => null;

  static String? get browserUrl => null;

  static String? get browserRoute => null;

  static String get browserPathname => '';

  static String? getHtmlValue(String field) => null;

  static Map<String, String> getUrlParameters() => <String, String>{};

  static void _parseQueryString(String queryString, Map<String, String> params) {}

  static String? getUrlParameter(String paramName) => null;

  static bool isRoute(String route) => false;

  static void downloadTextFile(String filename, String data) {}

  static void downloadBinaryFile(String filename, Uint8List data) {}

  static void reloadBrowser() {}

  static void registerWebView(String? html) {}

  static void warnChanges(Store<AppState>? store) {}

  static void addPopStateListener(VoidCallback callback) {}

  static void updateBrowserUrl(String url) {}

  static void microsoftLogin(
    Function(String, String) successCallback,
    Function(dynamic) failureCallback,
  ) async {}

/*
  static String loadToken() => null;

  static void saveToken(String token) {}
   */
}
