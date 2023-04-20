import 'package:attend_book/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/my_list_view.dart';
import '../../provider/providers.dart';
import '../home/percent_card.dart';
import 'grade_tile.dart';

class GradeScreen extends ConsumerWidget {
  static const route = 'grades-page';
  const GradeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(gradeDataProvider);
    return Scaffold(
      appBar: const CustomAppBar(keyString: route, title: 'Grades'),
      body: MyListView(
        keyString: route,
        emptyText: 'You have no grades yet',
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: grades.isEmpty ? 0 : grades.length + 1,
        itemBuilder: (index) => index == 0
            ? const PercentCard(isClass: false)
            : GradeTile(grade: grades[index - 1]),
      ),
    );
  }
}
