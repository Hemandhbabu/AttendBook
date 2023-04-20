import 'package:attend_book/app_lock_package/app_lock.dart';
import 'package:flutter/material.dart';

import '../screen/add_extra_class/add_extra_class_screen.dart';
import '../screen/add_grade/add_grade_screen.dart';
import '../screen/add_subject/add_subject_screen.dart';
import '../screen/add_timetable/add_time_table_screen.dart';
import '../screen/all_class/all_class_screen.dart';
import '../screen/calendar_view/calendar_view_screen.dart';
import '../screen/day/day_screen.dart';
import '../screen/grade/subject_grade_screen.dart';
import '../screen/period/period_screen.dart';
import '../screen/range/range_screen.dart';
import '../screen/settings/settings_screen.dart';
import '../screen/subject_timetable/subject_timetable_screen.dart';

final routes = {
  AddSubjectScreen.route: (_) => const AddSubjectScreen(),
  AddTimetableScreen.route: (_) => const AddTimetableScreen(),
  AddExtraClassScreen.route: (_) => const AddExtraClassScreen(),
  AddGradeScreen.route: (_) => const AddGradeScreen(),
  PeriodScreen.route: (_) => const PeriodScreen(),
  SubjectTimetableScreen.route: (_) => const SubjectTimetableScreen(),
  SubjectGradeScreen.route: (_) => const SubjectGradeScreen(),
  AllClassScreen.route: (_) => const AllClassScreen(),
  DayScreen.route: (_) => const DayScreen(),
  RangeScreen.route: (_) => const RangeScreen(),
  CalendarViewScreen.route: (_) => const CalendarViewScreen(),
  SettingsScreen.route: (_) => const SettingsScreen(),
  AppLockPage.route: (context) {
    final arg = ModalRoute.of(context)?.settings.arguments as AppLockArg?;
    return AppLockPage(
      data: arg?.data ?? const AppLockData.verify(),
      forceClose: arg?.useForceClose ?? false,
    );
  },
  SecurityQuestionPage.route: (context) {
    final arg = ModalRoute.of(context)?.settings.arguments as bool?;
    return SecurityQuestionPage(verify: arg ?? true);
  }
};
