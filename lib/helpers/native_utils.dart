import 'package:flutter/services.dart';

const _versionChannel = 'com.expin_book_official.flutter.expin_book/native';
const _channel = MethodChannel(_versionChannel);

class NativeUtils {
  const NativeUtils._();
  static const _androidVersion = 'android_version';
  static const _getLocalTimezone = 'getLocalTimezone';
  static Future<int?> getAndroidVersion() {
    return _channel.invokeMethod<int>(_androidVersion);
  }

  static Future<String> getLocalTimezone() {
    return _channel
        .invokeMethod<String>(_getLocalTimezone)
        .then((value) => value!);
  }
}
