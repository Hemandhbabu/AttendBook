import 'package:attend_book/components/scroll_notification_wrapper.dart';
import 'package:attend_book/helpers/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../convert/convert_classes.dart';
import '../../convert/extension.dart';
import '../../database/entity/grade.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';

class AllTermGradeTile extends ConsumerWidget {
  const AllTermGradeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Grade>>(
      future: ref.read(gradeDaoProvider).getAllGradesBackup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Tile(
            tileHeight: null,
            margin: EdgeInsets.zero,
            borderRadius: BorderRadius.zero,
            title: 'All term average grades',
            trailing: CircularProgressIndicator.adaptive(),
          );
        }
        final convert = PercentConvert.forGrades(snapshot.data ?? []);
        final systemValue =
            GradingSystem.values[ref.watch(gradingSystemProvider)].value;
        final gradeValue = convert.gradeValue * systemValue;
        return Tile(
          tileHeight: null,
          margin: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          title: 'All term average grades',
          trailing: Text(
            convert.hasGrade
                ? '${getFormattedValueString(gradeValue)} of $systemValue'
                : 'No grades',
          ),
          onTap: convert.hasGrade
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _AllTermGradePage(
                        grades: snapshot.data ?? [],
                        systemValue: systemValue,
                        totalTerms: ref.read(totalTermPreferencesProvider),
                      ),
                    ),
                  )
              : null,
        );
      },
    );
  }
}

class _AllTermGradePage extends StatelessWidget {
  static const route = 'all-term-grade-page';
  final int systemValue;
  final List<Grade> grades;
  final int totalTerms;
  const _AllTermGradePage({
    Key? key,
    required this.systemValue,
    required this.grades,
    required this.totalTerms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final terms = grades.reduceToField<int>(
      (i) => i.term <= totalTerms ? i.term : null,
      (o, t) => o == t,
    );
    return Scaffold(
      appBar: const CustomAppBar(title: 'All term grades', keyString: route),
      body: ScrollNotificationWrapper(
        keyString: route,
        child: ListView.builder(
          itemCount: terms.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  const SizedBox(height: 4),
                  Card(
                    child: _TermGradeTile(
                      title: 'All term grade',
                      systemValue: systemValue,
                      grades: grades,
                    ),
                  ),
                  const Divider(indent: 16, endIndent: 16, height: 8),
                ],
              );
            }
            final term = terms[index - 1];
            return _TermGradeTile(
              title: 'Term $term',
              systemValue: systemValue,
              grades: grades.where((e) => e.term == term),
            );
          },
        ),
      ),
    );
  }
}

class _TermGradeTile extends StatelessWidget {
  final String title;
  final int systemValue;
  final Iterable<Grade> grades;
  const _TermGradeTile({
    Key? key,
    required this.title,
    required this.systemValue,
    required this.grades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credits = grades.map((e) => e.credits).addition;
    final convert = PercentConvert.forGrades(grades);
    final gradeValue = convert.gradeValue * systemValue;
    return Tile(
      title: title,
      tileHeight: null,
      trailingSubtitle: '$credits credits',
      trailingTitle: '${getFormattedValueString(gradeValue)} of $systemValue',
    );
  }
}
