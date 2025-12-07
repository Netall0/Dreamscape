import 'package:dreamscape/core/util/logger/logger.dart';

mixin AppTimerMixin on LoggerMixin {
  late final Stopwatch _stopwatch = Stopwatch()..start();

    int get elapsedMs => _stopwatch.elapsedMilliseconds;


  void logOnProgress(String name) {
    logger.info(
      '$name  прогресс: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }


  void logOnComplete(String message) {
    logger.info(
      '$message,успешная инициализация, прогресс: ${_stopwatch.elapsedMilliseconds} мс',
    );
  }

}
