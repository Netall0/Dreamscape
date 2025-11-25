import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
import 'package:uikit/colors/app_colors.dart';
import 'package:uikit/fonts/app_fonts.dart';



part 'app_theme.tailor.dart';

@TailorMixin()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeTailorMixin {
  const AppTheme({required this.colors, required this.typography});

  @override
  final AppColors colors;

  @override
  final AppFonts typography;

  static const light = AppTheme(
    colors: AppColors.light,
    typography: AppFonts.light,
  );

  static const dark = AppTheme(
    colors: AppColors.dark,
    typography: AppFonts.dark,
  );
}

extension AppThemeExtension on AppTheme {
  List<MapEntry<String, Color>> get colorEntries => [
    MapEntry('primary', colors.primary),
    MapEntry('secondary', colors.secondary),
    MapEntry('background', colors.background),
    MapEntry('surface', colors.surface),
    MapEntry('error', colors.error),
    MapEntry('onPrimary', colors.onPrimary),
    MapEntry('onSecondary', colors.onSecondary),
    MapEntry('onBackground', colors.onBackground),
    MapEntry('onSurface', colors.onSurface),
    MapEntry('onError', colors.onError),
    MapEntry('textPrimary', colors.textPrimary),
    MapEntry('textSecondary', colors.textSecondary),
    MapEntry('textDisabled', colors.textDisabled),
  ];

  List<MapEntry<String, TextStyle>> get textStyleEntries => [
    MapEntry('h1', typography.h1),
    MapEntry('h2', typography.h2),
    MapEntry('h3', typography.h3),
    MapEntry('h4', typography.h4),
    MapEntry('h5', typography.h5),
    MapEntry('h6', typography.h6),
    MapEntry('bodyLarge', typography.bodyLarge),
    MapEntry('bodyMedium', typography.bodyMedium),
    MapEntry('bodySmall', typography.bodySmall),
    MapEntry('caption', typography.caption),
    MapEntry('overline', typography.overline),
  ];
}
