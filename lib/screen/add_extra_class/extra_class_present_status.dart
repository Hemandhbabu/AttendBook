import 'package:attend_book/convert/extension.dart';
import 'package:flutter/material.dart';

import '../../helpers/enums.dart' show PresentStatus;
import '../../tile/tile.dart';

class ExtraClassPresentStatus extends StatefulWidget {
  final PresentStatus? presentStatus;
  final ValueChanged<PresentStatus> callback;

  const ExtraClassPresentStatus({
    Key? key,
    required this.presentStatus,
    required this.callback,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ExtraClassPresentStatusState createState() =>
      _ExtraClassPresentStatusState();
}

class _ExtraClassPresentStatusState extends State<ExtraClassPresentStatus> {
  PresentStatus? status;
  bool initialized = false;
  @override
  void initState() {
    if (!initialized) {
      status = widget.presentStatus;
      initialized = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final action = status == null ? null : presentStatusActions[status!.index];
    return Tile(
      tileHeight: action == null ? 56 : 72,
      title: action?.text ?? 'Status',
      subtitle: action?.let((value) => 'Status'),
      titleColor: action?.color,
      color: null,
      dropdown: true,
      // trailing: Text(
      //   action ?? 'Not selected',
      //   maxLines: 1,
      //   style: TextStyle(
      //     color: action?.color,
      //     fontSize: 16,
      //   ),
      // ),
      margin: EdgeInsets.zero,
      pressAction: SheetTileActionData<PresentStatus>(
        actions: presentStatusActions,
        selectedAction: status,
        valueChanged: (context, val) {
          setState(() => status = val);
          widget.callback(val);
        },
      ),
    );
  }
}
