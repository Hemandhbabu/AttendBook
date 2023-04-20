import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_app_bar.dart';

class ScrollNotificationWrapper extends ConsumerWidget {
  final String keyString;
  final Widget child;
  const ScrollNotificationWrapper({
    super.key,
    required this.keyString,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        final provider = elevatedProvider(keyString);
        final showDivider = ref.read(provider);

        if (notification.metrics.pixels > 10 && !showDivider) {
          ref.read(provider.notifier).state = true;
        } else if (notification.metrics.pixels <= 10 && showDivider) {
          ref.read(provider.notifier).state = false;
        }
        return true;
      },
      child: child,
    );
  }
}
