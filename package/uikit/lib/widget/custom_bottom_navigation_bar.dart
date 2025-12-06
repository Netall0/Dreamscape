// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.color,
    required this.height,
    required this.borderValue,
    required this.items,
    required this.currentIndex, required this.onTap,
  });

  final Color color;
  final double height;
  final double borderValue;
  final int currentIndex;


  //typedef ValueChanged<T> = void Function(T value); => for callbacks that report that a value has been set.


  final ValueChanged<int> onTap;

  final List<CustomBottomNavigationBarItems> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ColoredBox(
        color: color,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: .circular(borderValue),
              topRight: .circular(borderValue),
            ),
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              return _NavItem(index: i, currentIndex: currentIndex, onTap: onTap );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.circle,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}

final class CustomBottomNavigationBarItems {
  final String name;
  final Icon icons;

  CustomBottomNavigationBarItems({required this.name, required this.icons});
}
