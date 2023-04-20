import 'dart:async';

import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/grade_dao.dart';
import 'dao/period_dao.dart';
import 'dao/subject_dao.dart';
import 'dao/timetable_dao.dart';
import 'entity/grade.dart';
import 'entity/period.dart';
import 'entity/subject.dart';
import 'entity/timetable.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Subject, Period, Timetable, Grade])
abstract class AppDatabase extends FloorDatabase {
  SubjectDao get subjectDao;
  PeriodDao get periodDao;
  TimetableDao get timetableDao;
  GradeDao get gradeDao;
}
