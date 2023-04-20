import 'package:floor/floor.dart';

import '../entity/grade.dart';

@dao
abstract class GradeDao {
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertGrade(Grade grade);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertGrades(List<Grade> grades);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateGrade(Grade grade);

  @delete
  Future<void> deleteGrade(Grade grade);

  @delete
  Future<void> deleteGrades(List<Grade> grades);

  @Query('SELECT * FROM Grade WHERE term = :term')
  Future<List<Grade>> findAllGrades(int term);

  @Query('SELECT * FROM Grade WHERE term = :term')
  Stream<List<Grade>> findAllGradesAsStream(int term);

  @Query('SELECT * FROM Grade')
  Future<List<Grade>> getAllGradesBackup();
}
