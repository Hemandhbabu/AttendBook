import 'package:flutter/material.dart';

import '../../tile/tile.dart';

class ColorPicker extends StatefulWidget {
  final Color color;
  final MaterialColor defaultColor;
  final ValueChanged<Color> onChanged;
  final bool openPicker;
  const ColorPicker({
    Key? key,
    required this.color,
    required this.onChanged,
    required this.defaultColor,
    this.openPicker = true,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ColorPickerState createState() => _ColorPickerState();
}

const _duration = Duration(milliseconds: 300);

const _names = [
  'Red',
  'Pink',
  'Purple',
  'Deep Purple',
  'Indigo',
  'Blue',
  'Light Blue',
  'Cyan',
  'Teal',
  'Green',
  'Light Green',
  'Lime',
  'Yellow',
  'Amber',
  'Orange',
  'Deep Orange',
  'Brown',
  'Blue Grey',
];

const _colors = <MaterialColor>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.blueGrey,
];

class _ColorPickerState extends State<ColorPicker> {
  late Color color;
  late bool pick;
  late bool classic;
  late int colorsIndex;

  @override
  void initState() {
    color = widget.color;
    pick = widget.openPicker;
    colorsIndex = _colors.indexOf(widget.defaultColor);
    classic = color == widget.defaultColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: _duration,
        height: pick ? 392 : 64,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Tile(
                title: 'Course color',
                tileHeight: null,
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(4),
                onTap: () => setState(() => pick = !pick),
                trailing: CircleAvatar(backgroundColor: color),
              ),
            ),
            Positioned(
              top: 76,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: _duration,
                    curve: Curves.easeOut,
                    height: 40,
                    width: classic ? 0 : 96,
                  ),
                  Container(
                    height: 40,
                    width: 88,
                    decoration: BoxDecoration(
                      borderRadius: _titleBorder,
                      color: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                    ),
                  ),
                  AnimatedContainer(
                    duration: _duration,
                    curve: Curves.easeOut,
                    height: 40,
                    width: classic ? 96 : 0,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 68,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TitleIndicator(
                    title: 'Classic',
                    selected: classic,
                    onSelected:
                        classic ? null : () => setState(() => classic = true),
                  ),
                  const SizedBox(width: 8),
                  _TitleIndicator(
                    title: 'Custom',
                    selected: !classic,
                    onSelected:
                        classic ? () => setState(() => classic = false) : null,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 12,
              top: 112,
              child: AnimatedCrossFade(
                duration: _duration,
                crossFadeState:
                    pick ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                secondChild: const SizedBox.shrink(),
                firstChild: IgnorePointer(
                  ignoring: !pick,
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: _duration,
                      child: classic
                          ? _ClassicColors(
                              selected: color,
                              colorsIndex: colorsIndex,
                              onChanged: (val) =>
                                  setState(() => colorsIndex = val),
                              colorChanged: (value) {
                                widget.onChanged(value);
                                setState(() {
                                  color = value;
                                  pick = false;
                                });
                              },
                            )
                          : _CustomColors(
                              color: color,
                              colorChanged: (value) {
                                widget.onChanged(value);
                                setState(() => color = value);
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _titleBorder = BorderRadius.all(Radius.circular(20));

class _TitleIndicator extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onSelected;
  const _TitleIndicator({
    Key? key,
    required this.title,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabTheme = theme.floatingActionButtonTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 40,
        width: 88,
        child: InkWell(
          onTap: onSelected,
          borderRadius: _titleBorder,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color:
                    selected ? fabTheme.foregroundColor ?? Colors.white : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomColors extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> colorChanged;
  const _CustomColors({
    Key? key,
    required this.color,
    required this.colorChanged,
  }) : super(key: key);

  @override
  State<_CustomColors> createState() => _CustomColorsState();
}

class _CustomColorsState extends State<_CustomColors> {
  late int red, blue, green;

  @override
  void initState() {
    red = widget.color.red;
    blue = widget.color.blue;
    green = widget.color.green;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        _ColorSlider(
          value: red,
          onChanged: (value) {
            setState(() => red = value);
            widget.colorChanged(Color.fromARGB(255, red, green, blue));
          },
          color: const Color(0xffff0000),
          title: 'Red',
        ),
        _ColorSlider(
          value: green,
          onChanged: (value) {
            setState(() => green = value);
            widget.colorChanged(Color.fromARGB(255, red, green, blue));
          },
          color: const Color(0xff00ff00),
          title: 'Green',
        ),
        _ColorSlider(
          value: blue,
          onChanged: (value) {
            setState(() => blue = value);
            widget.colorChanged(Color.fromARGB(255, red, green, blue));
          },
          color: const Color(0xff0000ff),
          title: 'Blue',
        ),
      ],
    );
  }
}

class _ColorSlider extends StatelessWidget {
  final int value;
  final Color color;
  final String title;
  final ValueChanged<int> onChanged;
  const _ColorSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 23,
                  activeTrackColor: color.withAlpha(191),
                  inactiveTrackColor: color.withAlpha(26),
                  thumbColor: color,
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12.5),
                ),
                child: Slider(
                  min: 0,
                  max: 255,
                  value: value.toDouble(),
                  onChanged: (value) => onChanged(value.toInt()),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          height: 48,
          width: 80,
          child: Card(
            elevation: 0,
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '$value',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassicColors extends StatelessWidget {
  final Color selected;
  final int colorsIndex;
  final ValueChanged<int> onChanged;
  final ValueChanged<Color> colorChanged;
  const _ClassicColors({
    Key? key,
    required this.colorsIndex,
    required this.onChanged,
    required this.colorChanged,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _ColorPickerTitle(
          colorsIndex: colorsIndex,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        _ColorTile(
          selected: selected,
          data: _ColorTileData(
            one: _colors[colorsIndex].shade100,
            two: _colors[colorsIndex].shade200,
            three: _colors[colorsIndex].shade300,
            onChanged: colorChanged,
          ),
        ),
        const SizedBox(height: 16),
        _ColorTile(
          selected: selected,
          data: _ColorTileData(
            one: _colors[colorsIndex].shade400,
            two: _colors[colorsIndex].shade500,
            three: _colors[colorsIndex].shade600,
            onChanged: colorChanged,
          ),
        ),
        const SizedBox(height: 16),
        _ColorTile(
          selected: selected,
          data: _ColorTileData(
            one: _colors[colorsIndex].shade700,
            two: _colors[colorsIndex].shade800,
            three: _colors[colorsIndex].shade900,
            onChanged: colorChanged,
          ),
        ),
      ],
    );
  }
}

class _ColorPickerTitle extends StatelessWidget {
  final int colorsIndex;
  final ValueChanged<int> onChanged;
  const _ColorPickerTitle({
    Key? key,
    required this.colorsIndex,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        IconButton(
          onPressed: colorsIndex == 0 ? null : () => onChanged(colorsIndex - 1),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        Expanded(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: () => showMyAction(
              context,
              SheetTileActionData<int>(
                foldable: true,
                selectedAction: colorsIndex,
                actions: List.generate(
                  _names.length,
                  (index) => TileAction(
                    value: index,
                    text: _names[index],
                    color: _colors[index],
                  ),
                ),
                valueChanged: (context, value) => onChanged(value),
              ),
            ),
            child: Container(
              color: Colors.transparent,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                _names[colorsIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: colorsIndex == (_names.length - 1)
              ? null
              : () => onChanged(colorsIndex + 1),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

const _radius = Radius.circular(12);

class _ColorTile extends StatelessWidget {
  final Color selected;
  final _ColorTileData data;
  const _ColorTile({
    Key? key,
    required this.data,
    required this.selected,
  }) : super(key: key);

  Color get _getForegroundColor {
    final brightness = ThemeData.estimateBrightnessForColor(selected);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  Widget buildItem(Color color, BorderRadius border) => Expanded(
        child: GestureDetector(
          onTap: () => data.onChanged(color),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: _duration,
                decoration: BoxDecoration(color: color, borderRadius: border),
              ),
              if (selected.value == color.value)
                Positioned.fill(
                  child: Icon(Icons.done_rounded, color: _getForegroundColor),
                ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          buildItem(
            data.one,
            const BorderRadius.only(
              topLeft: _radius,
              bottomLeft: _radius,
            ),
          ),
          buildItem(data.two, BorderRadius.zero),
          buildItem(
            data.three,
            const BorderRadius.only(
              topRight: _radius,
              bottomRight: _radius,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorTileData {
  final Color one;
  final Color two;
  final Color three;
  final ValueChanged<Color> onChanged;

  const _ColorTileData({
    required this.one,
    required this.two,
    required this.three,
    required this.onChanged,
  });
}
