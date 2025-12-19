import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/logging/logging_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter/foundation.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  final List<Map<String, dynamic>> _logBuffer = [];
  final int _flushThreshold = 20;

  void _addLog(String level, String message) {
    final now = DateTime.now().toUtc();
    
    _logBuffer.add({
      '${_logBuffer.length}': '$level ${now.toIso8601String()} $message'
    });
    
      try {
        if (navigatorKey.currentContext != null) {
          final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
          if (_logBuffer.length >= _flushThreshold) {
            store.dispatch(SaveLogs(List.from(_logBuffer)));
            _logBuffer.clear();
          }
        }
      } catch (e) {
        printL('LogService: Could not access store: $e');
      }
  }

  void printOrLog(String level, String message) {
    if (kReleaseMode && ProjectConfig.isLoggingEnabled) {
      _addLog(level, message);
    } else {
      printL('${level} ${message}');
    }
  }

  void flushLogs() {
    if (kReleaseMode && _logBuffer.isNotEmpty) {
      try {
        if (navigatorKey.currentContext != null) {
          final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
          store.dispatch(SaveLogs(List.from(_logBuffer)));
          printL('LogService: Manually flushed ${_logBuffer.length} logs');
          _logBuffer.clear();
        }
      } catch (e) {
        printL('LogService: Could not flush logs: $e');
      }
    }
  }



  int get bufferSize => _logBuffer.length;

  void info(String message) => printOrLog("[INFO]", message);
  void warning(String message) => printOrLog("[WARN]", message);
  void error(String message) => printOrLog("[ERROR]", message);
  void event(String message) => printOrLog("[ACTION]", message);
}