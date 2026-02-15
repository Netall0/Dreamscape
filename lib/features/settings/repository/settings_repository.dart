import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

abstract interface class SettingsRepository {
  Future<void> setThemeMode(String themeMode);
  String getThemeMode();
}

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _themeModeKey = 'theme_mode';

  @override
  Future<void> setThemeMode(String themeMode) async {
    await sharedPreferences.setString(_themeModeKey, themeMode);
  }

  @override
  String getThemeMode() => sharedPreferences.getString(_themeModeKey) ?? 'light';
}
