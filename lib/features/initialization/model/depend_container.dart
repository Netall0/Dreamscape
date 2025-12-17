import 'package:dreamscape/core/services/alarm/alarm_service.dart';
import 'package:dreamscape/core/services/notifications/notifications_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependContainer {
  DependContainer({
    required this.sharedPreferences,
    required this.notificationsSender,
    required this.alarmService,
  });

  final SharedPreferences sharedPreferences;
  final NotificationsSender notificationsSender;
  final AlarmService alarmService;
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
