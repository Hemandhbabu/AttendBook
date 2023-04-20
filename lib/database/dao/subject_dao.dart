import 'package:floor/floor.dart';

import '../entity/subject.dart';

@dao
abstract class SubjectDao {
  @Query('SELECT * FROM Subject WHERE term = :term AND id = :id')
  Future<Subject?> findSubjectWithId(int id, int term);

  @Query('SELECT * FROM Subject WHERE term = :term ORDER BY id DESC')
  Future<List<Subject>> findAllSubjects(int term);

  @Query('SELECT * FROM Subject')
  Future<List<Subject>> findAllSubjectsBackup();

  @Query('SELECT * FROM Subject WHERE term = :term ORDER BY id DESC')
  Stream<List<Subject>> findAllSubjectsAsStream(int term);

  @insert
  Future<int> insertSubject(Subject subject);

  @insert
  Future<void> insertSubjects(List<Subject> subjects);

  @update
  Future<void> updateSubject(Subject subject);

  @delete
  Future<void> deleteSubject(Subject subject);
}
