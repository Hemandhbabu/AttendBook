import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_lock_provider.dart';
import 'components/app_lock_body.dart';
import 'utils/app_lock_data.dart';

class AppLockPage extends StatelessWidget {
  static const route = 'app-lock-page';
  final AppLockData data;
  final bool forceClose;
  const AppLockPage({
    super.key,
    required this.data,
    required this.forceClose,
  });

  @override
  Widget build(BuildContext context) {
    bool first = true;
    return ProviderScope(
      overrides: [
        AppLockProvider.dataProvider.overrideWith((ref) => data),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (!forceClose) return true;
          if (first) {
            first = false;
            Future.delayed(const Duration(seconds: 2), () => first = true);
            final snackbar = ScaffoldMessenger.of(context);
            snackbar.showSnackBar(
              const SnackBar(content: Text('Press back again to exit')),
            );
          } else {
            SystemNavigator.pop();
          }
          return false;
        },
        child: const AppLockBody(),
      ),
    );
  }
}
