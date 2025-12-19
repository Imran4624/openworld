
import 'package:flutter_boilerplate/data/repositories/logging_repository.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/logging/logging_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/data/models/app_version_model.dart';

List<Middleware<AppState>> createLoggingMiddleware([
  LoggingRepository repository = const LoggingRepository(),
]) {
  final saveLogs = _saveLogs(repository);
  final logActions = _logActions();
  final appVersionUpdate = _appVersionUpdate(repository);

  return [
    TypedMiddleware<AppState, SaveLogs>(saveLogs),
    TypedMiddleware<AppState, dynamic>(logActions),
    TypedMiddleware<AppState, GetUpdatedVersion>(appVersionUpdate),
  ];
}

Middleware<AppState> _saveLogs(LoggingRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) async {
    final action = dynamicAction as SaveLogs;

    if (!kReleaseMode) {
      printL('Debug mode: Skipping Firebase log save (${action.logs.length} logs)');
      next(action);
      return;
    }

    final String? userId = store.state.authState.isAuthenticated 
        ? store.state.authState.currentUserId 
        : null;
    final String platform = getPlatformName().toLowerCase();
    final String appVersion = await getCurrentAppVersion(); 
    
    try {
      await repository.saveLogs(action.logs, userId, platform, appVersion);
      printL('Logs saved successfully: ${action.logs.length} entries');
    } catch (error) {
      printL('Failed to save logs: $error');
    }

    next(action);
  };
}

Middleware<AppState> _logActions() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
      if (kReleaseMode) {
        
        logEvent(action.toString());
      }
   
    next(action);
  };
}

Middleware<AppState> _appVersionUpdate(LoggingRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) async {
    final action = dynamicAction as GetUpdatedVersion;
    
    next(action);

    try {
      final platform = getPlatformName().toLowerCase();
      
      final appConfigFromDb = await repository.appConfigFromDb(platform);
      
      if (appConfigFromDb != null) {
        logInfo('App version data for $platform: $appConfigFromDb');
        
        try {
            final appVersionEntity = AppVersionEntity((b) => b
        ..latest = appConfigFromDb['latest']
        ..minimum = appConfigFromDb['minimum']
        ..updateUrl = appConfigFromDb['update_url']
        ..releaseNotes = appConfigFromDb['release_notes']
        ..isUpdateRequired = appConfigFromDb['is_update_required']
        ..maintenanceMode = appConfigFromDb['maintenance_mode']
        ..maintenanceMessage = appConfigFromDb['maintenance_message']
        ..featureFlags = Map<String, dynamic>.from(appConfigFromDb['feature_flags']));
          logInfo('Successfully deserialized AppVersionEntity');
          
          store.dispatch(UpdateAppVersionSuccess(appVersionEntity));
          
          if (action.completer != null && !action.completer!.isCompleted) {
            action.completer!.complete(appVersionEntity);
          }
        } catch (serializationError) {
          logError('Data structure: $appConfigFromDb');
          store.dispatch(UpdateAppVersionFailure('Serialization failed: $serializationError'));
          if (action.completer != null && !action.completer!.isCompleted) {
            action.completer!.completeError('Serialization failed: $serializationError');
          }
        }
      } else {
        logError('No app version data found for platform: $platform');
        store.dispatch(UpdateAppVersionFailure('No app version data found for platform: $platform'));
        if (action.completer != null && !action.completer!.isCompleted) {
          action.completer!.completeError('No app version data found for platform: $platform');
        }
      }
    } catch (e) {
      logError('Error getting app version update: $e');
      store.dispatch(UpdateAppVersionFailure(e.toString()));
      if (action.completer != null && !action.completer!.isCompleted) {
        action.completer!.completeError(e.toString());
      }
    }
  };
}