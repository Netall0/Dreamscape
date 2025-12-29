import 'package:dreamscape/features/alarm/services/alarm_service.dart';
import 'package:dreamscape/features/home/controller/stream/clock_stream.dart';

final class PlatformDependContainer {
  final AlarmService alarmService;
  final StreamClock clockNotifier;


  PlatformDependContainer({
    required this.alarmService,
    required this.clockNotifier,
  });
}
