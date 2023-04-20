import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 300);
const _curve = Curves.easeInOut;

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavigationBarItem> items;
  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  })  : assert(items.length > 1),
        super(key: key);

  Widget buildItem(
    ThemeData theme,
    int index,
    CustomBottomNavigationBarItem item,
  ) {
    final selected = currentIndex == index;
    final primary = theme.colorScheme.primary;
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => onTap(index),
        child: Center(
          child: SizedBox(
            height: 32,
            width: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  height: selected ? 32 : 0,
                  width: selected ? 56 : 0,
                  duration: _duration,
                  curve: _curve,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: selected
                        ? primary.withOpacity(0.18)
                        : Colors.transparent,
                  ),
                ),
                AnimatedTheme(
                  curve: _curve,
                  duration: _duration,
                  data: theme.copyWith(
                    iconTheme: IconThemeData(
                      color: selected ? primary : theme.iconTheme.color,
                    ),
                  ),
                  child: Icon(item.icon),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.card,
      child: SizedBox(
        height: 52,
        child: Row(
          children: List.generate(
            items.length,
            (index) => buildItem(theme, index, items[index]),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBarItem {
  final IconData icon;

  const CustomBottomNavigationBarItem(this.icon);
}
