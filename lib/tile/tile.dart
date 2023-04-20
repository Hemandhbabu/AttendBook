import 'package:flutter/material.dart';

import '../../helpers/theme.dart' as theme;
import '../components/my_progressbar.dart';
import '../convert/extension.dart';
import '../helpers/enums.dart';

part 'tile_actions.dart';
part 'tile_data.dart';

const _duration = Duration(milliseconds: 300);

class Tile<M, P> extends StatelessWidget {
  final Widget? leading;
  final double? leadingProgress;
  final String? title;
  final String? subtitle;
  final String? trailingTitle;
  final String? trailingSubtitle;
  final Widget? trailing;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final SheetTileActionData<M>? moreAction;
  final SheetTileActionData<P>? pressAction;
  final VoidCallback? onTap;
  final bool enabled;
  final bool strikeThrough;
  final Color? color;
  final Color? titleColor;
  final Color? trailingIndicatorColor;
  final TextBuilderWithValue? leadingTextBuilder;
  final String Function()? leadingSubtextBuilder;
  final double? tileHeight;
  final double trailingWidgetGap;
  final double trailingTextSize;
  final bool dropdown;
  final bool dense;
  final bool allowManyLines;
  final bool showTileOnActions;
  final CrossAxisAlignment trailingAlignment;
  const Tile({
    Key? key,
    this.leading,
    this.leadingProgress,
    this.title,
    this.titleColor,
    this.subtitle,
    this.trailingTitle,
    this.trailingSubtitle,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.borderRadius = theme.borderRadius,
    this.moreAction,
    this.pressAction,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.color = Colors.transparent,
    this.trailingIndicatorColor,
    this.leadingTextBuilder,
    this.leadingSubtextBuilder,
    this.tileHeight = 72,
    this.trailingTextSize = 13,
    this.trailingWidgetGap = 6,
    this.showTileOnActions = false,
    this.dropdown = false,
    this.trailingAlignment = CrossAxisAlignment.end,
    this.strikeThrough = false,
    this.dense = false,
    this.allowManyLines = false,
  })  : assert(pressAction == null || onTap == null),
        super(key: key);

  Tile showManyLines() => Tile(
        leading: leading,
        leadingProgress: leadingProgress,
        title: title,
        titleColor: titleColor,
        subtitle: subtitle,
        trailingTitle: trailingTitle,
        trailingSubtitle: trailingSubtitle,
        trailing: trailing,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: borderRadius,
        moreAction: null,
        pressAction: null,
        onTap: null,
        enabled: true,
        strikeThrough: strikeThrough,
        color: null,
        trailingIndicatorColor: trailingIndicatorColor,
        leadingTextBuilder: leadingTextBuilder,
        leadingSubtextBuilder: leadingSubtextBuilder,
        tileHeight: null,
        trailingWidgetGap: trailingWidgetGap,
        trailingTextSize: trailingTextSize,
        dropdown: dropdown,
        dense: dense,
        showTileOnActions: false,
        trailingAlignment: trailingAlignment,
        allowManyLines: true,
      );

  Widget? buildTextWidget(String? text, bool strikeThrough, bool manyLines,
      [TextStyle? style]) {
    return text == null || text.isEmpty
        ? null
        : Text(
            text,
            maxLines: manyLines ? null : 1,
            overflow: manyLines ? null : TextOverflow.ellipsis,
            style: strikeThrough
                ? (style ?? const TextStyle()).copyWith(
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 2,
                  )
                : style,
          );
  }

