import 'dart:io';

import 'package:dreamscape/core/services/notifications_sender.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/timer_mixin.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// typedef OnError =
//     void Function(String message, Object error, [StackTrace? stackTrace]);
// typedef OnProgress = void Function(String name);
// typedef OnComplete = void Function(String message);

final class InheritedResult {
  final int ms;
  final DependContainer dependModel;

  const InheritedResult({required this.ms, required this.dependModel});
}

class CompositionRoot with LoggerMixin, AppTimerMixin {
  final PlatformDependContainer platformDependContainer;

  CompositionRoot({required this.platformDependContainer});

  Future<InheritedResult> compose() async {
    logOnProgress('Старт инициализации');

    final stopwatch = Stopwatch()..start();

    final depend = await _initDepend();

    stopwatch.stop();

    logOnComplete('Dependencies');

    return InheritedResult(
      ms: stopwatch.elapsedMilliseconds,
      dependModel: depend,
    );
  }

  Future<DependContainer> _initDepend() async {
    try {
      final sharedPreferences = await _initSharedPreference();
      logOnComplete('sharedPreference init');
      final notificationsSender = await _initNotificationsSender();
      logOnComplete('notSender init');
      return DependContainer(
        sharedPreferences: sharedPreferences,
        notificationsSender: notificationsSender,
      );
    } catch (e, stackTrace) {
      logger.error('Ошибка в _initDepend', error: e,stackTrace:  stackTrace);
      rethrow;
    }
  }

  Future<NotificationsSender> _initNotificationsSender() async {
    try {
      logOnProgress('SharedPreferences');
      return NotificationsSender(
        flutterLocalNotificationsPlugin:
            platformDependContainer.flutterLocalNotificationsPlugin,
      );
    } on Object catch (e, stackTrace) {
      logger.error('notif failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<SharedPreferences> _initSharedPreference() async {
    try {
      logOnProgress('SharedPreferences');
      return await SharedPreferences.getInstance();
    } on Object catch (e, stackTrace) {
      logger.error('shared preference init error', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}


//_________________________________________________________________________________________________________
//____________________________________________________________________________________________________________
// ____________________________________________________________________________________________________________

// abstract class AsyncFactory<T> {
//   const AsyncFactory();

//   Future<T> create({
//     OnError? onError,
//     OnComplete? onComplete,
//     OnProgress? onProgress,
//   });
// }

// abstract class Factory<T> {
//   const Factory();

//   T create({OnError? onError, OnComplete? onComplete, OnProgress? onProgress});
// }


/// void main() async {
///   final root = CompositionRoot();
///   
///   final result = await root.compose(
///     onError: (msg, error, [stackTrace]) => print('Error: $msg'),
///     onProgress: (name) => print('Progress: $name'),
///     onComplete: (msg) => print('Complete: $msg'),
///   );
///   
///   print('Initialized in ${result.ms}ms');
/// }