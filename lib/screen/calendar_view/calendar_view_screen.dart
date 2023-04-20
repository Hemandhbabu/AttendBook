import 'package:flutter/material.dart';

import 'calendar_view_body.dart';

class CalendarViewScreen extends StatelessWidget {
  static const route = 'calendar-view-screen';
  const CalendarViewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return CalendarViewBody(subjectId: id);
  }
}
