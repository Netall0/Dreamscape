import '../../alarm/services/alarm_service.dart';
import '../../home/controller/clock_stream_controller.dart';

final class PlatformDependContainer {

  PlatformDependContainer({
    required this.alarmService,
    required this.clockNotifier,
  });
  final AlarmService alarmService;
  final StreamClockController clockNotifier;
}
