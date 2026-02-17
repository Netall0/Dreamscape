import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

abstract interface class SettingsRepository {
  Future<void> setThemeMode(String themeMode);
  String getThemeMode();
  Future<void> setAnimationEnabled(bool value);
  bool getAnimationEnabled();
  Future<void> setLocaleCode(String value);
  String getLocaleCode();
}

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _themeModeKey = 'theme_mode';
  static const String _animationEnabledKey = 'animation_enabled';
  static const String _localeCodeKey = 'locale_code';

  @override
  Future<void> setThemeMode(String themeMode) async {
    await sharedPreferences.setString(_themeModeKey, themeMode);
  }

  @override
  String getThemeMode() => sharedPreferences.getString(_themeModeKey) ?? 'light';

  @override
  Future<void> setAnimationEnabled(bool value) async {
    await sharedPreferences.setBool(_animationEnabledKey, value);
  }

  @override
  bool getAnimationEnabled() => sharedPreferences.getBool(_animationEnabledKey) ?? true;

  @override
  Future<void> setLocaleCode(String value) async {
    await sharedPreferences.setString(_localeCodeKey, value);
  }

  @override
  String getLocaleCode() => sharedPreferences.getString(_localeCodeKey) ?? 'ru';
}
