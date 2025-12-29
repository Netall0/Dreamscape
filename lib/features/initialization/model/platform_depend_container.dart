import 'package:dreamscape/features/alarm/services/alarm_service.dart';
import 'package:dreamscape/features/home/controller/clock_stream_controller.dart';

final class PlatformDependContainer {
  final AlarmService alarmService;
  final StreamClockController clockNotifier;

  PlatformDependContainer({
    required this.alarmService,
    required this.clockNotifier,
  });
}
