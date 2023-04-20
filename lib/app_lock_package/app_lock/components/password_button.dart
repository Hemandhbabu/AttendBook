import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_lock_utils.dart';
import '../app_lock_provider.dart';
import '../../preference_provider.dart';

Future<bool> authenticate(BuildContext context) async {
  bool authenticated = false;
  try {
    authenticated = await AppLockUtils.authenticate() ?? false;
  } on PlatformException catch (e) {
    if (kDebugMode) print(e);
    final snackbar = ScaffoldMessenger.of(context);
    snackbar.showSnackBar(
      SnackBar(
        content: Text(e.message ?? 'Error while getting authentication data'),
      ),
    );
  }
  return authenticated;
}

Future<bool> _canAuth() async {
  bool canCheckBiometrics;
  try {
    canCheckBiometrics = (await AppLockUtils.canAuth())?.canAuth ?? false;
  } on PlatformException catch (e) {
    canCheckBiometrics = false;
    if (kDebugMode) print(e);
  }
  return canCheckBiometrics;
}

final _canAuthProvider = FutureProvider.autoDispose((ref) => _canAuth());
const _defaultWidget = SizedBox.shrink();

class FingerPrintButton extends ConsumerStatefulWidget {
  final ValueChanged<bool> onTap;

  const FingerPrintButton({super.key, required this.onTap});

  @override
  ConsumerState<FingerPrintButton> createState() => _FingerPrintButtonState();
}

class _FingerPrintButtonState extends ConsumerState<FingerPrintButton> {
  @override
  void initState() {
    super.initState();
    final isVerify = ref.read(AppLockProvider.dataProvider).maybeWhen(
          orElse: () => false,
          verify: (_, __) => true,
        );
    if (!isVerify) return;
    final useFingerPrint = ref.read(hasFingerprintLockPreferencesProvider);
    if (!useFingerPrint) return;
    final promptFingerPrint = ref.read(promptFingerprintPreferencesProvider);
    if (!promptFingerPrint) return;
    Future.delayed(
      Duration.zero,
      () async => widget.onTap(await authenticate(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useFingerPrint = ref.watch(hasFingerprintLockPreferencesProvider);
    if (!useFingerPrint) return _defaultWidget;
    final isVerify = ref.watch(AppLockProvider.dataProvider).maybeWhen(
          orElse: () => false,
          verify: (_, __) => true,
        );
    if (!isVerify) return _defaultWidget;
    return ref.watch(_canAuthProvider).maybeWhen(
          orElse: () => _defaultWidget,
          data: (canAuth) => !canAuth
              ? _defaultWidget
              : PasswordButton(
                  onTap: () async => widget.onTap(await authenticate(context)),
                  child: const Icon(Icons.fingerprint_rounded),
                ),
        );
  }
}

class PasswordButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const PasswordButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PasswordButton> createState() => _PasswordButtonState();
}

class _PasswordButtonState extends State<PasswordButton> {
  bool pressing = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(pressing ? 12 : 40));
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    final cardColor = theme.cardColor;
    final color = pressing
        ? Color.lerp(cardColor, light ? Colors.black : Colors.white, 0.2)
        : cardColor;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap,
        onHighlightChanged: (change) => setState(() => pressing = change),
        child: Opacity(
          opacity: widget.onTap == null ? 0.5 : 1,
          child: AnimatedContainer(
            alignment: Alignment.center,
            height: 80,
            width: 80,
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(borderRadius: borderRadius, color: color),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
