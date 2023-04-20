import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../convert/convert_classes.dart';
import '../../convert/extension.dart';
import '../../helpers/enums.dart';
import '../../models/grade_data.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';
import '../add_grade/add_grade_screen.dart';

class GradeTile extends ConsumerWidget {
  final GradeData grade;
  const GradeTile({Key? key, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemValue =
        (GradingSystem.values[ref.watch(gradingSystemProvider)]).value;
    final gradeValue = grade.grade.gradeValue * systemValue;
    return Tile(
      leadingProgress: grade.grade.gradeValue,
      title: grade.subject.name,
      subtitle: grade.grade.note ?? '',
      showTileOnActions: true,
      trailingTitle: grade.grade.dateTime.format('MMM d, yyyy'),
      trailingSubtitle: grade.grade.credits > 1
          ? '${grade.grade.credits} credits'
          : '${grade.grade.credits} credit',
      trailingIndicatorColor: grade.subject.color,
      leadingTextBuilder: (_) => getFormattedValueString(gradeValue),
      leadingSubtextBuilder: () => 'of $systemValue',
      pressAction: SheetTileActionData<TilePressActionsEnum>(
        actions: const [editAction, deleteAction],
        valueChanged: (context, value) {
          switch (value) {
            case TilePressActionsEnum.edit:
              Navigator.pushNamed(
                context,
                AddGradeScreen.route,
                arguments: grade.grade,
              );
              break;
            case TilePressActionsEnum.delete:
              showAlertDialog(
                context: context,
                content: 'Do you want to delete this grade ?',
                action: (context) {
                  final dao = ref.read(gradeDaoProvider);
                  dao.deleteGrade(grade.grade);
                  MyTileCallback.showSnackbar(
                    context: context,
                    message: 'Grade deleted',
                    action: () => dao.insertGrade(grade.grade),
                  );
                },
              );
              break;
            case TilePressActionsEnum.reset:
            case TilePressActionsEnum.calendarView:
            case TilePressActionsEnum.done:
            case TilePressActionsEnum.undo:
            case TilePressActionsEnum.notify:
            case TilePressActionsEnum.unNotify:
              break;
          }
        },
      ),
    );
  }
}
