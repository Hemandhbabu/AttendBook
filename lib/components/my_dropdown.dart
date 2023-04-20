import 'package:flutter/material.dart';

import '../screen/add_subject/add_subject_screen.dart';
import '../tile/tile.dart';

typedef IntCallback = void Function(int i);

class MyDropdown extends StatefulWidget {
  final List<MyDropdownItem> items;
  final int? value;
  final IntCallback intCallback;
  final bool isSubject;
  final String prefixText;
  final String emptyText;
  final String unselectedText;

  const MyDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.intCallback,
    this.isSubject = false,
    required this.prefixText,
    required this.emptyText,
    required this.unselectedText,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SubjectDropdownState createState() => _SubjectDropdownState();
}

class _SubjectDropdownState extends State<MyDropdown> {
  int dropDownValue = -1;
  @override
  void initState() {
    if (widget.items.isEmpty && widget.isSubject) {
      Future.delayed(Duration.zero).then(
        (value) => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () {
              Navigator.pop(context);
              Navigator.pop(context);
              return Future.value(false);
            },
            child: AlertDialog(
              content: const Text('You have no subjects.\nTry adding some.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AddSubjectScreen.route);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.value != null && dropDownValue != widget.value) {
      setState(() {
        dropDownValue = widget.value!;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.items.isNotEmpty
        ? Tile(
            margin: EdgeInsets.zero,
            title: dropDownValue == -1
                ? widget.unselectedText
                : widget.items.firstWhere((e) => e.value == dropDownValue).name,
            subtitle: widget.prefixText,
            dropdown: true,
            color: null,
            pressAction: SheetTileActionData<int>(
              selectedAction: dropDownValue,
              actions: widget.items
                  .map((e) => TileAction(text: e.name, value: e.value))
                  .toList(),
              valueChanged: (context, val) {
                setState(() => dropDownValue = val);
                widget.intCallback(val);
              },
            ),
          )
        : Tile(
            title: widget.emptyText,
            margin: EdgeInsets.zero,
            subtitle: widget.prefixText,
          );
  }
}

class MyDropdownItem {
  final String name;
  final int value;

  const MyDropdownItem(this.name, this.value);
}
