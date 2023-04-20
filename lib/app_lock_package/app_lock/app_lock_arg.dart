import 'utils/app_lock_data.dart';

class AppLockArg {
  final AppLockData data;
  final bool useForceClose;

  const AppLockArg({required this.data, required this.useForceClose});
}
