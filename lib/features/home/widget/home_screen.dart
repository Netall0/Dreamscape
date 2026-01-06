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
    final size = MediaQuery.sizeOf(context);
    // final notificationSender = DependScope.of(
    //   context,
    // ).dependModel.notificationsSender;
    final alarmService = DependScope.of(
      context,
    ).platformDependContainer.alarmService;
    final clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final tempRep = DependScope.of(context).dependModel.tempRepository;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * .13),
            Text('hello  friend', style: theme.typography.h1.copyWith()),
            ClockWidget(clockStream: clockStream, theme: theme),
            SizedBox(height: 24),
            AlarmTimePickerWidget(alarmService: alarmService),
            SizedBox(height: 24),
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
                  SleepScreenData().go(context);
                  await tempRep.saveBedTime(
                    TimeOfDay(
                      hour: time.hour, //TODO
                      minute: time.minute,
                    ),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('bedTime: ${time.hour} : ${time.minute}'),
                      ),
                    );
                  }
                },
                child: SizedBox(
                  height: 40,
                  width: 200,
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
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
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
