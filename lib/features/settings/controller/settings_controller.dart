import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/settings_repository.dart';

enum ThemeModes { light, dark }

final class SettingsController extends ChangeNotifier {
  SettingsController({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository {
    _validate();
  }

  final SettingsRepository _settingsRepository;

  static const String _themeModeKey = 'theme_mode';

  String get themeMode => _settingsRepository.getThemeMode();

  Future<void> setThemeMode(String mode) async {
    if (themeMode == mode) {
      return;
    }

    await _settingsRepository.setThemeMode(mode);
    notifyListeners();
  }

  void _validate() {
    final String currentMode = _settingsRepository.getThemeMode();

    if (!ThemeModes.values.any((e) => e.name == currentMode)) {
      setThemeMode('light');
    }
  }
}
