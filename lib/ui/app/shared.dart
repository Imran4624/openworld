import 'package:flutter_boilerplate/services/logging_service/log_service.dart';

final LogService _logService = LogService();

void printL(String message) {
      print(message);
}

void logInfo(String message) => _logService.info(message);
void logWarning(String message) => _logService.warning(message);
void logError(String message) => _logService.error(message);
void logEvent(String message) => _logService.event(message);