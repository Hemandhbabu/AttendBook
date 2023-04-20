// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'app_lock_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppLockData {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool showForgotPin, VoidCallback? onDone) verify,
    required TResult Function() set,
    required TResult Function(String set) confirm,
    required TResult Function() change,
    required TResult Function() off,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult? Function()? set,
    TResult? Function(String set)? confirm,
    TResult? Function()? change,
    TResult? Function()? off,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult Function()? set,
    TResult Function(String set)? confirm,
    TResult Function()? change,
    TResult Function()? off,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verify value) verify,
    required TResult Function(_Set value) set,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Change value) change,
    required TResult Function(_Off value) off,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verify value)? verify,
    TResult? Function(_Set value)? set,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Change value)? change,
    TResult? Function(_Off value)? off,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verify value)? verify,
    TResult Function(_Set value)? set,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Change value)? change,
    TResult Function(_Off value)? off,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppLockDataCopyWith<$Res> {
  factory $AppLockDataCopyWith(
          AppLockData value, $Res Function(AppLockData) then) =
      _$AppLockDataCopyWithImpl<$Res, AppLockData>;
}

/// @nodoc
class _$AppLockDataCopyWithImpl<$Res, $Val extends AppLockData>
    implements $AppLockDataCopyWith<$Res> {
  _$AppLockDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_VerifyCopyWith<$Res> {
  factory _$$_VerifyCopyWith(_$_Verify value, $Res Function(_$_Verify) then) =
      __$$_VerifyCopyWithImpl<$Res>;
  @useResult
  $Res call({bool showForgotPin, VoidCallback? onDone});
}

/// @nodoc
class __$$_VerifyCopyWithImpl<$Res>
    extends _$AppLockDataCopyWithImpl<$Res, _$_Verify>
    implements _$$_VerifyCopyWith<$Res> {
  __$$_VerifyCopyWithImpl(_$_Verify _value, $Res Function(_$_Verify) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showForgotPin = null,
    Object? onDone = freezed,
  }) {
    return _then(_$_Verify(
      showForgotPin: null == showForgotPin
          ? _value.showForgotPin
          : showForgotPin // ignore: cast_nullable_to_non_nullable
              as bool,
      onDone: freezed == onDone
          ? _value.onDone
          : onDone // ignore: cast_nullable_to_non_nullable
              as VoidCallback?,
    ));
  }
}

/// @nodoc

class _$_Verify with DiagnosticableTreeMixin implements _Verify {
  const _$_Verify({this.showForgotPin = false, this.onDone});

  @override
  @JsonKey()
  final bool showForgotPin;
  @override
  final VoidCallback? onDone;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppLockData.verify(showForgotPin: $showForgotPin, onDone: $onDone)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppLockData.verify'))
      ..add(DiagnosticsProperty('showForgotPin', showForgotPin))
      ..add(DiagnosticsProperty('onDone', onDone));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Verify &&
            (identical(other.showForgotPin, showForgotPin) ||
                other.showForgotPin == showForgotPin) &&
            (identical(other.onDone, onDone) || other.onDone == onDone));
  }

  @override
  int get hashCode => Object.hash(runtimeType, showForgotPin, onDone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VerifyCopyWith<_$_Verify> get copyWith =>
      __$$_VerifyCopyWithImpl<_$_Verify>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool showForgotPin, VoidCallback? onDone) verify,
    required TResult Function() set,
    required TResult Function(String set) confirm,
    required TResult Function() change,
    required TResult Function() off,
  }) {
    return verify(showForgotPin, onDone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult? Function()? set,
    TResult? Function(String set)? confirm,
    TResult? Function()? change,
    TResult? Function()? off,
  }) {
    return verify?.call(showForgotPin, onDone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult Function()? set,
    TResult Function(String set)? confirm,
    TResult Function()? change,
    TResult Function()? off,
    required TResult orElse(),
  }) {
    if (verify != null) {
      return verify(showForgotPin, onDone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verify value) verify,
    required TResult Function(_Set value) set,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Change value) change,
    required TResult Function(_Off value) off,
  }) {
    return verify(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verify value)? verify,
    TResult? Function(_Set value)? set,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Change value)? change,
    TResult? Function(_Off value)? off,
  }) {
    return verify?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verify value)? verify,
    TResult Function(_Set value)? set,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Change value)? change,
    TResult Function(_Off value)? off,
    required TResult orElse(),
  }) {
    if (verify != null) {
      return verify(this);
    }
    return orElse();
  }
}

