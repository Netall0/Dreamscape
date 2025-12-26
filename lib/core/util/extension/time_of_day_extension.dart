import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  Duration difference(TimeOfDay other) {
    int thisMinutes = hour * 60 + minute;
    int otherMinutes = other.hour * 60 + other.minute;

    int diffMinutes;

    if (otherMinutes >= thisMinutes) {
      diffMinutes = otherMinutes - thisMinutes;
    } else {
      diffMinutes = (24 * 60) - thisMinutes + otherMinutes;
    }

    return Duration(minutes: diffMinutes);
  }

  int timeOfDayToMinutes() {
    int hourMinutes = hour * 60;

    return hourMinutes + minute;
  }
}

extension TimeOfDayIntExtension on int {
  TimeOfDay toTimeOfDayToMiutes() {
    return TimeOfDay(hour: this ~/ 60, minute: this % 60);
  }
}
