import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dreamscape/core/config/app_config.dart';
import 'package:dreamscape/features/alarm/datasource/alarm_datasource.dart';
import 'package:dreamscape/features/alarm/services/alarm_service.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/app/widget/app_scope.dart';
import 'package:dreamscape/features/home/controller/notifier/clock_stream.dart';
import 'package:dreamscape/features/initialization/logic/composition_root.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final class AppRunner with LoggerMixin {
  Future<void> run(AppEnv env) async {
    late final PlatformDependContainer platformDeps;
    late final WidgetsBinding bindings;
    late final InheritedResult compositionRoot;
    runZonedGuarded(
      () async {
        bindings = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

        final timer = Stopwatch()..start();

        _initErrorHandler();

        try {
          // logOnProgress('Инициализация платформы');

          platformDeps = await _initPlatformDependencies();

          await _initTimezone();

          await platformDeps.alarmService.initAlarmService();

          logger.debug('Platform dependencies initialized');

          logger.debug('clock started');

          // logOnProgress('Старт приложения');

          logger.debug('show init notifications');

          compositionRoot = await CompositionRoot(
            platformDependContainer: platformDeps,
          ).compose();
          runApp(
            AppScope(
              dependContainer: compositionRoot.dependModel,
              platformDependContainer: platformDeps,
            ),
          );

          timer.stop();

          logger.debug('runner initialized ${timer.elapsedMilliseconds}ms');
        } on Object catch (e, st) {
          logger.error('Ошибка в AppRunner', error: e, stackTrace: st);
        } finally {
          bindings.allowFirstFrame();
        }
      },
      (error, stackTrace) {
        logger.error(
          'Uncaught zone error',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  Future<PlatformDependContainer> _initPlatformDependencies() async {
    late final AlarmService alarmService;

    FlutterLocalNotificationsPlugin notificationsPlugin =
        await _intiLocalNotificaion(
          onAlarmTap: () async => await alarmService.cancelAlarm(1),
        );

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    alarmService = _initAlarmService(notificationsPlugin, sharedPreferences);

    final StreamClock clockNotifier = await _initClockNotifier();
    return PlatformDependContainer(
      alarmService: alarmService,
      clockNotifier: clockNotifier,
    );
  }

  AlarmService _initAlarmService(
    FlutterLocalNotificationsPlugin notificationsPlugin,
    SharedPreferences sharedPreferences,
  ) {
    try {
      final AlarmService alarmService = AlarmService(
        localNotificationsPlugin: notificationsPlugin,
        alarmDatasource: AlarmDatasource(sharedPreferences: sharedPreferences),
        // repeatDaily: false,
      );
      return alarmService;
    } on Object catch (e, stackTrace) {
      logger.error('alarm_service', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<StreamClock> _initClockNotifier() async {
    try {
      final StreamClock clockNotifier = StreamClock();
      return clockNotifier;
    } on Object catch (e, stackTrace) {
      logger.error('clock failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<FlutterLocalNotificationsPlugin> _intiLocalNotificaion({
    required Future<void> Function() onAlarmTap,
  }) async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        try {
          if (response.payload != null && response.id == 1) {
            await onAlarmTap();
          }
          logger.debug(response.toString());
        } on Object catch (e, stackTrace) {
          logger.error(
            'ReceiveNotificationsResponse',
            error: e,
            stackTrace: stackTrace,
          );
        }
      },
    );


    const notificationChannel = AndroidNotificationChannel(
      'Notificaion_channel',
      'Notifications',
      description: 'Default notification channel',
      importance: Importance.high,
      playSound: true,
    );

    const alarmChannel = AndroidNotificationChannel(
      'Alarm_channel',
      'Alarms',
      playSound: true,
      description: 'channel for your alarm',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alarm'),
      enableLights: true,
      enableVibration: true,
    );




    final androidImpl = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.createNotificationChannel(notificationChannel);
    logger.debug('notification channel created');

    await androidImpl?.createNotificationChannel(alarmChannel);
    logger.debug('alarm channel created');

    if (Platform.isAndroid) {
      final androidImpl = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final granted = await androidImpl?.requestNotificationsPermission();
      logger.debug('Android notification permission: $granted');

      final exactAlarmGranted = await androidImpl
          ?.requestExactAlarmsPermission();
      logger.debug('Exact alarm permission: $exactAlarmGranted');
    }
    return notificationsPlugin;
  }

  Future<void> _initTimezone() async {
    try {
      tz.initializeTimeZones();
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      logger.debug('locaton set ($currentTimeZone)');
    } on Object catch (e, st) {
      logger.error('$e', stackTrace: st);
      rethrow;
    }
  }

  void _initErrorHandler() {
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.debug('Platform error', error: error, stackTrace: stack);
      return true;
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      logger.error(
        'Flutter error',
        stackTrace: details.stack,
        error: details.toString(),
      );
      FlutterError.presentError(details);
    };
  }
}
