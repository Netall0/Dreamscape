import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamscape/core/services/alarm/i_alarm_service.dart';
import 'package:dreamscape/core/services/alarm/model/alarm_model.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/browser.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer';

final class AlarmService with LoggerMixin implements IAlarmService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  AlarmService({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
  }) : _localNotificationsPlugin = localNotificationsPlugin;

  @pragma('vm:entry-point')
  static Future<void> alarmCallback(int id, Map<String, dynamic> params) async {
    log('triggered alarm callback $id');

    try {
      final localNotificaions = FlutterLocalNotificationsPlugin();

      const androidDetails = AndroidNotificationDetails(
        'alarm_channel',
        'alarmsl',
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        playSound: false,
        enableVibration: true,
        enableLights: true,
        autoCancel: false,
      );

      await localNotificaions.show(
        id,
        'Будильник ⏰',
        params['label'] ?? 'время вставать!!!',
        NotificationDetails(android: androidDetails),
        payload: id.toString(),
      );

      log('notification show');

      //aufio
      final audioPlayer = AudioPlayer()
        ..setReleaseMode(ReleaseMode.loop)
        ..setVolume(1.0);

      await audioPlayer.play(AssetSource('assets/sound/alarm.mp3'));

      log('started audio player');
    } on Object catch (e, st) {
      log('$e $st');
    }
  }

  @override
  Future<void> cancelAlarm(int id) async {
    await AndroidAlarmManager.cancel(id);
    logger.debug('$id alarm canceled');
  }

  @override
  Future<void> setAlarm(AlarmModel model) {
    try {
      final now = tz.TZDateTime.now(tz.local);

      TZDateTime alarmTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );

      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(Duration(days: 1));
        logger.debug('been rescheduled for tomorrow');
      }

      logger.debug('alarm time ${model.id}, setting: $alarmTime');

      return AndroidAlarmManager.oneShotAt(
        alarmTime,
        model.id,
        alarmCallback,
        alarmClock: true,
        exact: true,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
        params: {},
      );
    } on Object catch (e, st) {
      logger.error('error in setAlarm method', error: e, stackTrace: st);
      rethrow;
    }
  }
}
