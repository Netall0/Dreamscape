import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/logger/logger.dart';
import 'i_temp_repository.dart';

final class TempRepository with LoggerMixin implements ITempRepository {
  TempRepository({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;
  final SharedPreferences _sharedPreferences;

  static const String _bedTimeKey = 'bed_time';
  static const String _riseTimeKey = 'rise_time';

  @override
  Future<void> clearTempData() async {
    try {
      await _sharedPreferences.remove(_bedTimeKey);
      await _sharedPreferences.remove(_riseTimeKey);
      logger.info('Temporary sleep data cleared successfully');
    } on Object catch (e, st) {
      logger.error('Error clearing temp data: $e', stackTrace: st);
    }
  }

  @override
  Future<TimeOfDay?> getBedTime() async {
    try {
      final int? minutes = _sharedPreferences.getInt(_bedTimeKey);
      if (minutes == null) return null;
      return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    } on Object catch (e, st) {
      logger.error('Error getting bed time: $e', stackTrace: st);
      return null;
    }
  }

  // @override
  // Future<TimeOfDay?> getRiseTime() async {
  //   try {
  //     final minutes = _sharedPreferences.getInt(_riseTimeKey);
  //     if (minutes == null) return null;
  //     return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  //   } on Object catch (e, st) {
  //     logger.error('Error getting rise time: $e', stackTrace: st);
  //     return null;
  //   }
  // }

  @override
  Future<void> saveBedTime(TimeOfDay bedTime) async {
    try {
      final int minutes = bedTime.hour * 60 + bedTime.minute;
      _sharedPreferences.setInt(_bedTimeKey, minutes);
      logger.info('Bed time saved successfully');
    } on Object catch (e, st) {
      logger.error('Error saving bed time: $e', stackTrace: st);
    }
  }

  // @override
  // Future<void> saveRiseTime(TimeOfDay riseTime) async {
  //   try {
  //     final minutes = riseTime.hour * 60 + riseTime.minute;
  //     _sharedPreferences.setInt(_riseTimeKey, minutes);
  //     logger.info('Rise time saved successfully');
  //   } on Object catch (e, st) {
  //     logger.error('Error saving rise time: $e', stackTrace: st);
  //   }
  // }
}
