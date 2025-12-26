import 'package:flutter/material.dart';

abstract interface class IHomeSleepDatasource {
  Future<(TimeOfDay?, TimeOfDay?)> load();
  Future<void> saveBedTime(TimeOfDay bedTime);
  Future<void> saveRiseTime(TimeOfDay timeRise);
  Future<void> clear();
}
