import 'package:dreamscape/core/util/extension/time_of_day_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/home/datasource/home_sleep_datasource.dart';
import 'package:dreamscape/features/home/service/i_home_sleep_service.dart';
import 'package:flutter/material.dart';

final class HomeSleepService with LoggerMixin implements IHomeSleepService {
  final HomeSleepDatasource _datasource;

  HomeSleepService({required HomeSleepDatasource datasource})
    : _datasource = datasource;

  @override
  Future<void> startSleeping(TimeOfDay bedTime) async {
    try {
      await _datasource.saveBedTime(bedTime);
    } on Object catch (e, st) {
      logger.error(
        'HomeSleepService.startSleeping error',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> endSleeping(TimeOfDay timeRise) async {
    try {
      await _datasource.saveRiseTime(timeRise);
    } on Object catch (e, st) {
      logger.error(
        'HomeSleepService.endSleeping error',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<TimeOfDay?> calculateSleepTime() async {
    try {
      final (bedTime, riseTime) = await _datasource.load();

      if (bedTime == null || riseTime == null) return null;

      return _calculateDuration(
        bedTime,
        riseTime,
      ).inMinutes.toTimeOfDayToMiutes();
    } on Object catch (e, st) {
      logger.error(
        'HomeSleepService.calculateSleepTime error',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Duration _calculateDuration(TimeOfDay bed, TimeOfDay rise) {
    final bedMinutes = bed.hour * 60 + bed.minute;
    final riseMinutes = rise.hour * 60 + rise.minute;

    final totalMinutes = riseMinutes <= bedMinutes
        ? (24 * 60 - bedMinutes) + riseMinutes
        : riseMinutes - bedMinutes;

    logger.debug(totalMinutes.toString());

    return Duration(minutes: totalMinutes);
  }

  @override
  Future<void> clear() async {
    try {
      await _datasource.clear();
    } on Object catch (e, st) {
      logger.error('HomeSleepService.clear error', error: e, stackTrace: st);
    }
  }
}
