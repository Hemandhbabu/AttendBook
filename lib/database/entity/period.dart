import 'package:floor/floor.dart';

import '../../helpers/enums.dart';

extension PeriodList on List<Period> {
  int get present =>
      where((element) => element.status == PresentStatus.present).length;
  int get absent =>
      where((element) => element.status == PresentStatus.absent).length;
  int get cancel =>
      where((element) => element.status == PresentStatus.cancel).length;
  List<Period> withSubjectId(int id) =>
      where((element) => element.subjectId == id).toList();
}

@entity
class Period {
  @PrimaryKey(autoGenerate: true)
  final int? pId;
  final int subjectId;
  final int? timetableId;
  final String dateTimeString;
  final int duration;
  final int statusIndex;
  final int term;

  PresentStatus get status => PresentStatus.values[statusIndex];
  DateTime get dateTime => DateTime.parse(dateTimeString);
  bool get isExtra => timetableId == null;

  const Period({
    required this.pId,
    required this.subjectId,
    required this.dateTimeString,
    required this.duration,
    required this.statusIndex,
    required this.timetableId,
    required this.term,
  });

  Map<String, dynamic> toMap() => {
        'pId': pId,
        'subjectId': subjectId,
        'dateTimeString': dateTimeString,
        'duration': duration,
        'statusIndex': statusIndex,
        'timetableId': timetableId,
        'term': term,
      };

  Period.fromMap(Map<String, dynamic> map)
      : pId = map['pId'],
        subjectId = map['subjectId'],
        dateTimeString = map['dateTimeString'],
        duration = map['duration'],
        statusIndex = map['statusIndex'],
        term = map['term'],
        timetableId = map['timetableId'];

  Period copyId(int id) {
    return Period(
      pId: id,
      subjectId: subjectId,
      dateTimeString: dateTimeString,
      duration: duration,
      statusIndex: statusIndex,
      timetableId: timetableId,
      term: term,
    );
  }

  Period changePresentStatus(int presentStatus) {
    return Period(
      pId: pId,
      subjectId: subjectId,
      dateTimeString: dateTimeString,
      duration: duration,
      statusIndex: presentStatus,
      timetableId: timetableId,
      term: term,
    );
  }

  bool isEqual(Period value) =>
      pId == value.pId &&
      subjectId == value.subjectId &&
      dateTimeString == value.dateTimeString &&
      duration == value.duration &&
      statusIndex == value.statusIndex &&
      term == value.term &&
      timetableId == value.timetableId;

  @override
  String toString() {
    return '''
    pId: $pId,
    subjectId: $subjectId,
    dateTime: $dateTimeString,
    duration: $duration,
    status: $statusIndex,
    timetableId: $timetableId,
    ''';
  }
}
