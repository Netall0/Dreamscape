import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/custom_round_music_bar.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../core/repository/temp_repository.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../../../core/util/extension/time_of_day_extension.dart';
import '../../../core/util/logger/logger.dart';
import '../../alarm/services/alarm_service.dart';
import '../../initialization/widget/depend_scope.dart';
import '../../stats/controller/bloc/stats_list_bloc.dart';
import '../../stats/controller/notifier/stats_calculate_notifier.dart';
import '../../stats/model/stats_model.dart';
import '../controller/clock_stream_controller.dart';
import 'alarm_time_picker_widget.dart';
import 'clock_widget.dart';

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

      _player.play();

      logger.debug('player initialized successfully and played');
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
    final AppTheme theme = context.appTheme;
    final Size size = MediaQuery.sizeOf(context);
    final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
    final StreamClockController clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final AlarmService alarmService = DependScope.of(
      context,
    ).platformDependContainer.alarmService;
    final TempRepository tempRep = DependScope.of(context).dependModel.tempRepository;
    final StatsCalculateNotifier statsNotifier = DependScope.of(context).dependModel.statsNotifier;

    //TODO i know

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.mood))],
        leading: IconButton(
          onPressed: () {
            tempRep.clearTempData();
            logger.debug('clear times');
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Align(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ClockWidget(clockStream: clockStream, theme: theme),
            const SizedBox(height: 24),
            AlarmTimePickerWidget(alarmService: alarmService),
            const SizedBox(height: AppSizes.double20),
            Stack(
              alignment: .center,
              children: [
                SizedBox(
                  height: size.height * 0.2,
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.nightViolet,
                    ),
                    child: Align(
                      child: StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final PlayerState? state = snapshot.data;

                          final bool isPlaying = state?.playing ?? false;
                          final bool isLoading =
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
              height: size.height * 0.1,
              child: GestureDetector(
                onTap: () async {
                  await _onTapAdding(
                    tempRep: tempRep,
                    bloc: bloc,
                    context: context,
                    statsNotifier: statsNotifier,
                  );
                },
                child: AdaptiveCard(
                  borderRadius: const .all(.circular(24)),
                  backgroundColor: ColorConstants.pastelIndigo,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      const Icon(Icons.play_arrow),
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

  Future<void> _onTapAdding({
    required TempRepository tempRep,
    required StatsCalculateNotifier statsNotifier,
    required StatsListBloc bloc,
    required BuildContext context,
  }) async {
    final riseTime = TimeOfDay.now(); //TODO
    SleepQuality sleepQuality = SleepQuality.good;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('chose your sleep quality'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: SleepQuality.values.map((e) {
              return AdaptiveCard(
                onTap: () {
                  sleepQuality = e;
                  context.pop();
                },
                padding: const .all(16),
                margin: const .all(4),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [e.icon, Text(e.name)],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    logger.debug('time rise ${riseTime.hour}:${riseTime.minute}');
    final TimeOfDay bedTime =
        await tempRep.getBedTime() ??
        TimeOfDay(hour: riseTime.hour, minute: riseTime.minute);

    final TimeOfDay sleepDuration = bedTime.calculationSleepTime(riseTime);

    statsNotifier.setStats();

    bloc.add(
      StatsEventAddStats(
        statsModel: StatsModel(
          bedTime: bedTime,
          riseTime: TimeOfDay(hour: riseTime.hour, minute: riseTime.minute),
          sleepQuality: sleepQuality,
          sleepTime: sleepDuration,
          sleepNotes: 'хахахахахахахааххах',
        ),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('congratulations!!!, sleep added')),
      );

      context.pop();
    }
    await statsNotifier.setStats();
    await tempRep.clearTempData();
  }
}
