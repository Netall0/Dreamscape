import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dreamscape/core/config/app_config.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/timer_mixin.dart';
import 'package:dreamscape/features/app/widget/app_scope.dart';
import 'package:dreamscape/features/initialization/logic/composition_root.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

    const androidChannel = AndroidNotificationChannel(
      'main_id',
      'main',
      description: 'Default notification channel',
      importance: Importance.high,
      playSound: true,
    );
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    if (Platform.isAndroid) {
      final androidImpl = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final granted = await androidImpl?.requestNotificationsPermission();
      logger.debug('Android notification permission: $granted');
    }

    return PlatformDependContainer(
      flutterLocalNotificationsPlugin: notificationsPlugin,
    );
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
