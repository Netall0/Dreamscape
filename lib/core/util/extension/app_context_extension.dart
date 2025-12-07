import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

extension on BuildContext {
  LayoutInherited get layoutInherited => LayoutInherited.of(this);

  AppTheme get appTheme => Theme.of(this).extension<AppTheme>()!;
}
