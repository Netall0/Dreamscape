import 'package:dreamscape/features/home/datasource/home_sleep_datasource.dart';
import 'package:dreamscape/features/home/service/i_home_sleep_service.dart';
import 'package:flutter/material.dart';

final class HomeSleepService implements IHomeSleepService {
  final HomeSleepDatasource _datasource;

  HomeSleepService({required HomeSleepDatasource datasource})
    : _datasource = datasource;

  @override
  Future<void> endSleeping(TimeOfDay timeRise) async {
    await _datasource.saveRiseTime(timeRise);
  }

  @override
  Future<void> startSleeping(TimeOfDay bedTime) async {
    await _datasource.saveBedTime(bedTime);
  }

  @override
  Future<Duration?> calculateSleepTime() async {
    final (bedTime, riseTime) = await _datasource.load();

    if (bedTime == null || riseTime == null) {
      return null;
    }

    return _calculateDuration(bedTime, riseTime);
  }

  Duration _calculateDuration(TimeOfDay bed, TimeOfDay rise) {
    final bedMinutes = bed.hour * 60 + bed.minute;
    final riseMinutes = rise.hour * 60 + rise.minute;

    final totalMinutes = riseMinutes <= bedMinutes
        ? (24 * 60 - bedMinutes) + riseMinutes
        : riseMinutes - bedMinutes;

    return Duration(minutes: totalMinutes);
  }

  @override
  Future<void> clear() async {
    await _datasource.clear();
  }
}
