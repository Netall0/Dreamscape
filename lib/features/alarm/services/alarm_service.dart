import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/util/logger/logger.dart';
import '../datasource/alarm_datasource.dart';
import '../datasource/datasource_model.dart';
import 'i_alarm_service.dart';
// import 'dart:developer';

final class AlarmService with LoggerMixin implements IAlarmService {
  AlarmService({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required AlarmDatasource alarmDatasource,
  }) : _localNotificationsPlugin = localNotificationsPlugin,
       _alarmDatasource = alarmDatasource;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final AlarmDatasource _alarmDatasource;

  TZDateTime? _alarmTime;

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

  final StreamController<TZDateTime?> _streamController =
      StreamController<TZDateTime?>.broadcast();

  Stream<TZDateTime?> get alarmStreamController => _streamController.stream;

  Future<void> initAlarmService() async {
    final DatasourceModel? dataAlarm = await _alarmDatasource.load();
    dataAlarm != null
        ? _alarmTime = TZDateTime(
            tz.local,
            dataAlarm.year,
            dataAlarm.month,
            dataAlarm.day,
            dataAlarm.hour,
            dataAlarm.minute,
          )
        : logger.debug('no saved alarm');

    _streamController.add(_alarmTime);
  }

  @override
  Future<void> cancelAlarm(int id) async {
    await _localNotificationsPlugin.cancel(id);
    _alarmDatasource.clear();
    _alarmTime = null;
    _streamController.add(null);
    logger.debug('$id alarm canceled');
  }

  @override
  Future<void> setAlarm({
    int id = 1, //TODO id
    required String title,
    required String body,
    required int hour,
    required int minute,
    bool repeatDaily = false,
  }) async {
    try {
      final now = DateTime.now();
      _alarmTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (!_alarmTime!.isAfter(DateTime.now())) {
        _alarmTime = _alarmTime!.add(const Duration(days: 1));
      }

      logger.debug('NOW        : $now');
      logger.debug('ALARM FINAL: $_alarmTime');

      await _localNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _alarmTime!,
        const NotificationDetails(
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
            category: AndroidNotificationCategory.alarm,
            actions: [
              AndroidNotificationAction(
                'dismiss_alarm',
                'отключить',
                showsUserInterface: true,
              ),
            ],
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

        matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
      );

      final List<PendingNotificationRequest> before = await _localNotificationsPlugin
          .pendingNotificationRequests();
      logger.debug('🔔 Pending before: ${before.length}');

      //datasource

      _alarmDatasource.save(
        DatasourceModel(
          year: now.year,
          month: now.month,
          day: now.day,
          hour: hour,
          minute: minute,
          id: id,
        ),
      );

      _streamController.add(_alarmTime);
      logger.debug('datasource saved alarmtime');

      final List<PendingNotificationRequest> after = await _localNotificationsPlugin
          .pendingNotificationRequests();
      logger.debug('Pending after: ${after.length}');
      for (final pending in after) {
        logger.debug(' -  : ${pending.id}, Title: ${pending.title}');
      }

      final Duration diff = _alarmTime!.difference(now);
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

  @override
  TZDateTime? getAlarmTime() {
    return _alarmTime;
  }

  void dispose() {
    _streamController.close();
  }
}
