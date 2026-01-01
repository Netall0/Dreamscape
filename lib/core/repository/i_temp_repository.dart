import 'package:flutter/material.dart';

abstract interface class ITempRepository {
  Future<void> saveBedTime(TimeOfDay bedTime);
  Future<TimeOfDay?> getBedTime();
  Future<void> saveRiseTime(TimeOfDay riseTime);
  Future<TimeOfDay?> getRiseTime();
  Future<void> clearTempData();

}
