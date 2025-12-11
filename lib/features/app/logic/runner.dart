import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dreamscape/core/config/app_config.dart';
import 'package:dreamscape/core/services/alarm/alarm_service.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/timer_mixin.dart';
import 'package:dreamscape/features/app/widget/app_scope.dart';
import 'package:dreamscape/features/initialization/logic/composition_root.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final class AppRunner with LoggerMixin, AppTimerMixin {
  Future<void> run(AppEnv env) async {
    late final PlatformDependContainer platformDeps;
    late final WidgetsBinding bindings;
    late final InheritedResult compositionRoot;
    runZonedGuarded(
      () async {
        bindings = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

        _initErrorHandler();

        try {
          logOnProgress('Инициализация платформы');

          platformDeps = await _initPlatformDependencies();

          logger.debug('Platform dependencies initialized');

          logOnProgress('Старт приложения');

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

          logOnComplete('runner');
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
    final timeZone = await _initTimezone();



    //TODO rotate logging here

    FlutterLocalNotificationsPlugin notificationsPlugin =
        await _intiLocalNotificaion();


        
    final AlarmService alarmService = AlarmService(localNotificationsPlugin: notificationsPlugin);

    return PlatformDependContainer(
      alarmService: alarmService,
      timeZone: timeZone,
      flutterLocalNotificationsPlugin: notificationsPlugin,
    );
  }

  Future<FlutterLocalNotificationsPlugin> _intiLocalNotificaion() async {
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
      onDidReceiveNotificationResponse: (details) {
        logger.error(details.toString());
      },
    );


    const alarmChannel = AndroidNotificationChannel(
      'alarm_channel',
      'Alarms',
      description: 'Alarm notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(alarmChannel);

    if (Platform.isAndroid) {
      final androidImpl = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final granted = await androidImpl?.requestNotificationsPermission();
      logger.debug('Android notification permission: $granted');
    }
    return notificationsPlugin;
  }

  Future<TimeZoneString> _initTimezone() async {
    try {
      tz.initializeTimeZones();
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      final parsedTimeZone = parseWeirdTimezone(timezoneName.toString());

      tz.setLocalLocation(tz.getLocation(parsedTimeZone));
      logger.debug('locaton set ($parsedTimeZone)');
      return parsedTimeZone;
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

//TODO update to switch case
String parseWeirdTimezone(String input) {
  final s = input.toLowerCase();

  if (s.contains("greenwich")) return "UTC";
  if (s.contains("gmt")) return "UTC";

  if (s.contains("utc")) return "UTC";
  final RegExp tzRegex = RegExp(r'[A-Za-z]+\/[A-Za-z_]+');
  final match = tzRegex.firstMatch(input);
  if (match != null) return match.group(0)!;

  return "UTC";
}
