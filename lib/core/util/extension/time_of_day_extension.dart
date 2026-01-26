import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  int timeOfDayToMinutes() {
    final int hourMinutes = hour * 60;

    return hourMinutes + minute;
  }

  TimeOfDay calculationSleepTime(TimeOfDay sleepTime) {
    final int bedMiutes = hour * 60 + minute;
    int riseMinutes = sleepTime.hour * 60 + sleepTime.minute;

    if (riseMinutes <= bedMiutes) {
      riseMinutes += 24 * 60;
    }
    final int duration = riseMinutes - bedMiutes;
    return TimeOfDay(hour: duration ~/ 60, minute: duration % 60);
  }
}




extension TimeOfDayIntExtension on int {
  TimeOfDay toTimeOfDayToMiutes() {
    final int hours = (this ~/ 60) % 24;
    final int minutes = this % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
