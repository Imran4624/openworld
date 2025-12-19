import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/repositories/firebase_repository.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class LoggingRepository {
  const LoggingRepository();

  static final FirebaseRepository _firebaseRepository =
      FirebaseRepository(kLoggingCollectionName);

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const Uuid _uuid = Uuid();

  static String? _deviceId;

  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(kSharedPrefDeviceId);
      if (stored != null && stored.isNotEmpty) {
        _deviceId = stored;
        return _deviceId!;
      }

      if (kIsWeb) {
        _deviceId = _uuid.v4();
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            final androidInfo = await _deviceInfo.androidInfo;
            if (androidInfo.id.isNotEmpty) {
              _deviceId = androidInfo.id;
            }
            break;
          case TargetPlatform.iOS:
            final iosInfo = await _deviceInfo.iosInfo;
            final idfv = iosInfo.identifierForVendor;
            if (idfv != null && idfv.isNotEmpty) {
              _deviceId = idfv;
            }
            break;
          default:
            _deviceId = _uuid.v4();
            break;
        }
      }

      _deviceId ??= _uuid.v4();

      await prefs.setString(kSharedPrefDeviceId, _deviceId!);
    } catch (e) {
      logError('Failed to determine deviceId, using UUID: $e');
      _deviceId ??= _uuid.v4();
    }

    return _deviceId!;
  }

  Future<void> saveLogs(List<Map<String, dynamic>> logs, String? userId,
      String platform, String appVersion) async {
    if (logs.isEmpty) return;

    final now = DateTime.now().toUtc();
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);
    final hourLabel = DateFormat('yyyy-MM-dd_HH').format(hourStart);

    final deviceId = await getDeviceId();

    final userIdentifier =
        userId != null && userId.isNotEmpty ? userId : 'anonymous';
    final docId =
        '${hourLabel}_${deviceId}_${userIdentifier}_${platform}_$appVersion';

    final docRef = _firestore
        .collection(kLoggingCollectionName)
        .doc(docId);

    await docRef.set({
      'deviceId': deviceId,
      'userId': userIdentifier,
      'platform': platform,
      'appVersion': appVersion,
      'startTime': hourStart.toIso8601String(),
      'endTime': hourStart.add(const Duration(hours: 1)).toIso8601String(),
    }, SetOptions(merge: true));

    await docRef.update({
      'entries': FieldValue.arrayUnion(logs),
    });
  }

  Future<Map<String, dynamic>?> getUserEventLogs(String userId) async {
    try {
      final data = await _firebaseRepository.getItem(userId);

      if (data != null) {
        return data;
      }
      return null;
    } catch (error) {
      logError(' Failed to get user event logs: $error');
      rethrow;
    }
  }

  Future<void> clearUserEventLogs(String userId) async {
    try {
      await _firebaseRepository.deleteItems([userId]);
    } catch (error) {
      logError(' Failed to clear user event logs: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> appConfigFromDb(String platform) async {
    try {
      final docSnapshot = await _firestore
          .collection('app_config')
          .doc('app_version')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final platformData = data[platform];
        logInfo('Platform data: $data');
        if (platformData != null) {
          return platformData as Map<String, dynamic>;
        }
      }
      return null;
    } catch (error) {
      logError(' Failed to get app version data: $error');
      rethrow;
    }
  }
}
