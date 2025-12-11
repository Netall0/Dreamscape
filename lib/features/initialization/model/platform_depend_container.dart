import 'package:dreamscape/core/services/alarm/alarm_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/tzdata.dart';

typedef TimeZoneString = String;

final class PlatformDependContainer {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final AlarmService alarmService;
  final TimeZoneString? timeZone;

  PlatformDependContainer({
    required this.flutterLocalNotificationsPlugin,
    this.timeZone, required this.alarmService,
  });
}
