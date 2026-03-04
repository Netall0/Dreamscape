import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/custom_bottom_navigation_bar.dart';

import '../../../core/util/extension/app_context_extension.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

class RootScreen extends StatefulWidget {
  const RootScreen(this._navigationShell, {super.key});

  final StatefulNavigationShell _navigationShell;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<CrystalNavigationBarItem> items = [
    CrystalNavigationBarItem(icon: Icons.home_outlined),
    CrystalNavigationBarItem(icon: Icons.search_off_outlined),
    CrystalNavigationBarItem(icon: Icons.settings_outlined),
  ];

  void change(int index) {
    widget._navigationShell.goBranch(
      index,
      initialLocation: index == widget._navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    return Scaffold(
      body: widget._navigationShell,

      bottomNavigationBar: Padding(
        padding: const .symmetric(horizontal: 40),
        child: CrystalNavigationBar(
          selectedItemColor: theme.colors.primary,
          unselectedItemColor: theme.colors.background,
          height: AppSizes.screenHeightOfContext(context) * 0.07,
          items: items,
          borderWidth: 2,
          currentIndex: widget._navigationShell.currentIndex,
          onTap: (index) => change(index),
        ),
      ),
    );
  }
}
