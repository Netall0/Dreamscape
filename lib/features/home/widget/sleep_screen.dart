import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/repository/temp_repository.dart';
import 'package:dreamscape/core/util/extension/time_of_day_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_list_bloc.dart';
import 'package:dreamscape/features/stats/controller/notifier/stats_calculate_notifier.dart';
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

class _SleepScreenState extends State<SleepScreen> with LoggerMixin {
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
    final theme = context.appTheme;
    final size = MediaQuery.sizeOf(context);
    final bloc = DependScope.of(context).dependModel.statsBloc;
    final clockStream = DependScope.of(context).platformDependContainer.clockNotifier;
    final alarmService = DependScope.of(context).platformDependContainer.alarmService;
    final tempRep = DependScope.of(context).dependModel.tempRepository;
    final statsNotifier = DependScope.of(context).dependModel.statsNotifier;

    //TODO i know

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
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClockWidget(clockStream: clockStream, theme: theme),
                const SizedBox(height: 24),
                AlarmTimePickerWidget(alarmService: alarmService),
                const SizedBox(height: AppSizes.double20),
                Stack(
                  alignment: Alignment.center,
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
                          border: Border.all(color: theme.colors.surface, width: 6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.4,
                      width: size.width * 0.4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colors.cardBackground, width: 4),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colors.cardBackground,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: StreamBuilder<PlayerState>(
                            stream: _player.playerStateStream,
                            builder: (context, snapshot) {
                              final state = snapshot.data;
                              final isPlaying = state?.playing ?? false;
                              final isLoading =
                                  state?.processingState == ProcessingState.loading ||
                                  state?.processingState == ProcessingState.buffering;

                              return IconButton(
                                alignment: Alignment.center,
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
                                  color: theme.colors.textPrimary,
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
                const SizedBox(height: AppSizes.double20),
                SizedBox(
                  width: size.width * 0.7,
                  height: 56,
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
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      backgroundColor: theme.colors.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stop_rounded, color: theme.colors.onPrimary),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Завершить сон',
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
              ],
            ),
          ),
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

    await showDialog<void>(
      context: context,
      builder: (context) {
        final theme = context.appTheme;
        return AlertDialog(
          backgroundColor: theme.colors.cardBackground,
          title: Text(
            'Как ты спал?',
            style: TextStyle(color: theme.colors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: SleepQuality.values.map((e) {
              return Expanded(
                child: AdaptiveCard(
                  onTap: () {
                    sleepQuality = e;
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(4),
                  backgroundColor: theme.colors.surface,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        e.icon,
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            e.name,
                            style: TextStyle(color: theme.colors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    logger.debug('time rise ${riseTime.hour}:${riseTime.minute}');
    final bedTime =
        await tempRep.getBedTime() ?? TimeOfDay(hour: riseTime.hour, minute: riseTime.minute);

    final sleepDuration = bedTime.calculationSleepTime(riseTime);

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('congratulations!!!, sleep added')));

      context.pop();
    }
    await statsNotifier.setStats();
    await tempRep.clearTempData();
  }
}
