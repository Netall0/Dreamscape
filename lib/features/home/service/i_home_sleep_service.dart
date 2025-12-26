import 'package:flutter/material.dart';

abstract interface class IHomeSleepService {
  Future<void> startSleeping(TimeOfDay bedTime);
  Future<void> endSleeping(TimeOfDay timeRise);
  Future<TimeOfDay?> calculateSleepTime();
  Future<void> clear();
}
