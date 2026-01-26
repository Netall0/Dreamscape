import 'package:flutter/material.dart';
import 'package:uikit/theme/app_theme.dart';

import '../controller/clock_stream_controller.dart';

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
