import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/router/router.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/features/home/widget/alarm_time_picker_widget.dart';
import 'package:dreamscape/features/home/widget/clock_widget.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uikit/uikit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _ScreenState();
}

class _ScreenState extends State<HomeScreen> with LoggerMixin {
  //TODO first running application

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    // final notificationSender = DependScope.of(
    //   context,
    // ).dependModel.notificationsSender;
    final alarmService = DependScope.of(context).platformDependContainer.alarmService;
    final clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: AppSizes.screenHeightOfContext(context) * 0.15),
            Text('hello  friend', style: theme.typography.h1.copyWith()),
            ClockWidget(clockStream: clockStream, theme: theme),
            SizedBox(height: 24),
            AlarmTimePickerWidget(alarmService: alarmService),
            SizedBox(height: 24),
            Lottie.asset(Assets.lottie.sleepingPolarBear.path),
            SizedBox(
              width: 200,
              height: 60,
              child: GestureDetector(
                onTap: () => SleepScreenData().go(context),
                child: AdaptiveCard(
                  borderRadius: .all(.circular(24)),
                  backgroundColor: ColorConstants.pastelIndigo,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.play_arrow),
                      Text(
                        ' Начать сон',
                        style: theme.typography.h5.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
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


