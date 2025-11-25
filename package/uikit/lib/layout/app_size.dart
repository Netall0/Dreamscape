import 'package:flutter/material.dart';

/// Frequent sizes.
abstract class AppSizes {
  static double screenHeightOfContext(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWeightOfContext(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static const spacing4 = 4.0;
  static const spacing8 = 8.0;
  static const spacing12 = 12.0;
  static const spacing16 = 16.0;
  static const spacing20 = 20.0;
  static const spacing24 = 24.0;
  static const spacing32 = 32.0;
  static const spacing48 = 48.0;
  static const spacing64 = 64.0;

  // Border radius
  static const radiusSmall = 8.0;
  static const radiusMedium = 12.0;
  static const radiusLarge = 16.0;
  static const radiusXLarge = 24.0;
  static const radiusRound = 999.0;

  /// Value double 0.
  static const double0 = 0.0;

  /// Value double 0,5.
  static const double05 = 0.5;

  /// Value double 1.
  static const double1 = 1.0;

  /// Value double 2.
  static const double2 = 2.0;

  /// Value double 4.
  static const double4 = 4.0;

  /// Value double 6.
  static const double6 = 6.0;

  /// Value double 8.
  static const double8 = 8.0;

  /// Value double 12.
  static const double12 = 12.0;

  /// Value double 14.
  static const double14 = 14.0;

  /// Value double 16.
  static const double16 = 16.0;

  /// Value double 20.
  static const double20 = 20.0;

  /// Value double 20.
  static const double32 = 32.0;

  /// Value double 50.
  static const double50 = 50.0;

  /// Value double 200.
  static const double200 = 200.0;

  /// Value double 400.
  static const double400 = 400.0;

  /// Value double 600.
  static const double600 = 600.0;

  /// Value double 1000.
  static const double1000 = 1000.0;
}
