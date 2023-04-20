import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helpers/type_def_utils.dart';
import '../../preference_provider.dart';
import '../../security_question/security_question_page.dart';
import '../app_lock_provider.dart';
import '../utils/app_lock_data.dart';
import 'password_field.dart';
import 'password_input.dart';

class AppLockBody extends HookConsumerWidget {
  const AppLockBody({super.key});
  String getTitle(AppLockData data) {
    return data.when(
      verify: (_, __) => 'Enter PIN',
      set: () => 'Enter new PIN',
      confirm: (_) => 'Confirm PIN',
      change: () => 'Verify old PIN',
      off: () => 'Verify old PIN',
    );
  }

  void verifySecurityQuestion(BuildContext context, Reader read) async {
    final isDone = (await Navigator.pushNamed(
          context,
          SecurityQuestionPage.route,
          arguments: true,
        )) as bool? ??
        false;
    if (isDone) {
      await read(lockPasswordPreferencesProvider.notifier).setString('1234');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PIN reset', textAlign: TextAlign.center),
          content: const Text(
            'Your PIN has been reset to 1234',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(AppLockProvider.dataProvider);
    final entered = ref.watch(AppLockProvider.enteredPasswordProvider);
    final isAnimate = ref.watch(AppLockProvider.isAnimateProvider);
    final password = ref.watch(lockPasswordPreferencesProvider);
    final error = ref.watch(AppLockProvider.errorProvider);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    ref.listen(
      AppLockProvider.dataProvider,
      (previous, next) {
        ref
            .read(AppLockProvider.enteredPasswordProvider.notifier)
            .update((state) => '');
      },
    );
    ref.listen<bool>(
      AppLockProvider.isAnimateProvider,
      (previous, next) {
        if (next) {
          controller.repeat();
        } else {
          controller.stop();
        }
      },
    );
    ref.listen<String>(
      AppLockProvider.enteredPasswordProvider,
      (previous, next) async {
        if (next.isNotEmpty && error.isNotEmpty) {
          ref
              .read(AppLockProvider.errorProvider.notifier)
              .update((state) => '');
        }
        if (next.length >= 4) {
          await Future.delayed(const Duration(milliseconds: 100));
          ref
              .read(AppLockProvider.isAnimateProvider.notifier)
              .update((state) => true);
          await Future.delayed(const Duration(milliseconds: 400));
          ref
              .read(AppLockProvider.isAnimateProvider.notifier)
              .update((state) => false);
          data.when(
            verify: (showForgotPin, onDone) {
              if (next == password) {
                onDone?.call();
                if (Navigator.canPop(context)) Navigator.pop(context, true);
              } else {
                ref
                    .read(AppLockProvider.errorProvider.notifier)
                    .update((state) => 'Wrong PIN. Try again.');
                ref
                    .read(AppLockProvider.enteredPasswordProvider.notifier)
                    .update((state) => '');
                if (!showForgotPin) {
                  ref.read(AppLockProvider.dataProvider.notifier).update(
                        (state) => AppLockData.verify(
                          showForgotPin: true,
                          onDone: onDone,
                        ),
                      );
                }
              }
            },
            set: () => ref
                .read(AppLockProvider.dataProvider.notifier)
                .update((state) => AppLockData.confirm(next)),
            confirm: (set) async {
              if (next == set) {
                final secAns = ref.read(securityAnswerPreferencesProvider);
                final navigator = Navigator.of(context);
                if (secAns.length >= 4) {
                  navigator.pop(next);
                } else {
                  final isDone = (await Navigator.pushNamed(
                        context,
                        SecurityQuestionPage.route,
                        arguments: false,
                      )) as bool? ??
                      false;
                  if (isDone) {
                    navigator.pop(next);
                  } else {
                    ref.read(AppLockProvider.errorProvider.notifier).update(
                        (state) => 'Security question not set. Try again.');
                    ref
                        .read(AppLockProvider.dataProvider.notifier)
                        .update((state) => const AppLockData.set());
                  }
                }
              } else {
                ref
                    .read(AppLockProvider.errorProvider.notifier)
                    .update((state) => 'PIN does not match. Set again.');
                ref
                    .read(AppLockProvider.dataProvider.notifier)
                    .update((state) => const AppLockData.set());
              }
            },
            change: () {
              if (next == password) {
                ref
                    .read(AppLockProvider.dataProvider.notifier)
                    .update((state) => const AppLockData.set());
              } else {
                ref
                    .read(AppLockProvider.enteredPasswordProvider.notifier)
                    .update((state) => '');
                ref
                    .read(AppLockProvider.errorProvider.notifier)
                    .update((state) => 'Wrong PIN. Try again.');
              }
            },
            off: () {
              if (next == password) {
                ref
                    .read(securityQuestionPreferencesProvider.notifier)
                    .removeKey();
                ref
                    .read(securityAnswerPreferencesProvider.notifier)
                    .removeKey();
                Navigator.pop(context, true);
              } else {
                ref
                    .read(AppLockProvider.enteredPasswordProvider.notifier)
                    .update((state) => '');
                ref
                    .read(AppLockProvider.errorProvider.notifier)
                    .update((state) => 'Wrong PIN. Try again.');
              }
            },
          );
        }
      },
    );
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Text(
            getTitle(data),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          PasswordField(
            length: entered.length,
            animate: isAnimate,
            controller: controller,
          ),
          const SizedBox(height: 20),
          Text(
            error,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 20),
          data.maybeWhen(
            orElse: () => const TextButton(onPressed: null, child: Text('')),
            verify: (showForgotPin, _) => TextButton(
              onPressed: !showForgotPin
                  ? null
                  : () => verifySecurityQuestion(context, ref.read),
              child: Text(showForgotPin ? 'Forgot PIN ?' : ''),
            ),
            set: () => TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                SecurityQuestionPage.route,
                arguments: false,
              ),
              child: const Text('Change security question ?'),
            ),
            confirm: (_) => TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                SecurityQuestionPage.route,
                arguments: false,
              ),
              child: const Text('Change security question ?'),
            ),
          ),
          const Spacer(),
          PasswordInput(
            fingerPrintCallback: (verified) => verified
                ? ref
                    .read(AppLockProvider.enteredPasswordProvider.notifier)
                    .update((_) => password)
                : null,
            password: entered,
            onChanged: isAnimate
                ? null
                : (value) => ref
                    .read(AppLockProvider.enteredPasswordProvider.notifier)
                    .update((state) => value),
          ),
        ],
      ),
    );
  }
}
