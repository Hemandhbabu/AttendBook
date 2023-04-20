part of 'settings_screen.dart';

class LockScreenPreference extends ConsumerWidget {
  const LockScreenPreference({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLock = ref.watch(hasLockPreferencesProvider);
    return SwitchTile(
      title: 'Lock screen',
      value: hasLock,
      onChanged: (val) => hasLock
          ? showMyAction(
              context,
              SheetTileActionData(
                actions: [
                  const TileAction(
                    text: 'Change PIN',
                    value: 0,
                    icon: Icons.loop_rounded,
                  ),
                  const TileAction(
                    text: 'Turn off app lock',
                    value: 1,
                    icon: Icons.lock_open_rounded,
                  ),
                ],
                valueChanged: (context, value) async {
                  if (value == 0) {
                    final result = await Navigator.pushNamed(
                      context,
                      AppLockPage.route,
                      arguments: const AppLockArg(
                        data: AppLockData.change(),
                        useForceClose: false,
                      ),
                    );
                    if (result is String) {
                      ref
                          .read(lockPasswordPreferencesProvider.notifier)
                          .setString(result);
                    }
                  } else if (value == 1) {
                    final result = await Navigator.pushNamed(
                      context,
                      AppLockPage.route,
                      arguments: const AppLockArg(
                        data: AppLockData.off(),
                        useForceClose: false,
                      ),
                    );
                    if (result is bool && result) {
                      ref
                          .read(hasLockPreferencesProvider.notifier)
                          .setBool(false);
                      ref
                          .read(lockPasswordPreferencesProvider.notifier)
                          .removeKey();
                    }
                  }
                },
              ),
            )
          : Navigator.pushNamed(
              context,
              AppLockPage.route,
              arguments: const AppLockArg(
                data: AppLockData.set(),
                useForceClose: false,
              ),
            ).then((value) {
              if (value is String) {
                ref.read(hasLockPreferencesProvider.notifier).setBool(true);
                ref
                    .read(lockPasswordPreferencesProvider.notifier)
                    .setString(value);
              }
            }),
    );
  }
}

final _authStatusProvider =
    FutureProvider.autoDispose((ref) => AppLockUtils.canAuth());

class FingerprintPreference extends ConsumerWidget {
  const FingerprintPreference({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(
      hasLockPreferencesProvider,
      (previous, next) {
        if (!next) {
          ref
              .read(hasFingerprintLockPreferencesProvider.notifier)
              .setBool(false);
        }
      },
    );
    if (!ref.watch(hasLockPreferencesProvider)) return const SizedBox.shrink();
    final useFingerprint = ref.watch(hasFingerprintLockPreferencesProvider);
    final authStatus = ref.watch(_authStatusProvider);
    final errorMessage = authStatus.when(
      data: (data) => data?.canAuth == true
          ? null
          : data?.authData ?? 'Error while fetching about biometrics',
      error: (error, stackTrace) => error.toString(),
      loading: () => 'Loading...',
    );
    return SwitchTile(
      title: 'Use fingerprint',
      subtitle: errorMessage,
      value: useFingerprint,
      onChanged: (val) async => (await authenticate(context))
          ? ref
              .read(hasFingerprintLockPreferencesProvider.notifier)
              .setBool(val)
          : null,
    );
  }
}

class LockScreenTimeoutPreference extends ConsumerWidget {
  const LockScreenTimeoutPreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasLockPreferencesProvider)) return const SizedBox.shrink();
    final timeout = ref.watch(timeoutPreferencesProvider);
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Lock screen timeout',
      tileHeight: null,
      trailing: Text(
        timeout == 0
            ? 'Immediately'
            : timeout == 1
                ? '1 minute'
                : '$timeout minutes',
      ),
      pressAction: SheetTileActionData<int>(
        selectedAction: timeout,
        actions: const [
          TileAction(text: 'Immediately', value: 0),
          TileAction(text: '1 minute', value: 1),
          TileAction(text: '5 minutes', value: 5),
          TileAction(text: '10 minutes', value: 10),
          TileAction(text: '30 minutes', value: 30),
        ],
        valueChanged: (context, value) =>
            ref.read(timeoutPreferencesProvider.notifier).setInt(value),
      ),
    );
  }
}

class SecurityQuestionPreference extends ConsumerWidget {
  const SecurityQuestionPreference({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(hasLockPreferencesProvider)) return const SizedBox.shrink();
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Security question',
      tileHeight: null,
      onTap: () async {
        final navigator = Navigator.of(context);
        final isVerified = await navigator.pushNamed(
          AppLockPage.route,
          arguments: const AppLockArg(
            data: AppLockData.verify(),
            useForceClose: false,
          ),
        );
        if (isVerified is bool && isVerified) {
          navigator.pushNamed(SecurityQuestionPage.route, arguments: false);
        }
      },
    );
  }
}
