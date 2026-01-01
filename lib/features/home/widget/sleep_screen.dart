import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/repository/temp_repository.dart';
import 'package:dreamscape/core/util/extension/time_of_day_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/features/stats/bloc/stats_bloc.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:dreamscape/features/home/widget/alarm_time_picker_widget.dart';
import 'package:dreamscape/features/home/widget/clock_widget.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/custom_round_music_bar.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with SingleTickerProviderStateMixin, LoggerMixin {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    logger.debug('initState called');

    _player = DependScope.of(context).dependModel.audioPlayer;
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (_player.audioSource != null) {
      logger.debug('player already initialized, skipping');
      return;
    }

    logger.debug('initializing player for the first time');

    try {
      await _player.setAsset(Assets.sound.rain);
      if (!mounted) return;

      await _player.setLoopMode(LoopMode.one);
      if (!mounted) return;

      logger.debug('player initialized successfully');
    } catch (e, stackTrace) {
      logger.error('audio init failed', error: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _player.pause();
    logger.debug('dispose: paused player');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final size = MediaQuery.of(context).size;
    final bloc = DependScope.of(context).dependModel.statsBloc;
    final clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final alarmService = DependScope.of(
      context,
    ).platformDependContainer.alarmService;
    final tempRep = DependScope.of(context).dependModel.tempRepository;
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.mood))],
        leading: IconButton(
          onPressed: () {
            tempRep.clearTempData();
            logger.debug('clear times');
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: .center,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ClockWidget(clockStream: clockStream, theme: theme),
            SizedBox(height: 24),
            AlarmTimePickerWidget(alarmService: alarmService),
            SizedBox(height: AppSizes.double20),
            Stack(
              alignment: .center,
              children: [
                SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.6,
                  child: CustomRoundMusicBar(isPlaying: _player.playingStream),
                ),
                SizedBox(
                  height: size.height * 0.4,
                  width: size.width * 0.4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorConstants.duskPurple,
                        width: 6,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.4,
                  width: size.width * 0.4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorConstants.nightViolet,
                        width: 4,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: size.height * 0.1,
                  width: size.width * 0.1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.nightViolet,
                    ),
                    child: Align(
                      alignment: .center,
                      child: StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;

                          final isPlaying = state?.playing ?? false;
                          final isLoading =
                              state?.processingState ==
                                  ProcessingState.loading ||
                              state?.processingState ==
                                  ProcessingState.buffering;

                          return IconButton(
                            alignment: .center,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (isPlaying) {
                                      await _player.pause();
                                    } else {
                                      await _player.play();
                                    }
                                  },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              width: 200,
              height: 60,
              child: GestureDetector(
                onTap: () async {
                  await _onTapAdding(tempRep, bloc, context);
                },
                child: AdaptiveCard(
                  borderRadius: .all(.circular(24)),
                  backgroundColor: ColorConstants.pastelIndigo,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.play_arrow),
                      Text(
                        'остановить сон',
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

  Future<void> _onTapAdding(
    TempRepository tempRep,
    StatsBloc bloc,
    BuildContext context,
  ) async {
    final riseTime = TimeOfDay.now(); //TODO
    await tempRep.saveRiseTime(
      TimeOfDay(hour: riseTime.hour, minute: riseTime.minute),
    );

    logger.debug('time rise ${riseTime.hour}:${riseTime.minute}');
    final bedTime =
        await tempRep.getBedTime() ??
        TimeOfDay(hour: riseTime.hour, minute: riseTime.minute);

    bloc.add(
      StatsEventAddStats(
        statsModel: StatsModel(
          bedTime: await tempRep.getBedTime() ?? riseTime,
          riseTime: TimeOfDay(hour: riseTime.hour, minute: riseTime.minute),
          sleepQuality: SleepQuality.normal,
          sleepTime: bedTime.calculationSleepTime(riseTime),
          sleepNotes: 'хахахахахахахааххах',
        ),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('congratulations!!!, sleep added ')),
      );
      context.go('/stats');
      await tempRep.clearTempData();
    }
  }
}
