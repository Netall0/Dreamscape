import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

extension AppThemeBuildContextProps on BuildContext {
  AppTheme get appTheme => Theme.of(this).extension<AppTheme>()!;
  AppColors get colors => appTheme.colors;
  LayoutInherited get layout => LayoutInherited.of(this);
  AppFonts get typography => appTheme.typography;
  Size get sizeOf => MediaQuery.sizeOf(this);
}
