import 'package:dreamscape/core/util/extension/time_of_day_extension.dart';
import 'package:dreamscape/features/home/datasource/i_home_sleep_datasource.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class HomeSleepDatasource implements IHomeSleepDatasource {
  final SharedPreferences _sharedPreferences;

  HomeSleepDatasource({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  static const String _bedTimeKey = 'bed_time';
  static const String _timeRiseKey = 'time_rise';

  @override
  Future<void> clear() async {
    _sharedPreferences.remove(_bedTimeKey);
    _sharedPreferences.remove(_timeRiseKey);
  }

  @override
  Future<(TimeOfDay?, TimeOfDay?)> load() async {
    final bedTime = _sharedPreferences.getInt(_bedTimeKey);
    final riseTime = _sharedPreferences.getInt(_timeRiseKey);

    return (bedTime?.toTimeOfDayToMiutes(), riseTime?.toTimeOfDayToMiutes());
  }

  @override
  Future<void> saveBedTime(TimeOfDay bedTime) async {
    await _sharedPreferences.setInt(_bedTimeKey, bedTime.timeOfDayToMinutes());
  }

  @override
  Future<void> saveRiseTime(TimeOfDay timeRise) async {
    await _sharedPreferences.setInt(
      _timeRiseKey,
      timeRise.timeOfDayToMinutes(),
    );
  }
}
