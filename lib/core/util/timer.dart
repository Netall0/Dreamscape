import 'package:dreamscape/core/util/logger.dart';

mixin AppTimerMixin on LoggerMixin {
  late final Stopwatch _stopwatch = Stopwatch()..start();

    int get elapsedMs => _stopwatch.elapsedMilliseconds;


  void logOnProgress(String name) {
    logInfo(
      '$name  прогресс: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }


  void logOnComplete(String message) {
    logInfo(
      '$message,успешная инициализация, прогресс: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }

}
