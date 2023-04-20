import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'utils/app_lock_data.dart';

class AppLockProvider {
  const AppLockProvider._();

  static final dataProvider =
      StateProvider.autoDispose((ref) => const AppLockData.verify());

  static final enteredPasswordProvider = StateProvider.autoDispose((ref) => '');
  static final errorProvider = StateProvider.autoDispose((ref) => '');

  static final isAnimateProvider = StateProvider.autoDispose((ref) => false);
}
