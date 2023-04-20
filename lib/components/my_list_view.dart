import 'package:attend_book/components/scroll_notification_wrapper.dart';
import 'package:flutter/material.dart';

import 'center_text.dart';

typedef ValueBuilder<T> = T Function(int index);

class MyListView extends StatelessWidget {
  final String keyString;
  final int itemCount;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final bool scrollable;
  final ValueBuilder<Widget> itemBuilder;
  final String? emptyText;
  final ScrollController? controller;

  const MyListView({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.scrollable = true,
    required this.itemCount,
    required this.itemBuilder,
    this.emptyText = 'List is empty.',
    this.controller,
    required this.keyString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && emptyText != null) return CenterText(emptyText!);
    return ScrollNotificationWrapper(
      keyString: keyString,
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        controller: controller,
        physics: scrollable ? null : const NeverScrollableScrollPhysics(),
        padding: padding,
        itemBuilder: (_, index) => itemBuilder(index),
        itemCount: itemCount,
      ),
    );
  }
}

// typedef T ValueBuilder<T>(int index);
// const _animDuration = Duration(milliseconds: 500);

// class MyListView extends StatefulWidget {
//   final int itemCount;
//   final EdgeInsets padding;
//   final bool shrinkWrap;
//   final bool scrollable;
//   final List<String> ids;
//   final List<Widget> children;
//   final Duration duration;
//   final String? emptyText;

//   MyListView({
//     Key? key,
//     this.padding = EdgeInsets.zero,
//     this.shrinkWrap = false,
//     this.scrollable = true,
//     required this.itemCount,
//     required ValueBuilder<String> idBuilder,
//     required ValueBuilder<Widget> itemBuilder,
//     this.duration = _animDuration,
//     this.emptyText = 'List is empty.',
//   })  : ids = List.generate(itemCount, idBuilder),
//         children = List.generate(itemCount, itemBuilder),
//         super(key: key);

//   @override
//   _MyListViewState createState() => _MyListViewState();
// }

// class _MyListViewState extends State<MyListView> {
//   final _key = GlobalKey<AnimatedListState>();

//   @override
//   void didUpdateWidget(covariant MyListView oldWidget) {
//     final oldIds = oldWidget.ids;
//     final newIds = widget.ids;
//     final currentState = _key.currentState;
//     for (var i = 0; i < oldIds.length; i++)
//       if (!newIds.contains(oldIds[i]))
//         currentState?.removeItem(
//           i,
//           (context, animation) => RemoveTransition(
//             animation: animation,
//             child: oldWidget.children[i],
//           ),
//           duration: widget.duration,
//         );
//     for (var i = 0; i < newIds.length; i++)
//       if (!oldIds.contains(newIds[i]))
//         currentState?.insertItem(i, duration: widget.duration);
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.itemCount == 0 && widget.emptyText != null)
//       return CenterText(text: widget.emptyText!);
//     return AnimatedList(
//       key: _key,
//       shrinkWrap: widget.shrinkWrap,
//       physics: widget.scrollable ? null : NeverScrollableScrollPhysics(),
//       padding: widget.padding,
//       itemBuilder: (_, index, animation) => InsertTransition(
//         animation: animation,
//         child: widget.children[index],
//       ),
//       initialItemCount: widget.itemCount,
//     );
//   }
// }

// class InsertTransition extends AnimatedWidget {
//   final Widget child;
//   const InsertTransition({
//     Key? key,
//     required Animation<double> animation,
//     required this.child,
//   }) : super(key: key, listenable: animation);

//   Animation<double> get animation => listenable as Animation<double>;

//   @override
//   Widget build(BuildContext context) {
//     final value = animation.value;
//     final Matrix4 transform = Matrix4.identity()..scale(value, value, 1.0);
//     return ClipRect(
//       child: Align(
//         alignment: AlignmentDirectional(-1.0, 0.0),
//         heightFactor: math.max(value, 0.0),
//         child: Transform(
//           transform: transform,
//           alignment: Alignment.center,
//           child: Opacity(opacity: value, child: child),
//         ),
//       ),
//     );
//   }
// }

// class RemoveTransition extends AnimatedWidget {
//   final Widget child;
//   const RemoveTransition({
//     Key? key,
//     required Animation<double> animation,
//     required this.child,
//   }) : super(key: key, listenable: animation);

//   Animation<double> get animation => listenable as Animation<double>;
//   Animation<Offset> get position => animation
//       .drive(Tween(begin: const Offset(1, 0), end: const Offset(0, 0)));

//   @override
//   Widget build(BuildContext context) {
//     final value = animation.value;
//     return ClipRect(
//       child: Align(
//         alignment: AlignmentDirectional(-1.0, 0.0),
//         heightFactor: math.max(value, 0.0),
//         child: FractionalTranslation(
//           translation: position.value,
//           transformHitTests: true,
//           child: Opacity(opacity: value, child: child),
//         ),
//       ),
//     );
//   }
// }
