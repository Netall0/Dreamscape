import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/extension/app_context_extension.dart';

import 'package:dreamscape/features/home/widget/clock_widget.dart';
import 'package:dreamscape/features/home/widget/sleep_screen.dart';
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
  TimeOfDay _selectedTime = TimeOfDay(hour: 4, minute: 34);

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    // final notificationSender = DependScope.of(
    //   context,
    // ).dependModel.notificationsSender;
    final alarmService = DependScope.of(context).dependModel.alarmService;
    final clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNoitifier;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: AppSizes.screenHeightOfContext(context) * 0.15),
            Text('hello  friend', style: theme.typography.h1.copyWith()),
            ClockWidget(clockStream: clockStream, theme: theme),
            SizedBox(height: 24),
            SizedBox(
              width: 110,
              height: 40,
              child: AdaptiveCard(
                borderRadius: .all(.circular(24)),
                backgroundColor: ColorConstants.pastelIndigo,
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.notifications),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
    
                        int hour = time?.hour ?? _selectedTime.hour;
                        int minute = time?.minute ?? _selectedTime.minute;
    
                        await alarmService.setAlarm(
                          title: 'title',
                          body: 'body',
                          hour: hour,
                          minute: minute,
                        );
    
                        logger.debug('setalarm');
    
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Будильник установлене на $hour:${minute.toString().padLeft(2, '0')}',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '${_selectedTime.hour.toString()}:${_selectedTime.minute.toString()}',
                        style: theme.typography.h6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Lottie.asset(Assets.lottie.sleepingPolarBear.path),
            SizedBox(
              width: 200,
              height: 60,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SleepScreen();
                    },
                  ),
                ),
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
