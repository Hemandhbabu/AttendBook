import 'package:attend_book/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/my_list_view.dart';
import '../../convert/convert_classes.dart';
import '../../helpers/enums.dart';
import '../../helpers/type_def_utils.dart';
import '../../models/subject_data.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';

class SubjectScreen extends ConsumerWidget {
  static const route = 'subjects-page';
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemValue =
        GradingSystem.values[ref.watch(gradingSystemProvider)].value;
    final subjectDatas = ref.watch(subjectDataProvider);
    return Scaffold(
      appBar: const CustomAppBar(keyString: route, title: 'Subjects'),
      body: MyListView(
        keyString: route,
        emptyText: 'You have no subjects yet',
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: subjectDatas.length,
        itemBuilder: (index) => SubjectTile(
          subject: subjectDatas[index],
          systemValue: systemValue,
          read: ref.read,
        ),
      ),
    );
  }
}

class SubjectTile extends StatelessWidget {
  final SubjectData subject;
  final int systemValue;
  final Reader read;

  const SubjectTile({
    Key? key,
    required this.subject,
    required this.systemValue,
    required this.read,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradeValue = subject.grade * systemValue;
    final hasClass = (subject.present + subject.absent) > 0;
    return Tile(
      key: ValueKey(subject.subject.id),
      leadingProgress: PercentConvert([subject]).classValue,
      trailingTextSize: 12,
      trailingWidgetGap: 2,
      title: subject.subject.name,
      showTileOnActions: true,
      trailingAlignment: CrossAxisAlignment.center,
      trailingIndicatorColor: subject.subject.color,
      subtitle: subject.subject.note,
      trailingTitle: subject.hasGrade
          ? 'Graded'
          : !hasClass
              ? 'No classes'
              : 'No',
      trailingSubtitle: subject.hasGrade
          ? '${getFormattedValueString(gradeValue)} of $systemValue'
          : !hasClass
              ? 'and grades'
              : 'grades',
      moreAction: SheetTileActionData<SubjectTileEnum>(
        actions: subjectActions,
        valueChanged: (context, val) => MyTileCallback.subjectCallback(
          context,
          val,
          subject.subject,
        ),
      ),
      pressAction: SheetTileActionData<TilePressActionsEnum>(
        actions: const [editAction, resetAction, deleteAction],
        valueChanged: (context, val) => MyTileCallback.subjectMoreCallback(
          context: context,
          moreEnum: val,
          subject: subject.subject,
          read: read,
        ),
      ),
    );
  }
}