abstract class _Verify implements AppLockData {
  const factory _Verify(
      {final bool showForgotPin, final VoidCallback? onDone}) = _$_Verify;

  bool get showForgotPin;
  VoidCallback? get onDone;
  @JsonKey(ignore: true)
  _$$_VerifyCopyWith<_$_Verify> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_SetCopyWith<$Res> {
  factory _$$_SetCopyWith(_$_Set value, $Res Function(_$_Set) then) =
      __$$_SetCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_SetCopyWithImpl<$Res> extends _$AppLockDataCopyWithImpl<$Res, _$_Set>
    implements _$$_SetCopyWith<$Res> {
  __$$_SetCopyWithImpl(_$_Set _value, $Res Function(_$_Set) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Set with DiagnosticableTreeMixin implements _Set {
  const _$_Set();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppLockData.set()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AppLockData.set'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Set);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool showForgotPin, VoidCallback? onDone) verify,
    required TResult Function() set,
    required TResult Function(String set) confirm,
    required TResult Function() change,
    required TResult Function() off,
  }) {
    return set();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult? Function()? set,
    TResult? Function(String set)? confirm,
    TResult? Function()? change,
    TResult? Function()? off,
  }) {
    return set?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult Function()? set,
    TResult Function(String set)? confirm,
    TResult Function()? change,
    TResult Function()? off,
    required TResult orElse(),
  }) {
    if (set != null) {
      return set();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verify value) verify,
    required TResult Function(_Set value) set,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Change value) change,
    required TResult Function(_Off value) off,
  }) {
    return set(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verify value)? verify,
    TResult? Function(_Set value)? set,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Change value)? change,
    TResult? Function(_Off value)? off,
  }) {
    return set?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verify value)? verify,
    TResult Function(_Set value)? set,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Change value)? change,
    TResult Function(_Off value)? off,
    required TResult orElse(),
  }) {
    if (set != null) {
      return set(this);
    }
    return orElse();
  }
}

abstract class _Set implements AppLockData {
  const factory _Set() = _$_Set;
}

/// @nodoc
abstract class _$$_ConfirmCopyWith<$Res> {
  factory _$$_ConfirmCopyWith(
          _$_Confirm value, $Res Function(_$_Confirm) then) =
      __$$_ConfirmCopyWithImpl<$Res>;
  @useResult
  $Res call({String set});
}

/// @nodoc
class __$$_ConfirmCopyWithImpl<$Res>
    extends _$AppLockDataCopyWithImpl<$Res, _$_Confirm>
    implements _$$_ConfirmCopyWith<$Res> {
  __$$_ConfirmCopyWithImpl(_$_Confirm _value, $Res Function(_$_Confirm) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? set = null,
  }) {
    return _then(_$_Confirm(
      null == set
          ? _value.set
          : set // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Confirm with DiagnosticableTreeMixin implements _Confirm {
  const _$_Confirm(this.set);

  @override
  final String set;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppLockData.confirm(set: $set)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppLockData.confirm'))
      ..add(DiagnosticsProperty('set', set));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Confirm &&
            (identical(other.set, set) || other.set == set));
  }

  @override
  int get hashCode => Object.hash(runtimeType, set);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConfirmCopyWith<_$_Confirm> get copyWith =>
      __$$_ConfirmCopyWithImpl<_$_Confirm>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool showForgotPin, VoidCallback? onDone) verify,
    required TResult Function() set,
    required TResult Function(String set) confirm,
    required TResult Function() change,
    required TResult Function() off,
  }) {
    return confirm(this.set);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult? Function()? set,
    TResult? Function(String set)? confirm,
    TResult? Function()? change,
    TResult? Function()? off,
  }) {
    return confirm?.call(this.set);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult Function()? set,
    TResult Function(String set)? confirm,
    TResult Function()? change,
    TResult Function()? off,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(this.set);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verify value) verify,
    required TResult Function(_Set value) set,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Change value) change,
    required TResult Function(_Off value) off,
  }) {
    return confirm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verify value)? verify,
    TResult? Function(_Set value)? set,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Change value)? change,
    TResult? Function(_Off value)? off,
  }) {
    return confirm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verify value)? verify,
    TResult Function(_Set value)? set,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Change value)? change,
    TResult Function(_Off value)? off,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(this);
    }
    return orElse();
  }
}

