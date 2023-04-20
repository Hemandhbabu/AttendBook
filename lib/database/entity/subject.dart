import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@entity
class Subject {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int colorValue;
  final String? note;
  final int term;

  Color get color => Color(colorValue);

  const Subject({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.note,
    required this.term,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'colorValue': colorValue,
        'note': note,
        'term': term,
      };

  Subject.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        colorValue = map['colorValue'],
        note = map['note'],
        term = map['term'];

  Subject copyId(int id) {
    return Subject(
      id: id,
      name: name,
      colorValue: colorValue,
      note: note,
      term: term,
    );
  }

  bool isEqual(Subject value) =>
      id == value.id &&
      name == value.name &&
      colorValue == value.colorValue &&
      term == value.term &&
      note == value.note;
}
