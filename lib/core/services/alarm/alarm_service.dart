// import 'package:just_audio/just_audio.dart';
// import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/services/alarm/i_alarm_service.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'dart:developer';

final class AlarmService with LoggerMixin implements IAlarmService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  AlarmService({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
  }) : _localNotificationsPlugin = localNotificationsPlugin;

  // @pragma('vm:entry-point')
  // static Future<void> alarmCallback(int id, Map<String, dynamic> params) async {
  //   log('triggered alarm callback $id');

  //   try {
  //     final localNotificaions = FlutterLocalNotificationsPlugin();

  //     const androidDetails = AndroidNotificationDetails(
  //       'alarm_channel',
  //       'alarms',
  //       importance: Importance.max,
  //       priority: Priority.max,
  //       fullScreenIntent: true,
  //       category: AndroidNotificationCategory.alarm,
  //       playSound: false,
  //       enableVibration: true,
  //       enableLights: true,
  //       autoCancel: false,
  //     );

  //     await localNotificaions.show(
  //       id,
  //       'Будильник ⏰',
  //       params['label'] ?? 'время вставать!!!',
  //       NotificationDetails(android: androidDetails),
  //       payload: id.toString(),
  //     );

  //     log('notification show');

  //     //aufio
  //     final audioPlayer = AudioPlayer()
  //       ..setLoopMode(LoopMode.one)
  //       ..setVolume(1.0);

  //     await audioPlayer.setAsset(Assets.sound.alarm);
  //     await audioPlayer.play();

  //     log('started audio player');
  //   } on Object catch (e, st) {
  //     log('$e $st');
  //   }
  // }

  @override
  Future<void> cancelAlarm(int id) async {
    await _localNotificationsPlugin.cancel(id);
    logger.debug('$id alarm canceled');
  }

  @override
  Future<void> setAlarm({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);

      var alarmTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (!alarmTime.isAfter(DateTime.now())) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }

      logger.debug('NOW        : $now');
      logger.debug('ALARM FINAL: $alarmTime');

      await _localNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        alarmTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'Alarm_channel',
            'Alarms',
            channelDescription: 'channel for your alarm',
            importance: Importance.max,
            priority: Priority.max,
            fullScreenIntent: true, //fullscreen alarm
            autoCancel: false,
            sound: RawResourceAndroidNotificationSound('alarm'),
            enableLights: true,
            enableVibration: true,
            category: AndroidNotificationCategory.alarm,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            sound: 'alarm.aiff',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

        final before = await _localNotificationsPlugin
          .pendingNotificationRequests();
      logger.debug('🔔 Pending before: ${before.length}');

      // final timeString = model.formattedTime;

      // return AndroidAlarmManager.oneShotAt(
      //   alarmTime,
      //   model.id,
      //   alarmCallback,
      //   alarmClock: true,
      //   exact: true,
      //   rescheduleOnReboot: true,
      //   allowWhileIdle: true,
      //   params: {
      //     'id': model.id,
      //     'label': model.label,
      //     'hour': model.hour,
      //     'minute': model.minute,
      //   },
      // );

      final after = await _localNotificationsPlugin
          .pendingNotificationRequests();
      logger.debug('Pending after: ${after.length}');
      for (var pending in after) {
        logger.debug(' - ID: ${pending.id}, Title: ${pending.title}');
      }

      final diff = alarmTime.difference(now);
      logger.debug(
        ' Alarm set for: (${diff.inHours}h ${diff.inMinutes.remainder(60)}m)',
      );
      logger.debug(
        'Alarm set for:  ( ${diff.inHours}h ${diff.inMinutes.remainder(60)}m)',
      );
    } on Object catch (e, st) {
      logger.error('error in setAlarm method', error: e, stackTrace: st);
      rethrow;
    }
  }
}
