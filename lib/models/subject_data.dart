import '../database/entity/subject.dart';

class SubjectData {
  final Subject subject;
  final int present;
  final int absent;
  final int cancel;
  final int credits;
  final double grade;
  final bool hasGrade;

  const SubjectData({
    required this.subject,
    required this.present,
    required this.absent,
    required this.cancel,
    required this.grade,
    required this.credits,
    required this.hasGrade,
  });
}
