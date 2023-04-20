part of 'settings_screen.dart';

class PeriodAddConfirm extends ConsumerWidget {
  const PeriodAddConfirm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addConfirm = ref.watch(addConfirmPeriodProvider);
    return SwitchTile(
      title: 'Confirm before adding period',
      value: addConfirm,
      onChanged: ref.read(addConfirmPeriodProvider.notifier).setBool,
    );
  }
}

class PeriodChangeConfirm extends ConsumerWidget {
  const PeriodChangeConfirm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeConfirm = ref.watch(changeConfirmPeriodProvider);
    return SwitchTile(
      title: 'Confirm before changing period',
      value: changeConfirm,
      onChanged: ref.read(changeConfirmPeriodProvider.notifier).setBool,
    );
  }
}

class PeriodDeleteConfirm extends ConsumerWidget {
  const PeriodDeleteConfirm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteConfirm = ref.watch(deleteConfirmPeriodProvider);
    return SwitchTile(
      title: 'Confirm before deleting period',
      value: deleteConfirm,
      onChanged: ref.read(deleteConfirmPeriodProvider.notifier).setBool,
    );
  }
}
