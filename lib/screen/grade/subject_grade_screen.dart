import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../components/my_list_view.dart';
import '../../convert/extension.dart';
import '../../database/entity/subject.dart';
import '../../provider/providers.dart';
import '../add_grade/add_grade_screen.dart';
import 'grade_tile.dart';

class SubjectGradeScreen extends StatelessWidget {
  const SubjectGradeScreen({Key? key}) : super(key: key);

  static const route = 'subject-grade-screen';

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)?.settings.arguments as Subject;
    return Scaffold(
      appBar:
          CustomAppBar(title: '${subject.name}\'s grades', keyString: route),
      body: Consumer(
        builder: (context, ref, _) {
          final grades = ref.watch(
            gradeDataProvider.select(
              (i) => i.reduceList((e) => e.grade.subjectId == subject.id),
            ),
          );
          return MyListView(
            keyString: route,
            padding: const EdgeInsets.only(bottom: 80),
            emptyText: 'You have no grades in ${subject.name}',
            itemCount: grades.length,
            itemBuilder: (index) => GradeTile(grade: grades[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add grade',
        onPressed: () => Navigator.pushNamed(
          context,
          AddGradeScreen.route,
          arguments: subject.id,
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
