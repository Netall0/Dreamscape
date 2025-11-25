import 'package:flutter/material.dart';
import 'package:uikit/colors/color_constant.dart';

class AppColors {
  const AppColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.cardBackground,
    required this.dividerColor,
    required this.shadowColor,
  });

  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color cardBackground;
  final Color dividerColor;
  final Color shadowColor;

  static const light = AppColors(
    primary: ColorConstants.primaryLight,
    primaryVariant: Color(0xFF1E40AF),
    secondary: ColorConstants.secondaryLight,
    background: ColorConstants.backgroundLight,
    surface: ColorConstants.surfaceLight,
    error: ColorConstants.errorLight,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: ColorConstants.textPrimaryLight,
    onSurface: ColorConstants.textPrimaryLight,
    onError: Colors.white,
    textPrimary: ColorConstants.textPrimaryLight,
    textSecondary: ColorConstants.textSecondaryLight,
    textDisabled: ColorConstants.textDisabledLight,
    cardBackground: ColorConstants.cardBackgroundLight,
    dividerColor: ColorConstants.dividerColorLight,
    shadowColor: ColorConstants.shadowColorLight,
  );

  static const dark = AppColors(
    primary: ColorConstants.primaryDark,
    primaryVariant: Color(0xFF3B82F6),
    secondary: ColorConstants.secondaryDark,
    background: ColorConstants.backgroundDark,
    surface: ColorConstants.surfaceDark,
    error: ColorConstants.errorDark,
    onPrimary: ColorConstants.backgroundDark,
    onSecondary: ColorConstants.backgroundDark,
    onBackground: ColorConstants.textPrimaryDark,
    onSurface: ColorConstants.textPrimaryDark,
    onError: ColorConstants.backgroundDark,
    textPrimary: ColorConstants.textPrimaryDark,
    textSecondary: ColorConstants.textSecondaryDark,
    textDisabled: ColorConstants.textDisabledDark,
    cardBackground: ColorConstants.cardBackgroundDark,
    dividerColor: ColorConstants.dividerColorDark,
    shadowColor: ColorConstants.shadowColorDark,
  );
}
