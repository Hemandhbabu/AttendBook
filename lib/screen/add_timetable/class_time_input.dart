import 'package:attend_book/helpers/theme.dart';
import 'package:flutter/material.dart';

import '../../convert/extension.dart';

typedef DateCallback = void Function(DateTime dateTime);

class ClassTimeInput extends StatefulWidget {
  final DateTime? time;
  final DateCallback callback;
  const ClassTimeInput({
    Key? key,
    required this.time,
    required this.callback,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClassTimeInputState createState() => _ClassTimeInputState();
}

class _ClassTimeInputState extends State<ClassTimeInput> {
  late DateTime varTime;

  @override
  void initState() {
    varTime = widget.time ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () async {
          final timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(varTime),
          );
          if (timeOfDay != null) {
            final date = DateTime(2020, 1, 1).copyTimeOfDay(timeOfDay);
            setState(() => varTime = date);
            widget.callback(date);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Opacity(
                opacity: 0.7,
                child: Text('Time', style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(width: double.infinity, height: 4),
              Text(
                varTime
                    .timeFormat(MediaQuery.of(context).alwaysUse24HourFormat),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
