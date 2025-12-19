// oauth_web.dart
import 'dart:async';
import 'package:flutter_boilerplate/.env.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

import 'platforms.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'openid',
    'profile',
  ],
  clientId: Config.GOOGLE_CLOUD_OAUTH_CLIENT_ID,
);

class GoogleOAuth {
  static bool get isEnabled => true;

  static Future<bool> signIn(Function(String, String) callback,
      {bool isSilent = false}) async {
    try {
      await _googleSignIn.signOut();

      GoogleSignInAccount? account;

      if (isWeb()) {
        try {
          if (isSilent) {
            account = await _googleSignIn.signInSilently();
          } else {
            account = await _googleSignIn.signIn();
          }

          if (account != null) {
            logInfo('Google Sign In successful, getting authentication...');
            final auth = await account.authentication;

            final idToken = auth.idToken ?? '';
            final accessToken = auth.accessToken ?? '';

            logInfo(
                'Received tokens - idToken length: ${idToken.length}, accessToken length: ${accessToken.length}');

            if (accessToken.isEmpty) {
              logError('No access token received from Google Sign In');
              return false;
            }

            if (idToken.isEmpty) {
              logWarning(
                  ' WARNING: No ID token received, proceeding with access token only');
              callback('', accessToken);
              return true;
            }

            logEvent(' Google Sign In successful for: ${account.displayName}');
            callback(idToken, accessToken);
            return true;
          } else {
            logError('Google Sign In returned null account');
            return false;
          }
        } catch (signInError) {
          logError('Google Sign In process: $signInError');

          if (signInError.toString().contains('popup') ||
              signInError.toString().contains('origin') ||
              signInError.toString().contains('blocked')) {
            logWarning(' Popup blocked, user may need to refresh the page');
            return false;
          }

          return false;
        }
      } else {
        if (isSilent) {
          account = await _googleSignIn.signInSilently();
        }

        account ??= await _googleSignIn.signIn();

        if (account != null) {
          final auth = await account.authentication;
          callback(auth.idToken ?? '', auth.accessToken ?? '');
          return true;
        }
      }

  logError('sign in failed - no account returned');
      return false;
    } catch (error) {
  logError('Google Sign In: $error');
      return false;
    }
  }

  static Future<bool> signUp(Function(String, String) callback) async {
    return await signIn(callback);
  }

  static Future<bool> requestGmailScope() async {
    try {
      return await _googleSignIn
          .requestScopes(['https://www.googleapis.com/auth/gmail.send']);
    } catch (error) {
  logError('Requesting Gmail scope: $error');
      return false;
    }
  }

  static Future<GoogleSignInAccount?> signOut() async {
    try {
      return await _googleSignIn.signOut();
    } catch (error) {
  logError('Google Sign Out: $error');
      return null;
    }
  }

  static Future<GoogleSignInAccount?> disconnect() async {
    try {
      return await _googleSignIn.disconnect();
    } catch (error) {
  logError('Google Disconnect: $error');
      return null;
    }
  }
}
