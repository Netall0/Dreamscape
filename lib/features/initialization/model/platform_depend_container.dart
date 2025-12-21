import 'package:dreamscape/core/services/alarm/alarm_service.dart';
import 'package:dreamscape/features/home/controller/notifier/clock_stream.dart';

final class PlatformDependContainer {
  final AlarmService alarmService;
  final StreamClock clockNotifier;

  PlatformDependContainer({
    required this.alarmService,
    required this.clockNotifier,
  });
}
