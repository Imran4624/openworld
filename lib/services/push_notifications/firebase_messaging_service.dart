import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/notification/notification_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    
    try {
      await _initializeLocalNotifications();
      
      if (kIsWeb) {
        try {
          String? token = await _firebaseMessaging.getToken(
            vapidKey: Config.VAPID_KEY,
          );
          
          if (token != null) {
            logInfo('Web FCM Token: ${token.substring(0, 20)}...');
            store.dispatch(SaveFcmTokenRequest(fcmToken: token));
          }
        } catch (e) {
          logError('Error getting web FCM token: $e');
        }
      } else {
        NotificationSettings settings = await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          logInfo('User granted notification permission');
        } else {
          logInfo('User declined or has not accepted notification permission');
        }

        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          logInfo('Mobile FCM Token: ${token.substring(0, 20)}...');
          if (context.mounted) {
            store.dispatch(SaveFcmTokenRequest(fcmToken: token));
          }
        }
        
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          if (context.mounted) {
            store.dispatch(SaveFcmTokenRequest(fcmToken: newToken));
          }
        });

        RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
        if (initialMessage != null) {
          _handleMessage(initialMessage);
        }

        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logInfo('Message data: ${message.data}');

        if (message.notification != null) {
          logInfo('Message body: ${message.notification}');
          
          _showLocalNotification(message);
        }
      });
      
    } catch (e) {
      logError('Error initializing Firebase Messaging: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        logInfo('Notification tapped: ${response.payload}');
      },
    );

    if (!kIsWeb) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications', 
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? 'You have a new message',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  void _handleMessage(RemoteMessage message) {
    logInfo('A new message was opened!');
    logInfo('Message data: ${message.data}');
    
    if (message.notification != null) {
      logInfo('Message notification: ${message.notification?.title}');
    }
    
    // Add your navigation logic here based on message.data
    // For example:
    // if (message.data.containsKey('route')) {
    //   Navigator.pushNamed(context, message.data['route']);
    // }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (!kIsWeb) {  
      await _firebaseMessaging.subscribeToTopic(topic);
      logInfo('Subscribed to topic: $topic');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (!kIsWeb) { 
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      logInfo('Unsubscribed from topic: $topic');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logInfo("Handling a background message: ${message.messageId}");
  logInfo('Message data: ${message.data}');
  
  if (message.notification != null) {
    logInfo('Message notification: ${message.notification?.title}');
  }
}