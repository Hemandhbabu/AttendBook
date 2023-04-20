import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/my_progressbar.dart';
import '../../convert/convert_classes.dart';
import '../../helpers/enums.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';

const _borderRadius = BorderRadius.all(Radius.circular(15));

class PercentCard extends ConsumerWidget implements PreferredSizeWidget {
  final bool isClass;
  const PercentCard({
    Key? key,
    required this.isClass,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _PercentCardBody(
      isClass: isClass,
      systemValue: isClass
          ? null
          : GradingSystem.values[ref.watch(gradingSystemProvider)].value,
      convert: PercentConvert(ref.watch(subjectDataProvider)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(168);
}

class _PercentCardBody extends StatelessWidget {
  final PercentConvert convert;
  final int? systemValue;
  final bool isClass;

  const _PercentCardBody({
    Key? key,
    required this.convert,
    required this.systemValue,
    required this.isClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
      child: Row(
        children: [
          Expanded(
            child: _PercentText(
              convert: convert,
              systemValue: systemValue,
              showClass: isClass,
            ),
          ),
          _RequiredObtainedProgress(isClass: isClass, convert: convert),
        ],
      ),
    );
  }
}

class _PercentText extends StatelessWidget {
  final bool showClass;
  final PercentConvert convert;
  final int? systemValue;

  const _PercentText({
    Key? key,
    required this.convert,
    required this.showClass,
    required this.systemValue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isGrade = !showClass && systemValue != null;
    final opacityColor = Theme.of(context).iconTheme.color?.withOpacity(0.6);
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _TextHeroCard(
                label: isGrade ? 'Subjects' : 'Present',
                value: isGrade
                    ? TextSpan(text: '${convert.subjectCount}')
                    : TextSpan(text: '${convert.present}'),
                margin: const EdgeInsets.fromLTRB(4, 0, 3, 3),
              ),
              _TextHeroCard(
                label: isGrade ? 'Credits' : 'Absent',
                value: isGrade
                    ? TextSpan(text: '${convert.credits}')
                    : TextSpan(text: '${convert.absent}'),
                margin: const EdgeInsets.fromLTRB(3, 0, 3, 3),
              ),
            ],
          ),
        ),
        _TextHeroCard(
          label: isGrade ? 'Overall grade' : 'Overall attendance',
          value: isGrade
              ? TextSpan(
                  text: getFormattedValueString(
                      convert.gradeValue * systemValue!),
                  children: [
                      TextSpan(
                        text: ' of ',
                        style: TextStyle(fontSize: 16, color: opacityColor),
                      ),
                      TextSpan(text: '$systemValue'),
                    ])
              : TextSpan(
                  text: getFormattedValueString(convert.classValue * 100),
                  children: [
                      TextSpan(
                        text: ' %',
                        style: TextStyle(fontSize: 18, color: opacityColor),
                      ),
                    ]),
          margin: const EdgeInsets.fromLTRB(4, 3, 3, 0),
        ),
      ],
    );
  }
}

class _RequiredObtainedProgress extends StatelessWidget {
  final PercentConvert convert;
  final bool isClass;

  const _RequiredObtainedProgress({
    Key? key,
    required this.convert,
    required this.isClass,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Material(
        type: MaterialType.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MyProgressbar(
              widthPercent: 18,
              unselectedWidthPercent: 15,
              value: isClass ? convert.classValue : convert.gradeValue,
              textBuilder: (_) => isClass ? ' Classes ' : ' Grades ',
              subtextBuilder: () => '',
            ),
          ),
        ),
      ),
    );
  }
}

class _TextHeroCard extends StatelessWidget {
  final String label;
  final TextSpan value;
  final EdgeInsets margin;

  const _TextHeroCard({
    Key? key,
    required this.label,
    required this.value,
    this.margin = const EdgeInsets.all(4),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: margin,
        child: Material(
          type: MaterialType.card,
          shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Opacity(
                      opacity: 0.6,
                      child: FittedBox(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  flex: 7,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text.rich(
                        value,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
