import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';
import 'package:flutter_localization/flutter_localization.dart';

extension AppThemeBuildContextProps on BuildContext {
  AppTheme get appTheme => Theme.of(this).extension<AppTheme>()!;
  AppColors get colors => appTheme.colors;
  LayoutInherited get layout => LayoutInherited.of(this);
  AppFonts get typography => appTheme.typography;

  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
