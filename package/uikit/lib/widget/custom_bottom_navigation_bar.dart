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
    required this.currentIndex,
    required this.onTap,
    required this.route,
    required this.activeColor,
    required this.inactiveColor,
  });

  final Color color;
  final double height;
  final double borderValue;
  final int currentIndex;
  final String route;
  final Color activeColor;
  final Color inactiveColor;

  //typedef ValueChanged<T> = void Function(T value); => for callbacks that report that a value has been set.

  final ValueChanged<int> onTap;

  final List<CustomBottomNavigationBarItems> items;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height),
      child: ColoredBox(
        color: color,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: .circular(borderValue),
              topRight: .circular(borderValue),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(items.length, (i) {
                return _NavItem(
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  icons: items[i].icons.icon ?? Icons.home,
                  name: items[i].name,
                  index: i,
                  currentIndex: currentIndex,
                  onTap: onTap,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.inactiveColor,
    required this.activeColor,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.name,
    required this.icons,
  });
  final Color activeColor;
  final Color inactiveColor;
  final String name;
  final IconData icons;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          Icon(icons, color: isActive ? activeColor : inactiveColor),
          Text(name),
        ],
      ),
    );
  }
}

final class CustomBottomNavigationBarItems {
  final String name;
  final Icon icons;
  final String routes;

  CustomBottomNavigationBarItems({
    required this.name,
    required this.icons,
    required this.routes,
  });
}
