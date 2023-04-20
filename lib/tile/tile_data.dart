part of 'tile.dart';

abstract class TileActionData<T> {
  final T? selectedAction;
  final List<TileAction<T>> actions;
  final void Function(BuildContext context, T value) valueChanged;

  const TileActionData({
    required this.selectedAction,
    required this.actions,
    required this.valueChanged,
  });
}

class SlideableTileActionData<T> extends TileActionData<T> {
  const SlideableTileActionData({
    T? selectedAction,
    required List<TileAction<T>> actions,
    required void Function(BuildContext context, T value) valueChanged,
  }) : super(
            selectedAction: selectedAction,
            actions: actions,
            valueChanged: valueChanged);
}

class BottomButtonTileActionData<T> extends TileActionData<T> {
  final bool isText;
  const BottomButtonTileActionData({
    this.isText = false,
    T? selectedAction,
    required List<TileAction<T>> actions,
    required void Function(BuildContext context, T value) valueChanged,
  }) : super(
            selectedAction: selectedAction,
            actions: actions,
            valueChanged: valueChanged);
}

class SheetTileActionData<T> extends TileActionData<T> {
  final bool foldable, forceFold;
  const SheetTileActionData({
    this.foldable = false,
    this.forceFold = false,
    T? selectedAction,
    required List<TileAction<T>> actions,
    required void Function(BuildContext context, T value) valueChanged,
  }) : super(
            selectedAction: selectedAction,
            actions: actions,
            valueChanged: valueChanged);
}

class TileAction<T> {
  final IconData? icon;
  final Color? color;
  final String text;
  final T value;

  const TileAction({
    this.icon,
    required this.text,
    required this.value,
    this.color,
  });
}

class LeadingText extends StatelessWidget {
  const LeadingText({
    Key? key,
    required this.big,
    required this.small,
    required this.color,
    required this.isNotify,
  }) : super(key: key);

  final String big;
  final String? small;
  final Color color;
  final bool isNotify;

  Color _getForegroundColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: color);
    final child = CircleAvatar(
      radius: 21,
      backgroundColor: color.withOpacity(0.2),
      foregroundColor: _getForegroundColor(color),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: small == null
            ? FittedBox(child: Text(big, style: style))
            : Column(
                children: [
                  Expanded(
                    flex: 30,
                    child: FittedBox(
                      child: Text(
                        big,
                        textAlign: TextAlign.center,
                        style: style,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: FittedBox(
                      child: Text(small!.toUpperCase(), style: style),
                    ),
                  ),
                ],
              ),
      ),
    );
    if (!isNotify) return child;
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 42,
      width: 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: child),
          Positioned(
            bottom: -2,
            right: -4,
            height: 16,
            width: 16,
            child: CircleAvatar(
              backgroundColor: primary,
              child: Icon(
                Icons.alarm_rounded,
                size: 12,
                color: _getForegroundColor(primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeadingIcon extends StatelessWidget {
  final PresentStatus? status;
  const LeadingIcon({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final action =
        presentStatusActions.findItem((item) => item.value == status);
    final icon = action == null ? Icons.query_builder_rounded : action.icon;
    final color = action == null ? Colors.grey : action.color;
    return CircleAvatar(
      radius: 21,
      backgroundColor: color?.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }
}

class LeadingReminderIcon extends StatelessWidget {
  final bool notify;
  const LeadingReminderIcon({Key? key, required this.notify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = notify ? Icons.alarm_rounded : Icons.alarm_off_rounded;
    final color = notify ? theme.colorScheme.primary : theme.iconTheme.color;
    return CircleAvatar(
      radius: 21,
      backgroundColor: color?.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }
}
