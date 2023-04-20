import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationSelectionActions extends StateNotifier<String?> {
  NotificationSelectionActions() : super(null);

  void setPayload(String payload) {
    if (payload.trim().isEmpty) return;
    state = payload;
  }

  void poped() => state = null;
}
