import 'package:flutter/foundation.dart';
import 'package:uikit/overlay/utils/dimmed_overlay_level.dart';

final class DimmerOverlayNotifier extends ChangeNotifier {
  DimLevel _dimLevel = DimLevel.none;
  DimLevel get dimLevel => _dimLevel;

  void setLevel(DimLevel newLevel) {
    if (_dimLevel != newLevel) {
      _dimLevel = newLevel;
      notifyListeners();
    }
  }
}
