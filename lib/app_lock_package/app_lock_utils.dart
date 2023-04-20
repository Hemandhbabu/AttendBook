// ignore_for_file: constant_identifier_names

import 'preference_provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [AppLockPlatform] that uses method channels.
class AppLockUtils {
  /// The method channel used to interact with the native platform.
  static const _AUTHENTICATE = 'authenticate';
  static const _CAN_AUTH = 'canAuth';
  static const _CHECK_BIOMETRICS = 'checkBiometrics';

  static const methodChannel = MethodChannel('com.example.attendance_app/auth');

  static Future<bool?> authenticate() {
    return methodChannel.invokeMethod<bool>(_AUTHENTICATE);
  }

  static Future<AuthHelperData?> canAuth() async {
    final map = await methodChannel.invokeMethod<Map>(_CAN_AUTH);
    return map == null ? null : AuthHelperData.fromMap(map);
  }

  static void initialize(SharedPreferences preferences) {
    initializePreferences(preferences);
  }
}

class AuthHelperData {
  final bool? canAuth;
  final String? authData;

  AuthHelperData(this.canAuth, this.authData);

  static AuthHelperData fromMap(Map map) {
    return AuthHelperData(
      map[AppLockUtils._CAN_AUTH] as bool?,
      map[AppLockUtils._CHECK_BIOMETRICS] as String?,
    );
  }
}
