import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/uikit.dart';

enum AppThemeKind { dark, light }

enum AppLocaleKind {
  en('en'),
  ru('ru');

  const AppLocaleKind(this.code);
  final String code;

  Locale get locale => Locale(code);
}

final class AppSettingsNotifier extends ChangeNotifier {
  AppSettingsNotifier({required SharedPreferences sharedPreferences}) : _prefs = sharedPreferences {
    _load();
  }

  static const String _themeKey = 'app_theme_kind';
  static const String _onboardingKey = 'app_onboarding_done';
  static const String _localeKey = 'app_locale';

  final SharedPreferences _prefs;

  AppThemeKind _currentTheme = AppThemeKind.dark;
  AppLocaleKind _currentLocale = AppLocaleKind.ru;
  bool _isOnboardingCompleted = false;

  AppThemeKind get currentTheme => _currentTheme;
  AppLocaleKind get currentLocale => _currentLocale;
  Locale get locale => _currentLocale.locale;
  bool get isOnboardingCompleted => _isOnboardingCompleted;

  AppTheme get currentAppTheme => switch (_currentTheme) {
    AppThemeKind.dark => AppTheme.dark,
    AppThemeKind.light => AppTheme.light,
  };

  Future<void> setTheme(AppThemeKind kind) async {
    if (_currentTheme == kind) return;
    _currentTheme = kind;
    await _prefs.setInt(_themeKey, kind.index);
    notifyListeners();
  }

  Future<void> setLocale(AppLocaleKind locale) async {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    await _prefs.setString(_localeKey, locale.code);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    if (_isOnboardingCompleted) return;
    _isOnboardingCompleted = true;
    await _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  void _load() {
    final themeIndex = _prefs.getInt(_themeKey);
    _currentTheme = switch (themeIndex) {
      2 => AppThemeKind.light,
      1 => AppThemeKind.dark,
      0 => AppThemeKind.dark,
      _ => AppThemeKind.dark,
    };

    final localeCode = _prefs.getString(_localeKey);
    _currentLocale = switch (localeCode) {
      'en' => AppLocaleKind.en,
      'ru' => AppLocaleKind.ru,
      _ => AppLocaleKind.ru,
    };

    _isOnboardingCompleted = _prefs.getBool(_onboardingKey) ?? false;
  }
}
