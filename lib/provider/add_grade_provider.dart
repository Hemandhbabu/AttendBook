import '../convert/convert_classes.dart';
import '../database/dao/grade_dao.dart';
import '../database/entity/grade.dart';
import '../helpers/enums.dart';
import '../helpers/type_def_utils.dart';
import 'preference_provider.dart';

class AddGradeProvider {
  final int? id;
  double? _gradeValue;
  int _subjectId;
  GradingSystem _gradingSystem;
  DateTime dateTime;
  int? _credits;
  String? _note;
  final Grade? loadedGrade;
  final Reader read;

  AddGradeProvider({
    required this.loadedGrade,
    required int? subjectId,
    required this.read,
  })  : id = loadedGrade?.id,
        _subjectId = loadedGrade?.subjectId ?? subjectId ?? -1,
        _gradeValue = loadedGrade?.gradeValue,
        dateTime = loadedGrade?.dateTime ?? DateTime.now(),
        _gradingSystem = GradingSystem.values[read(gradingSystemProvider)],
        _credits = loadedGrade?.credits,
        _note = loadedGrade?.note;

  double? get gradeValue => _gradeValue;
  int get subjectId => _subjectId;
  int? get credits => _credits;
  String? get note => _note;
  GradingSystem get gradingSystem => _gradingSystem;

  String? get gradeFieldValue {
    if (gradeValue == null) return null;
    return getFormattedValueString(gradeValue! * gradingSystem.value);
  }

  void setGradeValue(double grade) {
    _gradeValue = grade / gradingSystem.value;
  }

  void setsubjectId(int id) {
    _subjectId = id;
  }

  void setGradingSystem(GradingSystem gradingSystem) {
    _gradingSystem = gradingSystem;
    read(gradingSystemProvider.notifier).setInt(gradingSystem.value);
  }

  void setCredits(int? credits) {
    _credits = credits;
  }

  void setNote(String? note) {
    _note = note;
  }

  Future<String> save({
    required int currentTerm,
    required GradeDao dao,
    required void Function() pop,
  }) async {
    if (gradeValue == null) {
      return 'Fill all the required fields';
    }
    final value = Grade(
      id: id,
      gradeValue: gradeValue!,
      subjectId: subjectId,
      dateTimeString: dateTime.toIso8601String(),
      credits: credits ?? 1,
      note: note,
      term: currentTerm,
    );
    if (loadedGrade == null) {
      await dao.insertGrade(value);
      pop();
      return 'Grade added successfully';
    } else if (!loadedGrade!.isEqual(value)) {
      await dao.updateGrade(value);
      pop();
      return 'Grade updated successfully';
    } else {
      return 'No changes found';
    }
  }
}
