import '../../components/custom_app_bar.dart';
import '../../components/scroll_notification_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../preference_provider.dart';
import 'components/answer_card.dart';
import 'components/question_card.dart';
import 'security_question_provider.dart';

class SecurityQuestionPage extends ConsumerWidget {
  static const route = 'security-question-page';
  final bool verify;
  const SecurityQuestionPage({super.key, required this.verify});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        SecurityQuestionProvider.questionProvider.overrideWith(
          (ref) => ref.read(securityQuestionPreferencesProvider),
        ),
        if (!verify)
          SecurityQuestionProvider.answerProvider.overrideWith(
            (ref) => ref.read(securityAnswerPreferencesProvider),
          ),
        SecurityQuestionProvider.validatorProvider
            .overrideWith(SecurityQuestionProvider.validator),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          keyString: route,
          title: '${verify ? 'Verify s' : 'S'}ecurity question',
          actions: [
            Consumer(
              builder: (context, ref, child) {
                final valid = ref.watch(
                  SecurityQuestionProvider.validatorProvider(verify),
                );
                return IconButton(
                  onPressed: valid
                      ? () => SecurityQuestionProvider.save(
                            context,
                            ref.read,
                            verify,
                          )
                      : null,
                  icon: Icon(verify ? Icons.check_rounded : Icons.save_rounded),
                );
              },
            ),
          ],
        ),
        body: ScrollNotificationWrapper(
          keyString: route,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            children: const [
              QuestionCard(),
              SizedBox(height: 12),
              AnswerCard(),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
