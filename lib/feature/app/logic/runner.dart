import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:dreamscape/core/config/app_config.dart';
import 'package:dreamscape/core/util/logger.dart';
import 'package:dreamscape/core/util/timer.dart';
import 'package:dreamscape/feature/app/widget/app_widget.dart';

final class AppRunner with LoggerMixin, AppTimerMixin {
  Future<void> run(AppEnv env) async {
    runZonedGuarded(
      () async {
        final bindings = WidgetsFlutterBinding.ensureInitialized()
          ..deferFirstFrame();


        
        _initErrorHandler();


        try {
          logOnProgress('Старт приложения');

        
          runApp(App());

          logOnComplete('AppWidget');
        } on Object catch (e, st) {
          logError('Ошибка в AppRunner', e, st);
        } finally {
          bindings.addPostFrameCallback((_) {
            bindings.allowFirstFrame();
          });
        }
      },
      (error, stackTrace) {
        logError('Uncaught zone error', error, stackTrace);
      },
    );
  }
}


void _initErrorHandler() {
  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
}
