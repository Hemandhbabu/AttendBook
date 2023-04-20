import 'package:attend_book/convert/extension.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../security_question_provider.dart';
import 'add_edit_info_card.dart';
import 'custom_text_field.dart';
import 'custom_tile.dart';

class AnswerCard extends ConsumerWidget {
  const AnswerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answer = ref.watch(SecurityQuestionProvider.answerProvider);
    return AddEditInfoCard(
      title: 'Asnwer',
      onTap: () => showAnswerGetter(context, answer).then(
        (value) => value?.let(
          (value) => ref
              .read(SecurityQuestionProvider.answerProvider.notifier)
              .update((state) => value),
        ),
      ),
      child: CustomTile(
        leadingIcon: Icons.drive_file_rename_outline_rounded,
        padding: const EdgeInsets.only(top: 2, bottom: 5),
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        title: answer.isEmpty ? 'Enter answer' : answer,
        titleSize: answer.isEmpty ? 18 : 22,
        titleColor: answer.isNotEmpty
            ? null
            : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
      ),
    );
  }
}

final _answerProvider = StateProvider.autoDispose((ref) => '');

Future<String?> showAnswerGetter(BuildContext context, String initialName) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProviderScope(
        overrides: [
          if (initialName.isNotEmpty)
            _answerProvider.overrideWith((ref) => initialName),
        ],
        child: const _AnswerGetter(),
      ),
    );

class _AnswerGetter extends ConsumerWidget {
  const _AnswerGetter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;
    final height = mediaQuery.size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Enter answer',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: height * 0.075),
          CustomTextField(
            autoFocus: true,
            provider: _answerProvider,
            textAlign: TextAlign.center,
            fillColor: Colors.transparent,
            hintText: 'Answer',
            maxLength: 25,
            capitalization: TextCapitalization.words,
            contentPadding: const EdgeInsets.all(24),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            labelStyle: const TextStyle(fontSize: 32),
          ),
          SizedBox(height: height * 0.075),
          ElevatedButton(
            onPressed: () => Navigator.pop(
              context,
              ref.read(_answerProvider),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: const Text('Set answer'),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
