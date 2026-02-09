import 'package:flutter/material.dart';
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
  //TODO first running application

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final Size size = MediaQuery.sizeOf(context);
    // final notificationSender = DependScope.of(
    //   context,
    // ).dependModel.notificationsSender;
    final AlarmService alarmService = DependScope.of(context).platformDependContainer.alarmService;
    final StreamClockController clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final TempRepository tempRep = DependScope.of(context).dependModel.tempRepository;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * .13),
            Text('hello  friend', style: theme.typography.h1),
            ClockWidget(clockStream: clockStream, theme: theme),
            const SizedBox(height: 24),
            AlarmTimePickerWidget(alarmService: alarmService),
            const SizedBox(height: 24),
            Lottie.asset(
              Assets.lottie.sleepingPolarBear.path,
              height: (size.width < 500) ? size.height * .4 : size.height * .3,
            ),
            SizedBox(
              width: 200,
              height: size.height * .1,
              child: GestureDetector(
                onTap: () async {
                  final time = TimeOfDay.now();
                  const SleepScreenData().go(context);
                  await tempRep.saveBedTime(
                    TimeOfDay(
                      hour: time.hour, //TODO
                      minute: time.minute,
                    ),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('bedTime: ${time.hour} : ${time.minute}')),
                    );
                  }
                },
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: AdaptiveCard(
                    borderRadius: const .all(.circular(24)),
                    backgroundColor: ColorConstants.pastelIndigo,
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        const Icon(Icons.play_arrow),
                        Text(' Начать сон', style: theme.typography.h5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
