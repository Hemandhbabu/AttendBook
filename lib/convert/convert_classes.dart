import '../convert/extension.dart';
import '../database/entity/grade.dart';
import '../models/subject_data.dart';

class PercentConvert {
  double _classValue = 0, _gradeValue = 0;
  int _present = 0, _absent = 0, _cancel = 0, _credits = 0;
  bool _hasClass = false, _hasGrade = false;
  int subjectCount;

  PercentConvert(Iterable<SubjectData> items) : subjectCount = items.length {
    _credits = items.map((e) => e.credits).addition;
    for (var item in items) {
      if (item.hasGrade) _hasGrade = true;
    }
    if (_credits > 0) {
      _gradeValue = items.map((e) => e.grade * e.credits).addition / _credits;
    }

    _present = items.map((e) => e.present).addition;
    _absent = items.map((e) => e.absent).addition;
    _cancel = items.map((e) => e.cancel).addition;
    _hasClass = totalClass > 0;
    if (_hasClass) _classValue = _present / totalClass;
  }

  PercentConvert.forGrades(Iterable<Grade> grades) : subjectCount = 1 {
    final credits = grades.map((e) => e.credits).addition;
    final grade = grades.map((e) => e.gradeValue * e.credits).addition;
    _hasGrade = credits > 0;
    if (_hasGrade) _gradeValue = grade / credits;
  }

  double get classValue => _classValue;
  double get gradeValue => _gradeValue;
  int get present => _present;
  int get absent => _absent;
  int get cancel => _cancel;
  int get totalClass => _present + _absent;
  int get credits => _credits;
  bool get hasClass => _hasClass;
  bool get hasGrade => _hasGrade;
}

String getFormattedValueString(double givenValue) {
  final val = givenValue % 1;
  if (val == 0) {
    return '${givenValue.toInt()}';
  } else if ('$val'.length > 3) {
    var value = givenValue.toStringAsFixed(2);
    while (value.endsWith('0') && value.contains('.') || value.endsWith('.')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  } else {
    return '$givenValue';
  }
}

// class SinglePercentConvert {
//   double _obtainedPercent = 0;

//   SinglePercentConvert({required SubjectData subjectData}) {
//     final attendClass = subjectData.present;
//     final totalClass = subjectData.present + subjectData.absent;
//     if (totalClass > 0) {
//       _obtainedPercent = attendClass * 100 / totalClass;
//     }
//   }

//   int getTotal(GradingSystem system) => getGradingSystemValue(system);

//   SinglePercentConvert.forGrade(Grade grade) {
//     _obtainedPercent = grade.gradeValue * 100;
//   }

//   double get obtainedPercent => _obtainedPercent;
// }

// class NumberOfClassReq {
//   final int totalClass, attendClass, reqPercent;
//   int _requiredNoOfClass = 0, _mayLeaveClass = 0;
//   double _obtainedPercent = 0;

//   NumberOfClassReq.fromPresentAbsent({
//     required int present,
//     required int absent,
//     required this.reqPercent,
//   })  : totalClass = present + absent,
//         attendClass = present {
//     _calculate();
//   }

//   NumberOfClassReq({
//     required this.totalClass,
//     required this.attendClass,
//     required this.reqPercent,
//   }) {
//     _calculate();
//   }

//   void _calculate() {
//     if (totalClass > 0) {
//       _obtainedPercent = attendClass * 100 / totalClass;
//       _requiredNoOfClass = ((((reqPercent / 100) * totalClass) - attendClass) /
//               (1 - (reqPercent / 100)))
//           .ceil();
//       _mayLeaveClass =
//           ((attendClass / (reqPercent / 100)) - totalClass).floor();
//     }
//   }

//   double get obtainedPercent => _obtainedPercent;
//   int get mayLeaveClass => _mayLeaveClass;
//   int get requiredNoOfClass => _requiredNoOfClass;

//   String get remarkSmall {
//     if (totalClass <= 0) {
//       return 'No class to track';
//     } else if (reqPercent > obtainedPercent && requiredNoOfClass == 1) {
//       return 'Needs next class';
//     } else if (reqPercent > obtainedPercent && requiredNoOfClass > 1) {
//       return 'Needs $requiredNoOfClass more classes';
//     } else if (reqPercent < obtainedPercent && mayLeaveClass == 1) {
//       return 'May leave next class';
//     } else if (reqPercent < obtainedPercent && mayLeaveClass > 1) {
//       return 'May leave next $mayLeaveClass classes';
//     } else {
//       return 'Don\'t miss next class';
//     }
//   }

//   String get remark {
//     if (totalClass <= 0) {
//       return 'You have no class to track';
//     } else if (reqPercent > obtainedPercent && requiredNoOfClass == 1) {
//       return 'Need to attend next class to back on track';
//     } else if (reqPercent > obtainedPercent && requiredNoOfClass > 1) {
//       return 'Need to attend $requiredNoOfClass more classes to back on track';
//     } else if (reqPercent < obtainedPercent && mayLeaveClass == 1) {
//       return 'On track, You may leave next class';
//     } else if (reqPercent < obtainedPercent && mayLeaveClass > 1) {
//       return 'On track, You may leave next $mayLeaveClass classes';
//     } else if (reqPercent == obtainedPercent) {
//       return 'Exactly on track, Don\'t miss next class';
//     } else {
//       return 'On track, Don\'t miss next class';
//     }
//   }
// }
