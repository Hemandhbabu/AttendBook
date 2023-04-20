import 'package:floor/floor.dart';

@entity
class Grade {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final double gradeValue;
  final int subjectId;
  final int credits;
  final String dateTimeString;
  final String? note;
  final int term;

  DateTime get dateTime => DateTime.parse(dateTimeString);

  const Grade({
    required this.id,
    required this.gradeValue,
    required this.subjectId,
    required this.credits,
    required this.dateTimeString,
    required this.note,
    required this.term,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'gradeValue': gradeValue,
        'subjectId': subjectId,
        'credits': credits,
        'dateTimeString': dateTimeString,
        'note': note,
        'term': term,
      };

  Grade.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        gradeValue = map['gradeValue'],
        subjectId = map['subjectId'],
        credits = map['credits'],
        dateTimeString = map['dateTimeString'],
        term = map['term'],
        note = map['note'];

  bool isEqual(Grade value) =>
      id == value.id &&
      subjectId == value.subjectId &&
      gradeValue == value.gradeValue &&
      credits == value.credits &&
      dateTimeString == value.dateTimeString &&
      term == value.term &&
      note == value.note;
}
