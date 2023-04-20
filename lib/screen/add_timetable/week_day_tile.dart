import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../provider/add_timetable_provider.dart';
import '../../tile/tile.dart';

class WeekDayTile extends StatefulWidget {
  final AddTimetableProvider provider;
  final VoidCallback onChanged;

  const WeekDayTile({
    Key? key,
    required this.provider,
    required this.onChanged,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _WeekDayTileState createState() => _WeekDayTileState();
}

class _WeekDayTileState extends State<WeekDayTile> {
  int? selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.provider.weekday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tile(
      dropdown: true,
      tileHeight: selectedIndex == null ? 58 : 72,
      color: null,
      margin: EdgeInsets.zero,
      title: selectedIndex == null ? 'Day of week' : weekDays[selectedIndex!],
      subtitle: selectedIndex == null ? null : 'Day of week',
      pressAction: SheetTileActionData<int>(
        selectedAction: selectedIndex,
        actions: List.generate(
          weekDays.length,
          (index) => TileAction(text: weekDays[index], value: index),
        ),
        valueChanged: (context, value) {
          widget.provider.weekday = value;
          setState(() => selectedIndex = value);
          widget.onChanged();
        },
      ),
    );
    // return Wrap(
    //   children: List.generate(
    //     weekDays.length,
    //     (index) => Padding(
    //       padding: const EdgeInsets.all(4.0),
    //       child: ChoiceChip(
    //         backgroundColor: Colors.transparent,
    //         label: Text(weekDays[index]),
    //         selected: selectedIndex == index,
    //         pressElevation: 0,
    //         onSelected:
    //             widget.addTimetableProvider.isNew || selectedIndex == index
    //                 ? (boo) {
    //                     if (selectedIndex != index) {
    //                       setState(() => selectedIndex = index);
    //                       widget.addTimetableProvider.weekday = index;
    //                       widget.onChange();
    //                     }
    //                   }
    //                 : null,
    //       ),
    //     ),
    //   ),
    // );
  }
}
