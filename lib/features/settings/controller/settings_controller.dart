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
  static const String _animationEnabledKey = 'animation_enabled';
  static const String _localeCodeKey = 'locale_code';

  String get themeMode => _settingsRepository.getThemeMode();
  bool get animationEnabled => _settingsRepository.getAnimationEnabled();
  String get localeCode => _settingsRepository.getLocaleCode();

  Future<void> setThemeMode(String mode) async {
    if (themeMode == mode) {
      return;
    }

    await _settingsRepository.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setAnimationEnabled(bool value) async {
    if (animationEnabled == value) {
      return;
    }

    await _settingsRepository.setAnimationEnabled(value);
    notifyListeners();
  }

  Future<void> setLocaleCode(String value) async {
    if (localeCode == value) {
      return;
    }
    await _settingsRepository.setLocaleCode(value);
    notifyListeners();
  }

  void _validate() {
    final String currentMode = _settingsRepository.getThemeMode();
    final bool _ = _settingsRepository.getAnimationEnabled();
    final String __ = _settingsRepository.getLocaleCode();

    if (!ThemeModes.values.any((e) => e.name == currentMode)) {
      setThemeMode('light');
    }
  }
}
