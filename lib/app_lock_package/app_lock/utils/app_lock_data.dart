import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_lock_data.freezed.dart';

@freezed
class AppLockData with _$AppLockData {
  const factory AppLockData.verify({
    @Default(false) bool showForgotPin,
    VoidCallback? onDone,
  }) = _Verify;
  const factory AppLockData.set() = _Set;
  const factory AppLockData.confirm(String set) = _Confirm;
  const factory AppLockData.change() = _Change;
  const factory AppLockData.off() = _Off;
}
