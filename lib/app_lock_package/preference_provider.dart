// ignore_for_file: constant_identifier_names

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _HAS_LOCK_KEY = 'lock-screen';
const _LOCK_PASSWORD_KEY = 'lock-screen-password';
const _HAS_FINGERPRINT_LOCK_KEY = 'lock-screen-fingerprint';
const _PROMPT_FINGERPRINT_KEY = 'prompt-fingerprint';
const _TIMEOUT_KEY = 'lock-screen-timeout';
const _SECURITY_QUESTION_KEY = 'security-question';
const _SECURITY_ANSWER_KEY = 'security-answer';

late final SharedPreferences _preferences;

void initializePreferences(SharedPreferences preferences) =>
    _preferences = preferences;

final hasLockPreferencesProvider =
    StateNotifierProvider.autoDispose<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _HAS_LOCK_KEY,
    defaultValue: false,
  ),
);
final lockPasswordPreferencesProvider =
    StateNotifierProvider.autoDispose<_StringPreferenceNotifier, String>(
  (ref) => _StringPreferenceNotifier(
    prefs: _preferences,
    key: _LOCK_PASSWORD_KEY,
    defaultValue: '',
  ),
);
final hasFingerprintLockPreferencesProvider =
    StateNotifierProvider.autoDispose<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _HAS_FINGERPRINT_LOCK_KEY,
    defaultValue: false,
  ),
);
final promptFingerprintPreferencesProvider =
    StateNotifierProvider.autoDispose<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _PROMPT_FINGERPRINT_KEY,
    defaultValue: true,
  ),
);
final timeoutPreferencesProvider =
    StateNotifierProvider.autoDispose<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _TIMEOUT_KEY,
    defaultValue: 5,
  ),
);
final securityQuestionPreferencesProvider =
    StateNotifierProvider.autoDispose<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _SECURITY_QUESTION_KEY,
    defaultValue: 0,
  ),
);
final securityAnswerPreferencesProvider =
    StateNotifierProvider.autoDispose<_StringPreferenceNotifier, String>(
  (ref) => _StringPreferenceNotifier(
    prefs: _preferences,
    key: _SECURITY_ANSWER_KEY,
    defaultValue: '',
  ),
);

class _BoolPreferenceNotifier extends _PreferenceNotifier<bool> {
  _BoolPreferenceNotifier({
    required SharedPreferences prefs,
    required String key,
    required bool defaultValue,
  }) : super(
          prefs,
          key: key,
          defaultValue: defaultValue,
          initialValue: prefs.getBool(key) ?? defaultValue,
        );

  Future<void> setBool(bool value) async {
    if (state != value) {
      state = value;
      await _prefs.setBool(key, value);
    }
  }
}

class _IntPreferenceNotifier extends _PreferenceNotifier<int> {
  _IntPreferenceNotifier({
    required SharedPreferences prefs,
    required String key,
    required int defaultValue,
  }) : super(
          prefs,
          key: key,
          defaultValue: defaultValue,
          initialValue: prefs.getInt(key) ?? defaultValue,
        );

  Future<void> setInt(int value) async {
    if (state != value) {
      state = value;
      await _prefs.setInt(key, value);
    }
  }
}

class _StringPreferenceNotifier extends _PreferenceNotifier<String> {
  _StringPreferenceNotifier({
    required SharedPreferences prefs,
    required String key,
    required String defaultValue,
  }) : super(
          prefs,
          key: key,
          defaultValue: defaultValue,
          initialValue: prefs.getString(key) ?? defaultValue,
        );

  Future<void> setString(String value) async {
    if (state != value) {
      state = value;
      await _prefs.setString(key, value);
    }
  }
}

abstract class _PreferenceNotifier<T> extends StateNotifier<T> {
  final SharedPreferences _prefs;
  final String key;
  final T defaultValue;
  final T initialValue;

  _PreferenceNotifier(
    this._prefs, {
    required this.key,
    required this.defaultValue,
    required this.initialValue,
  }) : super(initialValue);

  Future<void> removeKey() async {
    state = defaultValue;
    await _prefs.remove(key);
  }
}
