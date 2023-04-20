// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/enums.dart';

late final SharedPreferences _preferences;

Future<SharedPreferences> initializePreferences() async =>
    _preferences = await SharedPreferences.getInstance();

const _ADD_CONFIRM_KEY = 'add-confirm-period';
const _CHANGE_CONFIRM_KEY = 'change-confirm-period';
const _DELETE_CONFIRM_KEY = 'delete-confirm-period';
const _GRADE_SYSTEM_KEY = 'grading-system';
const _THEME_KEY = 'theme';
const _THEME_COLOR_KEY = 'color-theme';
const _USE_ANDROID12_THEME_KEY = 'theme-android12-color';
const _FIRST_LOGIN_KEY = 'first';
const _HAS_DAILY_NOTIFICATION_KEY = 'daily-notification';
const _DAILY_NOTIFICATION_TIME_KEY = 'daily-notification-time';
const _TERM_KEY = 'term';
const _CURRENT_TERM_KEY = 'current-term';

final _defaultReminderTime = DateTime(2020, 1, 1, 20, 0);

final firstLoginPreferencesProvider =
    StateNotifierProvider.autoDispose<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _FIRST_LOGIN_KEY,
    defaultValue: false,
  ),
);

final currentTermPreferencesProvider =
    StateNotifierProvider<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _CURRENT_TERM_KEY,
    defaultValue: 1,
  ),
);
final totalTermPreferencesProvider =
    StateNotifierProvider.autoDispose<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _TERM_KEY,
    defaultValue: 1,
  ),
);
final themePreferencesProvider =
    StateNotifierProvider.autoDispose<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _THEME_KEY,
    defaultValue: ThemeMode.system.index,
  ),
);
final useAndroid12ThemePreferencesProvider =
    StateNotifierProvider.autoDispose<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _USE_ANDROID12_THEME_KEY,
    defaultValue: true,
  ),
);
final themeColorProvider = StateNotifierProvider<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _THEME_COLOR_KEY,
    defaultValue: ThemeColors.blue.index,
  ),
);
final gradingSystemProvider =
    StateNotifierProvider<_IntPreferenceNotifier, int>(
  (ref) => _IntPreferenceNotifier(
    prefs: _preferences,
    key: _GRADE_SYSTEM_KEY,
    defaultValue: GradingSystem.zeroToTen.index,
  ),
);
final hasDailyNotificationPreferencesProvider =
    StateNotifierProvider.autoDispose<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _HAS_DAILY_NOTIFICATION_KEY,
    defaultValue: false,
  ),
);
final dailyNotificationTimePreferencesProvider =
    StateNotifierProvider.autoDispose<_StringPreferenceNotifier, String>(
  (ref) => _StringPreferenceNotifier(
    prefs: _preferences,
    key: _DAILY_NOTIFICATION_TIME_KEY,
    defaultValue: _defaultReminderTime.toIso8601String(),
  ),
);

final addConfirmPeriodProvider =
    StateNotifierProvider<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _ADD_CONFIRM_KEY,
    defaultValue: true,
  ),
);
final changeConfirmPeriodProvider =
    StateNotifierProvider<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _CHANGE_CONFIRM_KEY,
    defaultValue: true,
  ),
);
final deleteConfirmPeriodProvider =
    StateNotifierProvider<_BoolPreferenceNotifier, bool>(
  (ref) => _BoolPreferenceNotifier(
    prefs: _preferences,
    key: _DELETE_CONFIRM_KEY,
    defaultValue: true,
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
