import 'package:flutter/material.dart';

abstract interface class IHomeSleepService {
  Future<void> startSleeping(TimeOfDay bedTime);
  Future<void> endSleeping(TimeOfDay timeRise);
  Future<Duration?> calculateSleepTime();
  Future<void> clear();
}
