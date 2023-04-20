import 'package:flutter/material.dart';

typedef IntCallback = void Function(int i);

class DurationSeekbar extends StatefulWidget {
  final bool isNew;
  final int duration;
  final IntCallback callback;

  const DurationSeekbar({
    Key? key,
    required this.isNew,
    required this.duration,
    required this.callback,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DurationSeekbarState createState() => _DurationSeekbarState();
}

class _DurationSeekbarState extends State<DurationSeekbar> {
  int value = 60;
  bool initialized = false;
  @override
  void initState() {
    if (!widget.isNew && !initialized) {
      value = widget.duration;
      initialized = true;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (value != widget.duration) {
      value = widget.duration;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Class duration : '),
                Text('$value minutes'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: value <= 30
                      ? null
                      : () {
                          setState(() => value -= 5);
                          widget.callback(value);
                        },
                ),
                Expanded(
                  child: Slider.adaptive(
                    min: 0,
                    max: 54,
                    divisions: 55,
                    value: (value.toDouble() - 30) / 5,
                    onChanged: (val) {
                      setState(() => value = (val.ceil() * 5) + 30);
                      widget.callback(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: value >= 300
                      ? null
                      : () {
                          setState(() => value += 5);
                          widget.callback(value);
                        },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Text('Min : 30'),
                Spacer(),
                Text('Max : 300'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