abstract class _Confirm implements AppLockData {
  const factory _Confirm(final String set) = _$_Confirm;

  String get set;
  @JsonKey(ignore: true)
  _$$_ConfirmCopyWith<_$_Confirm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ChangeCopyWith<$Res> {
  factory _$$_ChangeCopyWith(_$_Change value, $Res Function(_$_Change) then) =
      __$$_ChangeCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ChangeCopyWithImpl<$Res>
    extends _$AppLockDataCopyWithImpl<$Res, _$_Change>
    implements _$$_ChangeCopyWith<$Res> {
  __$$_ChangeCopyWithImpl(_$_Change _value, $Res Function(_$_Change) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Change with DiagnosticableTreeMixin implements _Change {
  const _$_Change();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppLockData.change()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AppLockData.change'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Change);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool showForgotPin, VoidCallback? onDone) verify,
    required TResult Function() set,
    required TResult Function(String set) confirm,
    required TResult Function() change,
    required TResult Function() off,
  }) {
    return change();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult? Function()? set,
    TResult? Function(String set)? confirm,
    TResult? Function()? change,
    TResult? Function()? off,
  }) {
    return change?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult Function()? set,
    TResult Function(String set)? confirm,
    TResult Function()? change,
    TResult Function()? off,
    required TResult orElse(),
  }) {
    if (change != null) {
      return change();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verify value) verify,
    required TResult Function(_Set value) set,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Change value) change,
    required TResult Function(_Off value) off,
  }) {
    return change(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verify value)? verify,
    TResult? Function(_Set value)? set,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Change value)? change,
    TResult? Function(_Off value)? off,
  }) {
    return change?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verify value)? verify,
    TResult Function(_Set value)? set,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Change value)? change,
    TResult Function(_Off value)? off,
    required TResult orElse(),
  }) {
    if (change != null) {
      return change(this);
    }
    return orElse();
  }
}

abstract class _Change implements AppLockData {
  const factory _Change() = _$_Change;
}

/// @nodoc
abstract class _$$_OffCopyWith<$Res> {
  factory _$$_OffCopyWith(_$_Off value, $Res Function(_$_Off) then) =
      __$$_OffCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_OffCopyWithImpl<$Res> extends _$AppLockDataCopyWithImpl<$Res, _$_Off>
    implements _$$_OffCopyWith<$Res> {
  __$$_OffCopyWithImpl(_$_Off _value, $Res Function(_$_Off) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Off with DiagnosticableTreeMixin implements _Off {
  const _$_Off();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppLockData.off()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AppLockData.off'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Off);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool showForgotPin, VoidCallback? onDone) verify,
    required TResult Function() set,
    required TResult Function(String set) confirm,
    required TResult Function() change,
    required TResult Function() off,
  }) {
    return off();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult? Function()? set,
    TResult? Function(String set)? confirm,
    TResult? Function()? change,
    TResult? Function()? off,
  }) {
    return off?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool showForgotPin, VoidCallback? onDone)? verify,
    TResult Function()? set,
    TResult Function(String set)? confirm,
    TResult Function()? change,
    TResult Function()? off,
    required TResult orElse(),
  }) {
    if (off != null) {
      return off();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verify value) verify,
    required TResult Function(_Set value) set,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Change value) change,
    required TResult Function(_Off value) off,
  }) {
    return off(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verify value)? verify,
    TResult? Function(_Set value)? set,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Change value)? change,
    TResult? Function(_Off value)? off,
  }) {
    return off?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verify value)? verify,
    TResult Function(_Set value)? set,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Change value)? change,
    TResult Function(_Off value)? off,
    required TResult orElse(),
  }) {
    if (off != null) {
      return off(this);
    }
    return orElse();
  }
}

abstract class _Off implements AppLockData {
  const factory _Off() = _$_Off;
}
