import 'package:flutter/material.dart';
import 'package:uikit/fonts/fonts_consant.dart';
import 'package:uikit/colors/color_constant.dart';

class AppFonts {
  const AppFonts({
    required this.fontFamily,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.h6,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.caption,
    required this.overline,
  });

  final String fontFamily;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle h6;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle caption;
  final TextStyle overline;

  static const light = AppFonts(
    fontFamily: AppTypographyConstants.fontFamilyBody,
    h1: TextStyle(
      fontSize: AppTypographyConstants.h1,
      fontWeight: FontWeight.bold,
      height: AppTypographyConstants.lineHeightTight,
      letterSpacing: AppTypographyConstants.letterSpacingTight,
      color: ColorConstants.textPrimaryLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h2: TextStyle(
      fontSize: AppTypographyConstants.h2,
      fontWeight: FontWeight.bold,
      height: AppTypographyConstants.lineHeightTight,
      color: ColorConstants.textPrimaryLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h3: TextStyle(
      fontSize: AppTypographyConstants.h3,
      fontWeight: FontWeight.w600,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.gray700,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h4: TextStyle(
      fontSize: AppTypographyConstants.h4,
      fontWeight: FontWeight.w600,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.gray700,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h5: TextStyle(
      fontSize: AppTypographyConstants.h5,
      fontWeight: FontWeight.w500,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.gray600,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h6: TextStyle(
      fontSize: AppTypographyConstants.h6,
      fontWeight: FontWeight.w500,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.textPrimaryLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    bodyLarge: TextStyle(
      fontSize: AppTypographyConstants.bodyLarge,
      fontWeight: FontWeight.normal,
      height: AppTypographyConstants.lineHeightRelaxed,
      color: ColorConstants.textPrimaryLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    bodyMedium: TextStyle(
      fontSize: AppTypographyConstants.bodyMedium,
      fontWeight: FontWeight.normal,
      height: AppTypographyConstants.lineHeightRelaxed,
      color: ColorConstants.textSecondaryLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    bodySmall: TextStyle(
      fontSize: AppTypographyConstants.bodySmall,
      fontWeight: FontWeight.normal,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.textSecondaryLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    caption: TextStyle(
      fontSize: AppTypographyConstants.caption,
      fontWeight: FontWeight.normal,
      color: ColorConstants.textDisabledLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    overline: TextStyle(
      fontSize: AppTypographyConstants.overline,
      fontWeight: FontWeight.w500,
      letterSpacing: AppTypographyConstants.letterSpacingWide,
      color: ColorConstants.textDisabledLight,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
  );

  static const dark = AppFonts(
    fontFamily: AppTypographyConstants.fontFamilyBody,
    h1: TextStyle(
      fontSize: AppTypographyConstants.h1,
      fontWeight: FontWeight.bold,
      height: AppTypographyConstants.lineHeightTight,
      letterSpacing: AppTypographyConstants.letterSpacingTight,
      color: ColorConstants.textPrimaryDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h2: TextStyle(
      fontSize: AppTypographyConstants.h2,
      fontWeight: FontWeight.bold,
      height: AppTypographyConstants.lineHeightTight,
      color: ColorConstants.textPrimaryDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h3: TextStyle(
      fontSize: AppTypographyConstants.h3,
      fontWeight: FontWeight.w600,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.slate200,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h4: TextStyle(
      fontSize: AppTypographyConstants.h4,
      fontWeight: FontWeight.w600,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.slate200,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h5: TextStyle(
      fontSize: AppTypographyConstants.h5,
      fontWeight: FontWeight.w500,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.slate300,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    h6: TextStyle(
      fontSize: AppTypographyConstants.h6,
      fontWeight: FontWeight.w500,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.slate300,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    bodyLarge: TextStyle(
      fontSize: AppTypographyConstants.bodyLarge,
      fontWeight: FontWeight.normal,
      height: AppTypographyConstants.lineHeightRelaxed,
      color: ColorConstants.textPrimaryDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    bodyMedium: TextStyle(
      fontSize: AppTypographyConstants.bodyMedium,
      fontWeight: FontWeight.normal,
      height: AppTypographyConstants.lineHeightRelaxed,
      color: ColorConstants.textSecondaryDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    bodySmall: TextStyle(
      fontSize: AppTypographyConstants.bodySmall,
      fontWeight: FontWeight.normal,
      height: AppTypographyConstants.lineHeightNormal,
      color: ColorConstants.textSecondaryDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    caption: TextStyle(
      fontSize: AppTypographyConstants.caption,
      fontWeight: FontWeight.normal,
      color: ColorConstants.textDisabledDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
    overline: TextStyle(
      fontSize: AppTypographyConstants.overline,
      fontWeight: FontWeight.w500,
      letterSpacing: AppTypographyConstants.letterSpacingWide,
      color: ColorConstants.textDisabledDark,
      fontFamily: AppTypographyConstants.fontFamilyBody,
    ),
  );
}
