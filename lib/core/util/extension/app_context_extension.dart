import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

extension AppThemeBuildContextProps on BuildContext {
  AppTheme get appTheme => Theme.of(this).extension<AppTheme>()!;
  AppColors get colors => appTheme.colors;
  AppFonts get typography => appTheme.typography;
}
