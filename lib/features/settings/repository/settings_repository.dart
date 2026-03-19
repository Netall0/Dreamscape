import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

abstract interface class SettingsRepository {
  Future<void> setThemeMode(String themeMode);
  String getThemeMode();

  Future<void> setLocalization(String l10n);
  String getLocalization();
}

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _themeModeKey = 'theme_mode';

  static const String _l10nKey = 'l10n';

  @override
  Future<void> setThemeMode(String themeMode) async {
    await sharedPreferences.setString(_themeModeKey, themeMode);
  }

  @override
  String getThemeMode() => sharedPreferences.getString(_themeModeKey) ?? 'light';

  @override
  String getLocalization() => sharedPreferences.getString(_l10nKey) ?? 'ru';

  @override
  Future<void> setLocalization(String l10n) async {
    await sharedPreferences.setString(_l10nKey, l10n);
  }
}
