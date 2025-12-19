import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/project_config.dart';

class AnalyticsManager {
  static final AnalyticsManager _instance = AnalyticsManager._internal();
  factory AnalyticsManager() => _instance;
  AnalyticsManager._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  bool get _isAnalyticsEnabled => ProjectConfig.enableGoogleAnalytics;

  void _logEvent(String eventName, Map<String, Object>? parameters) {
    if (!_isAnalyticsEnabled) return;

    final Map<String, Object> eventParameters = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'app_version': Config.APP_VERSION, 
      'platform': 'flutter',
    };

    if (parameters != null) {
      final Map<String, Object> convertedParameters = {};
      for (final entry in parameters.entries) {
        if (entry.value is bool) {
          convertedParameters[entry.key] = entry.value.toString();
        } else if (entry.value is String || entry.value is num) {
          convertedParameters[entry.key] = entry.value;
        } else {
          convertedParameters[entry.key] = entry.value.toString();
        }
      }
      eventParameters.addAll(convertedParameters);
    }

    _analytics.logEvent(name: eventName, parameters: eventParameters);
  }


  void setUserId(String? userId) {
    if (!_isAnalyticsEnabled) return;
    _analytics.setUserId(id: userId);
  }

  void setUserProperties({
    String? userType,
    String? membershipLevel,
    String? registrationDate,
    Map<String, String>? customProperties,
  }) {
    if (!_isAnalyticsEnabled) return;

    if (userType != null) {
      _analytics.setUserProperty(name: 'user_type', value: userType);
    }
    if (membershipLevel != null) {
      _analytics.setUserProperty(
          name: 'membership_level', value: membershipLevel);
    }
    if (registrationDate != null) {
      _analytics.setUserProperty(
          name: 'registration_date', value: registrationDate);
    }

    if (customProperties != null) {
      for (final entry in customProperties.entries) {
        _analytics.setUserProperty(name: entry.key, value: entry.value);
      }
    }
  }

  void setUserProperty(String name, String value) {
    if (!_isAnalyticsEnabled) return;
    _analytics.setUserProperty(name: name, value: value);
  }


  void trackEventViewed({
    required String eventId,
    required String eventName,
    Map<String, Object>? additionalParameters,
  }) {
    _logEvent('view_event', {
      'item_id': eventId,
      'item_name': eventName,
      'item_category': 'event',
      ...?additionalParameters,
    });
  }

  void trackPurchaseProcessStarted({
    required String eventId,
    Map<String, Object>? additionalParameters,
  }) {
    _logEvent('purchase_process_started', {
      'item_id': eventId,
      'item_name': 'event_ticket',
      'item_category': 'event',
      'action': 'purchase_process_started',
      ...?additionalParameters,
    });
  }

  void trackPurchaseButtonClicked({
    required String eventId,
    required double price,
    String currency = "USD",
    Map<String, Object>? additionalParameters,
  }) {
    _logEvent('purchase_button_clicked', {
      'item_id': eventId,
      'item_name': 'event_ticket',
      'item_category': 'event',
      'price': price,
      'currency': currency,
      'action': 'purchase_button_clicked',
      ...?additionalParameters,
    });
  }

  void trackTicketPurchaseCompleted({
    required String eventId,
    required String transactionId,
    required double price,
    required int quantity,
    String currency = "USD",
    Map<String, Object>? additionalParameters,
  }) {
    _logEvent('ticket_purchase_completed', {
      'item_id': eventId,
      'item_name': 'event_ticket',
      'item_category': 'event',
      'price': price,
      'quantity': quantity,
      'currency': currency,
      'transaction_id': transactionId,
      'action': 'purchase_completed',
      ...?additionalParameters,
    });
  }

  void trackEventSearch({
    required String searchTerm,
    int? resultCount,
    Map<String, Object>? additionalParameters,
  }) {
    _logEvent('search_events', {
      'search_term': searchTerm,
      'result_count': resultCount ?? 0,
      ...?additionalParameters,
    });
  }


  void trackScreenView(String screenName, {String? screenClass}) {
    if (!_isAnalyticsEnabled) return;
    _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  void trackPurchase({
    required double value,
    required String currency,
    String? transactionId,
    List<AnalyticsEventItem>? items,
    Map<String, Object>? parameters,
  }) {
    if (!_isAnalyticsEnabled) return;

    final Map<String, Object> eventParameters = {
      'value': value,
      'currency': currency,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    if (transactionId != null) {
      eventParameters['transaction_id'] = transactionId;
    }

    if (parameters != null) {
      eventParameters.addAll(parameters);
    }

    _analytics.logPurchase(
      value: value,
      currency: currency,
      items: items,
      parameters: eventParameters,
    );
  }

  void trackViewItem({
    required String itemId,
    required String itemName,
    String? itemCategory,
    double? value,
    String currency = "USD",
  }) {
    if (!_isAnalyticsEnabled) return;

    final Map<String, Object> parameters = {
      'item_id': itemId,
      'item_name': itemName,
      'currency': currency,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    if (itemCategory != null) {
      parameters['item_category'] = itemCategory;
    }

    if (value != null) {
      parameters['value'] = value;
    }

    _analytics.logEvent(
      name: 'view_item',
      parameters: parameters,
    );
  }

  void trackAddToCart({
    required String itemId,
    required String itemName,
    String? itemCategory,
    double? value,
    String currency = "USD",
    int quantity = 1,
  }) {
    if (!_isAnalyticsEnabled) return;

    final Map<String, Object> parameters = {
      'item_id': itemId,
      'item_name': itemName,
      'currency': currency,
      'quantity': quantity,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    if (itemCategory != null) {
      parameters['item_category'] = itemCategory;
    }

    if (value != null) {
      parameters['value'] = value;
    }

    _analytics.logEvent(
      name: 'add_to_cart',
      parameters: parameters,
    );
  }

  void trackCustomEvent(String eventName, Map<String, Object>? parameters) {
    _logEvent(eventName, parameters);
  }

  void resetAnalyticsData() {
    if (!_isAnalyticsEnabled) return;
    _analytics.resetAnalyticsData();
  }

}
