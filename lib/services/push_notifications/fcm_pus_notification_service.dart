import 'dart:convert';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/services/push_notifications/service_account.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
// import 'package:flutter_boilerplate/services/push_notifications/service_account.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  ServiceAccountCredentials? _credentials;
  String? _cachedAccessToken;
  DateTime? _tokenExpiry;
  bool _initialized = false;

  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      _credentials =
          ServiceAccountCredentials.fromJson(jsonDecode(serviceAccountJson));
      _initialized = true;
      return true;
    } catch (e) {
      logError('Error initializing FCM service: $e');
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    if (!_initialized) {
      final initialized = await initialize();
      if (!initialized) return null;
    }

    if (_cachedAccessToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now().add(Duration(minutes: 5)))) {
      return _cachedAccessToken;
    }

    try {
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(_credentials!, scopes);

      _cachedAccessToken = client.credentials.accessToken.data;
      _tokenExpiry = client.credentials.accessToken.expiry;

      return _cachedAccessToken;
    } catch (e) {
      logError('Error getting FCM access token: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    bool isWebToken = false,
  }) async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        return {
          'success': false,
          'error': 'Failed to get FCM API access token'
        };
      }

      final message = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
        }
      };

      if (isWebToken) {
        message['message']?['webpush'] = {
          'headers': {
            'Urgency': 'high',
          },
          'notification': {
            'icon': 'https://yourapp.com/icon.png',
          },
          'fcm_options': {
            'link': 'https://yourapp.com',
          }
        };
      }

      message['message']?['android'] = {
        'priority': 'high',
        'notification': {
          'click_action': '3',
          'sound': 'default',
          'channel_id': 'high_importance_channel'
        }
      };

      if (data != null && data!.containsKey('route')) {
        message['message']?['data'] = {
          ...message['message']?['data'] as Map<String, dynamic>,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'route': data['route'],
        };
      }

      message['message']?['apns'] = {
        'headers': {
          'apns-priority': '10',
        },
        'payload': {
          'aps': {'sound': 'default', 'badge': 1, 'content-available': 1}
        }
      };

      const projectId = Config.PROJECT_ID;
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'response': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': response.body,
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  bool isWebToken(String token) {
    return token.contains('http') || token.startsWith('{');
  }
}
