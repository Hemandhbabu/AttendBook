// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_utils.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String $setTimetableNotificationHash() =>
    r'72338276bfebf15a248babd5e332420ad00c8d11';

/// See also [setTimetableNotification].
class SetTimetableNotificationProvider extends AutoDisposeFutureProvider<bool> {
  SetTimetableNotificationProvider({
    required this.subjectName,
    required this.timetable,
    required this.alwaysUse24HourFormat,
  }) : super(
          (ref) => setTimetableNotification(
            ref,
            subjectName: subjectName,
            timetable: timetable,
            alwaysUse24HourFormat: alwaysUse24HourFormat,
          ),
          from: setTimetableNotificationProvider,
          name: r'setTimetableNotificationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $setTimetableNotificationHash,
        );

  final String subjectName;
  final Timetable timetable;
  final bool alwaysUse24HourFormat;

  @override
  bool operator ==(Object other) {
    return other is SetTimetableNotificationProvider &&
        other.subjectName == subjectName &&
        other.timetable == timetable &&
        other.alwaysUse24HourFormat == alwaysUse24HourFormat;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectName.hashCode);
    hash = _SystemHash.combine(hash, timetable.hashCode);
    hash = _SystemHash.combine(hash, alwaysUse24HourFormat.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef SetTimetableNotificationRef = AutoDisposeFutureProviderRef<bool>;

/// See also [setTimetableNotification].
final setTimetableNotificationProvider = SetTimetableNotificationFamily();

class SetTimetableNotificationFamily extends Family<AsyncValue<bool>> {
  SetTimetableNotificationFamily();

  SetTimetableNotificationProvider call({
    required String subjectName,
    required Timetable timetable,
    required bool alwaysUse24HourFormat,
  }) {
    return SetTimetableNotificationProvider(
      subjectName: subjectName,
      timetable: timetable,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
  }

  @override
  AutoDisposeFutureProvider<bool> getProviderOverride(
    covariant SetTimetableNotificationProvider provider,
  ) {
    return call(
      subjectName: provider.subjectName,
      timetable: provider.timetable,
      alwaysUse24HourFormat: provider.alwaysUse24HourFormat,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'setTimetableNotificationProvider';
}
