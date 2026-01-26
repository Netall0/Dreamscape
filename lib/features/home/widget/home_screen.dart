import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/l10n/app_localizations.g.dart';
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
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1024;
    // final notificationSender = DependScope.of(
    //   context,
    // ).dependModel.notificationsSender;
    final alarmService = DependScope.of(context).platformDependContainer.alarmService;
    final clockStream = DependScope.of(context).platformDependContainer.clockNotifier;
    final tempRep = DependScope.of(context).dependModel.tempRepository;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = isDesktop ? 800.0 : (isTablet ? 600.0 : double.infinity);
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                    vertical: isDesktop ? 32 : (isTablet ? 24 : 16),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: isDesktop ? size.height * .08 : size.height * .13),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'hello friend',
                          style: theme.typography.h1,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ClockWidget(clockStream: clockStream, theme: theme),
                      SizedBox(height: isDesktop ? 32 : 24),
                      AlarmTimePickerWidget(alarmService: alarmService),
                      SizedBox(height: isDesktop ? 32 : 24),
                      Lottie.asset(
                        Assets.lottie.sleepingPolarBear.path,
                        height: isDesktop
                            ? size.height * .25
                            : (isTablet
                                ? size.height * .35
                                : (size.width < 500
                                    ? size.height * .4
                                    : size.height * .3)),
                      ),
                      SizedBox(
                        width: isDesktop ? 300 : (isTablet ? 250 : 200),
                        height: isDesktop ? 56 : (isTablet ? 50 : size.height * .1),
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
                              final l10n = AppLocalizations.of(context)!;
                              final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.bedTime(timeString))),
                              );
                            }
                          },
                          child: SizedBox(
                            height: isDesktop ? 56 : (isTablet ? 50 : 40),
                            width: isDesktop ? 300 : (isTablet ? 250 : 200),
                            child: AdaptiveCard(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              backgroundColor: theme.colors.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow, color: theme.colors.onPrimary),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Начать сон',
                                      style: theme.typography.h5.copyWith(color: theme.colors.onPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
