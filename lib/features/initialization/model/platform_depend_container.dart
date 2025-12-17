import 'package:dreamscape/core/services/alarm/alarm_service.dart';
import 'package:dreamscape/features/home/controller/notifier/clock_stream.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// typedef TimeZoneString = String;

final class PlatformDependContainer {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final AlarmService alarmService;
  final StreamClock clockNoitifier;

  PlatformDependContainer({
    required this.flutterLocalNotificationsPlugin,
    required this.alarmService, required this.clockNoitifier,
  });
}