  Widget? getTrailing(BuildContext context) {
    final color = Theme.of(context).textTheme.bodySmall?.color;
    final style = TextStyle(color: color, fontSize: trailingTextSize);
    final child1 = buildTextWidget(trailingTitle, false, false, style);
    final child2 = buildTextWidget(trailingSubtitle, false, false, style);
    final trail = child1 != null && child2 != null
        ? Column(
            crossAxisAlignment: trailingAlignment,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [child1, SizedBox(height: trailingWidgetGap), child2],
          )
        : child1 ?? child2 ?? trailing;
    return dropdown
        ? trail != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [trail, const Icon(Icons.arrow_drop_down_rounded)],
              )
            : const Icon(Icons.arrow_drop_down_rounded)
        : trail;
  }

  @override
  Widget build(BuildContext context) {
    Widget tile = ListTile(
      leading: leadingProgress != null
          ? LeadingProgress(
              value: leadingProgress!,
              textBuilder: leadingTextBuilder,
              subtextBuilder: leadingSubtextBuilder,
            )
          : leading,
      dense: dense,
      title: buildTextWidget(
        title,
        strikeThrough,
        allowManyLines,
        TextStyle(fontSize: 16, color: titleColor),
      ),
      subtitle: buildTextWidget(
        subtitle,
        strikeThrough,
        allowManyLines,
        const TextStyle(fontSize: 13),
      ),
      trailing: getTrailing(context),
      enabled: enabled,
    );
    tile = SizedBox(height: tileHeight, child: Center(child: tile));
    if (trailingIndicatorColor != null) {
      tile = Row(
        children: [
          Expanded(child: tile),
          Center(
            child: Container(
              height: 42,
              width: 3,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: trailingIndicatorColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      );
    }
    final child = Card(
      color: color,
      elevation: 0,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        highlightColor: Colors.transparent,
        borderRadius: borderRadius,
        onTap: pressAction == null
            ? onTap
            : () => showMyAction(
                  context,
                  pressAction!,
                  moreAction,
                  showTileOnActions ? this : null,
                ),
        child: Padding(padding: padding, child: tile),
      ),
    );
    return enabled ? child : IgnorePointer(child: child);
  }
}

class _SlidableTile<T> extends StatefulWidget {
  final Widget child;
  final SlideableTileActionData<T> action;
  const _SlidableTile({
    Key? key,
    required this.child,
    required this.action,
  }) : super(key: key);

  @override
  _SlidableTileState<T> createState() => _SlidableTileState<T>();
}

class _SlidableTileState<T> extends State<_SlidableTile<T>>
    with SingleTickerProviderStateMixin {
  bool open = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _animation = Tween(
      begin: Offset.zero,
      end: Offset(-widget.action.actions.length * 0.2, 0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SlideTransition(
          position: _animation,
          child: GestureDetector(
            onTap: () {
              setState(() => open = !open);
              open ? _controller.forward() : _controller.reverse();
            },
            child: widget.child,
          ),
        ),
        AnimatedPositioned(
          duration: _duration,
          top: 0,
          bottom: 0,
          left:
              open ? width * (1 - (widget.action.actions.length * 0.2)) : width,
          right: 0,
          child: Row(
            children: [
              ...widget.action.actions.map((e) => _SlidableAction<T>(
                    action: e,
                    onTap: widget.action.valueChanged,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _SlidableAction<T> extends StatelessWidget {
  final TileAction<T> action;
  final void Function(BuildContext context, T value) onTap;
  const _SlidableAction({
    Key? key,
    required this.action,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(context, action.value),
        child: Container(
          color: action.color ?? Theme.of(context).canvasColor,
          height: double.infinity,
          child: Icon(action.icon),
        ),
      ),
    );
  }
}

class ActionButtons<T> extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.actionData,
    this.expanded = true,
  }) : super(key: key);

  final BottomButtonTileActionData<T> actionData;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          expanded ? const EdgeInsets.fromLTRB(8, 0, 8, 8) : EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          actionData.actions.length,
          (index) {
            final action = actionData.actions[index];
            return _ActionButton<T>(
              key: ValueKey(action.value),
              isSelected: action.value == actionData.selectedAction,
              isText: actionData.isText,
              action: actionData.actions[index],
              callback: actionData.valueChanged,
              expanded: expanded,
            );
          },
        ),
      ),
    );
  }
}

class _ActionButton<T> extends StatelessWidget {
  final TileAction<T> action;
  final void Function(BuildContext context, T value) callback;
  final bool isText, isSelected;

  /// [expanded] is true means the action button takes the available space.
  ///
  /// If not expanded [isSelected] and [isText] is useless.
  /// Default value of [expanded] is true.
  final bool expanded;

  const _ActionButton({
    Key? key,
    this.isText = true,
    required this.isSelected,
    required this.action,
    required this.callback,
    this.expanded = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return expanded
        ? Expanded(
            child: isText
                ? TextButton.icon(
                    onPressed: () => callback(context, action.value),
                    icon: Icon(action.icon),
                    label: Text(action.text, textAlign: TextAlign.center),
                    style: TextButton.styleFrom(
                      foregroundColor: action.color,
                      backgroundColor:
                          isSelected ? action.color?.withOpacity(0.1) : null,
                      shape: const StadiumBorder(),
                    ),
                  )
                : Tooltip(
                    message: action.text,
                    child: TextButton(
                      onPressed: () => callback(context, action.value),
                      style: TextButton.styleFrom(
                        foregroundColor: action.color,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor:
                            isSelected ? action.color?.withOpacity(0.1) : null,
                        shape: const StadiumBorder(),
                      ),
                      child: Icon(action.icon),
                    ),
                  ),
          )
        : IconButton(
            tooltip: action.text,
            icon: Icon(action.icon),
            color: action.color,
            onPressed: () => callback(context, action.value),
          );
  }
}

Future<void> showMyAction<T, V>(
    BuildContext context, SheetTileActionData<T> actionData,
    [SheetTileActionData<V>? moreActionData, Tile? tile]) {
  const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
  final actionLength = actionData.actions.length;
  final moreLength = moreActionData == null ? 0 : moreActionData.actions.length;
  final length = moreLength + (moreActionData == null ? actionLength : 0);
  final mediaQuery = MediaQuery.of(context);
  final height = mediaQuery.size.height - 40;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints.loose(Size.fromHeight(height)),
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (tile != null) tile.showManyLines(),
            if (tile != null) const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              shape: shape,
              child: Wrap(
                children: List.generate(
                  length,
                  (index) {
                    if (moreActionData != null) {
                      final action = moreActionData.actions[index];
                      final isSelected =
                          moreActionData.selectedAction == action.value;
                      final foldable = actionData.forceFold ||
                          moreActionData.foldable && length > 8;
                      return _ActionTile<V>(
                        action: action,
                        isSelected: isSelected,
                        foldable: foldable,
                        callback: (val) {
                          Navigator.of(context).pop();
                          moreActionData.valueChanged(context, val);
                        },
                      );
                    } else {
                      final action = actionData.actions[index];
                      final isSelected =
                          actionData.selectedAction == action.value;
                      final foldable = actionData.forceFold ||
                          actionData.foldable && length > 8;
                      return _ActionTile<T>(
                        action: action,
                        isSelected: isSelected,
                        foldable: foldable,
                        callback: (val) {
                          Navigator.of(context).pop();
                          if (!isSelected) {
                            actionData.valueChanged(context, val);
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              shape: shape,
              child: moreActionData != null
                  ? _ActionTile<int>(
                      hasMargin: false,
                      isSelected: false,
                      foldable: false,
                      action: const TileAction(
                        text: 'More',
                        value: 0,
                      ),
                      callback: (_) {
                        Navigator.pop(context);
                        showMyAction(context, actionData);
                      },
                    )
                  : _ActionTile<int>(
                      hasMargin: false,
                      isSelected: false,
                      foldable: false,
                      action: const TileAction(
                        text: 'Done',
                        value: 1,
                      ),
                      callback: (_) => Navigator.pop(context),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActionTile<T> extends StatelessWidget {
  final bool isSelected;
  final TileAction<T> action;
  final ValueChanged<T> callback;
  final bool foldable;
  final bool hasMargin;

  const _ActionTile({
    Key? key,
    required this.action,
    required this.callback,
    this.isSelected = false,
    required this.foldable,
    this.hasMargin = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.secondary;
    return LayoutBuilder(builder: (context, constraints) {
      final width = foldable ? constraints.biggest.width / 2 : null;
      return SizedBox(
        width: width,
        child: Card(
          elevation: 0,
          margin: hasMargin ? const EdgeInsets.all(4) : EdgeInsets.zero,
          color: isSelected
              ? (action.color ?? selectedColor).withOpacity(0.15)
              : Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: InkWell(
            highlightColor: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: () => callback(action.value),
            child: ListTile(
              dense: true,
              selected: isSelected,
              leading: action.icon == null
                  ? null
                  : Icon(action.icon, color: action.color),
              title: Text(
                action.text,
                textAlign: action.icon == null ? TextAlign.center : null,
                style: TextStyle(color: action.color, fontSize: 17),
              ),
            ),
          ),
        ),
      );
    });
  }
}
