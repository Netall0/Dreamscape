import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/custom_bottom_navigation_bar.dart';
import 'package:uikit/widget/gradient_background.dart';

class RootScreen extends StatefulWidget {
  const RootScreen(this._navigationShell, {super.key});

  final StatefulNavigationShell _navigationShell;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<CustomBottomNavigationBarItems> items = [
    CustomBottomNavigationBarItems(name: 'home', icons: Icon(Icons.home)),
    CustomBottomNavigationBarItems(name: 'stats', icons: Icon(Icons.graphic_eq)),
    CustomBottomNavigationBarItems(name: 'profile', icons: Icon(Icons.person)),
  ];

  void change(int index) {
    widget._navigationShell.goBranch(
      index,
      initialLocation: index == widget._navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: widget._navigationShell,
      bottomNavigationBar: CustomBottomNavigationBar(
        activeColor: colors.primary,
        inactiveColor: colors.textSecondary,
        route: '/home',
        color: colors.cardBackground.withOpacity(0.8),
        height: AppSizes.screenHeightOfContext(context) * 0.07,
        borderValue: AppSizes.radiusMedium,
        items: items,
        currentIndex: widget._navigationShell.currentIndex,
        onTap: (index) => change(index),
      ),
    );
  }
}
