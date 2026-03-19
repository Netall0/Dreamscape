import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:uikit/uikit.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../core/repository/temp_repository.dart';
import '../../../core/router/router.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../../../core/util/logger/logger.dart';
import '../../alarm/services/alarm_service.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/clock_stream_controller.dart';
import 'alarm_time_picker_widget.dart';
import 'clock_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _ScreenState();
}

class _ScreenState extends State<HomeScreen> with LoggerMixin {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final Size size = MediaQuery.sizeOf(context);
    final AlarmService alarmService = DependScope.of(context).platformDependContainer.alarmService;
    final StreamClockController clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final TempRepository tempRep = DependScope.of(context).dependModel.tempRepository;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: size.height * .02),
                Text(context.l10n.homeGreeting, style: theme.typography.h1),
                const SizedBox(height: 8),
                Text(context.l10n.homeSubtitle, style: theme.typography.bodyMedium),
                const SizedBox(height: 20),
                ClockWidget(clockStream: clockStream, theme: theme),
                const SizedBox(height: 20),
                AlarmTimePickerWidget(alarmService: alarmService),
                const SizedBox(height: 20),
                Lottie.asset(
                  Assets.lottie.sleepingPolarBear.path,
                  height: (size.width < 500) ? size.height * .32 : size.height * .24,
                ),
                SizedBox(
                  width: 220,
                  height: 62,
                  child: GestureDetector(
                    onTap: () async {
                      final time = TimeOfDay.now();
                      context.push('/home/sleep');
                      await tempRep.saveBedTime(TimeOfDay(hour: time.hour, minute: time.minute));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${context.l10n.startSleeping}: ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        );
                      }
                    },
                    child: AdaptiveCard(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      backgroundColor: theme.colors.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: theme.colors.onPrimary),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.startSleeping,
                            style: theme.typography.h5.copyWith(color: theme.colors.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
