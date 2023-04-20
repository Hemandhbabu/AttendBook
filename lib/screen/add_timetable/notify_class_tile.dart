import 'package:flutter/material.dart';

import '../../convert/extension.dart';
import '../../provider/add_timetable_provider.dart';
import '../../tile/switch_tile.dart';
import '../../tile/tile.dart';

class NotifyClassTile extends StatefulWidget {
  final AddTimetableProvider provider;
  final VoidCallback onChanged;
  const NotifyClassTile({
    Key? key,
    required this.provider,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NotifyClassTile> createState() => _NotifyClassTileState();
}

class _NotifyClassTileState extends State<NotifyClassTile> {
  late bool notify;
  late int notifyBefore;
  @override
  void initState() {
    notify = widget.provider.notify;
    notifyBefore = widget.provider.notifyBefore;
    super.initState();
  }

  static const _actions = [
    TileAction(text: 'At the time of class', value: 0),
    TileAction(text: '5 minutes before', value: 5),
    TileAction(text: '10 minutes before', value: 10),
    TileAction(text: '15 minutes before', value: 15),
    TileAction(text: '30 minutes before', value: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutQuint,
        height: notify ? 128 : 56,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 56,
              child: SwitchTile(
                title: 'Notify this class',
                value: notify,
                onChanged: (value) {
                  widget.provider.notify = value;
                  setState(() => notify = value);
                  widget.onChanged();
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
            if (notify)
              Positioned(
                top: 56,
                left: 0,
                right: 0,
                child: Tile(
                  dropdown: true,
                  margin: EdgeInsets.zero,
                  subtitle: 'Notify before',
                  title: _actions
                      .findItem((item) => item.value == notifyBefore)
                      ?.text,
                  pressAction: SheetTileActionData<int>(
                    selectedAction: notifyBefore,
                    actions: _actions,
                    valueChanged: (context, value) {
                      widget.provider.notifyBefore = value;
                      setState(() => notifyBefore = value);
                      widget.onChanged();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
