import 'package:dreamscape/features/home/controller/clock_stream_controller.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_theme.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({
    super.key,
    required this.clockStream,
    required this.theme,
  });

  final StreamClockController clockStream;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: clockStream.stream,
      builder: (context, snapshot) {
        return switch (snapshot) {
          AsyncSnapshot(:final data?) => Text(
            '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}',
            style: theme.typography.h1,
          ),
          AsyncSnapshot(hasError: true) => Text('Error: ${snapshot.error}'),
          _ => const CircularProgressIndicator(),
        };
      },
    );
  }
}
