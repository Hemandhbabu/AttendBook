import 'package:attend_book/convert/extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../security_question_provider.dart';
import 'add_edit_info_card.dart';
import 'custom_tile.dart';

const securityQuestions = [
  'What is your primary school teacher name ?',
  'What is your favorite actor\'s name ?',
  'What is your pet\'s name ?',
  'What is your favorite dish ?',
  'Where did you completed high school studies ?',
];

class QuestionCard extends ConsumerWidget {
  const QuestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(SecurityQuestionProvider.questionProvider);
    return AddEditInfoCard(
      title: 'Question',
      onTap: () => showQuestionPicker(context, question).then(
        (value) => value?.let(
          (value) => ref
              .read(SecurityQuestionProvider.questionProvider.notifier)
              .update((state) => value),
        ),
      ),
      child: CustomTile(
        titleSize: 18,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        title: securityQuestions[
            question >= securityQuestions.length ? 0 : question],
      ),
    );
  }
}

Future<int?> showQuestionPicker(BuildContext context, int question) {
  final size = MediaQuery.of(context).size;
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints.loose(Size(size.width, size.height * 0.75)),
    builder: (context) => _QuestionPicker(question),
  );
}

class _QuestionPicker extends ConsumerWidget {
  final int question;
  const _QuestionPicker(this.question);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = question;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: SingleChildScrollView(
        child: Wrap(
          children: List.generate(
            securityQuestions.length,
            (index) {
              final payment = securityQuestions[index];
              final isSelected = selected == index;
              return CustomTile(
                onTap: () => Navigator.pop(context, isSelected ? null : index),
                title: payment,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                    : Colors.transparent,
              );
            },
          ),
        ),
      ),
    );
  }
}
