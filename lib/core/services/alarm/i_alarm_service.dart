import 'package:timezone/timezone.dart';

abstract interface class IAlarmService {
  // Future<void> setAlarm(AlarmModel model);

  TZDateTime? getAlarmTime();
  Future<void> setAlarm({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  });
  Future<void> cancelAlarm(int id);
}
