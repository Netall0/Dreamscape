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

  String get themeMode => _settingsRepository.getThemeMode();

  String get localizationMode => _settingsRepository.getLocalization();

  Future<void> setLocalization(String l10n) async {
    if (localizationMode == l10n) {
      return;
    }

    await _settingsRepository.setLocalization(l10n);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    if (themeMode == mode) {
      return;
    }

    await _settingsRepository.setThemeMode(mode);
    notifyListeners();
  }

  void _validate() {
    final String currentMode = _settingsRepository.getThemeMode();
    final String currentLocalization = _settingsRepository.getLocalization();

    if (!['ru', 'en'].contains(currentLocalization)) {
      setLocalization('ru');
    }

    if (!['light', 'dark'].contains(currentMode)) {
      setThemeMode('light');
    }
  }
}
