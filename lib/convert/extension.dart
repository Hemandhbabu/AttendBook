import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef BoolCallback<T> = bool Function(T i);
typedef SameCallback<T> = bool Function(T o, T t);
typedef ItemCallback<T> = T? Function(BoolCallback<T> callback);
typedef ItemChangeCallback<T, V> = V? Function(T i);
typedef ListCallback<T> = List<T> Function(BoolCallback<T> callback);
typedef SortCallback<T> = int Function(T o, T t);

extension MyDoubleList on Iterable<double> {
  double get addition => isEmpty ? 0 : reduce((o, t) => o + t);
}

extension MyNumList on Iterable<int> {
  int get addition => isEmpty ? 0 : reduce((o, t) => o + t);
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T value) op) => op(this);
}

extension MyList<T> on List<T> {
  T? findItem(BoolCallback<T> callback) {
    for (var listItem in this) {
      if (callback(listItem)) return listItem;
    }
    return null;
  }

  List<T> reduceWithSort(BoolCallback<T> callback, SortCallback<T> sort) =>
      where(callback).toList()..sort(sort);

  List<T> reduceList(BoolCallback<T> callback) => where(callback).toList();

  int reducedListLength(BoolCallback<T> callback) =>
      where(callback).toList().length;

  List<V> reduceToField<V>(
      ItemChangeCallback<T, V> change, SameCallback<V> reduce) {
    final List<V> vList = [];
    for (var item1 in this) {
      final value = change(item1);
      if (value != null) if (!_isSame(value, vList, reduce)) vList.add(value);
    }
    return vList;
  }

  bool _isSame<V>(V value, List<V> data, SameCallback<V> callback) {
    for (var item in data) {
      final boo = callback(item, value);
      if (boo) return true;
    }
    return false;
  }
}

extension MyDateTime on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
      );
  DateTime copyTimeOfDay(TimeOfDay timeOfDay) =>
      DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute, 0);

  int get inTimeSeconds => (hour * 60 * 60) + (minute * 60) + second;
  int get inTimeMilliSeconds =>
      (hour * 60 * 60 * 1000) +
      (minute * 60 * 1000) +
      (second * 1000) +
      millisecond;

  int get inTimeMinutes => (hour * 60) + minute;

  bool isAtSameDayAs(DateTime dateTime) =>
      dateTime.year == year && dateTime.month == month && dateTime.day == day;

  bool isAtSameMonthAs(DateTime dateTime) =>
      dateTime.year == year && dateTime.month == month;

  int timeDifference(DateTime dateTime) =>
      inTimeMinutes - dateTime.inTimeMinutes;

  String timeFormat(bool alwaysUse24HourFormat, [String? locale]) =>
      alwaysUse24HourFormat
          ? DateFormat('H:mm', locale).format(this)
          : DateFormat('h:mm a', locale).format(this);

  String format(String format, [String? locale]) =>
      DateFormat(format, locale).format(this);
}
