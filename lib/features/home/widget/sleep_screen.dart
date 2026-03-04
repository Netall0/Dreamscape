import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/custom_round_music_bar.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../core/data/temp/repository/temp_repository.dart';
import '../../../core/l10n/app_localizations.g.dart';
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
  final TextEditingController _textConrtoller = TextEditingController();

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
      if (!mounted) {
        return;
      }

      await _player.setLoopMode(LoopMode.one);
      if (!mounted) {
        return;
      }

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppTheme theme = context.appTheme;
    final Size size = MediaQuery.sizeOf(context);
    final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
    final StreamClockController clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final AlarmService alarmService = DependScope.of(context).platformDependContainer.alarmService;
    final TempRepository tempRep = DependScope.of(context).dependModel.tempRepository;
    final StatsCalculateNotifier statsNotifier = DependScope.of(context).dependModel.statsNotifier;

    //TODO i know

    return Scaffold(
      backgroundColor: Colors.transparent,
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
      body: Align(
        child: SingleChildScrollView(
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
                        border: Border.all(color: theme.colors.primary, width: 6),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width * 0.4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colors.secondary, width: 4),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colors.primaryVariant,
                      ),
                      child: Align(
                        child: StreamBuilder<PlayerState>(
                          stream: _player.playerStateStream,
                          builder: (context, snapshot) {
                            final PlayerState? state = snapshot.data;

                            final bool isPlaying = state?.playing ?? false;
                            final bool isLoading =
                                state?.processingState == ProcessingState.loading ||
                                state?.processingState == ProcessingState.buffering;

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
                                color: theme.colors.onPrimary,
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
                      textConrtoller: _textConrtoller,
                      tempRep: tempRep,
                      bloc: bloc,
                      context: context,
                      statsNotifier: statsNotifier,
                    );
                  },
                  child: AdaptiveCard(
                    borderRadius: const .all(.circular(24)),
                    backgroundColor: theme.colors.primary,
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(Icons.play_arrow, color: theme.colors.onPrimary),
                        Text(
                          l10n.stopSleep,
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
    );
  }

  Future<void> _onTapAdding({
    required TempRepository tempRep,
    required StatsCalculateNotifier statsNotifier,
    required StatsListBloc bloc,
    required BuildContext context,
    required TextEditingController textConrtoller,
  }) async {
    final riseTime = TimeOfDay.now(); //TODO
    SleepQuality sleepQuality = SleepQuality.good;
    final AppTheme theme = context.appTheme;
    final AppLocalizations l10n = context.l10n;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog.adaptive(
          title: Text(l10n.writeReviewChooseQuality),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  maxLines: 10,
                  maxLength: 200,
                  controller: textConrtoller,
                  decoration: InputDecoration(
                    hintText: l10n.writeSleepNotes,
                    hintStyle: theme.typography.bodySmall.copyWith(
                      color: theme.colors.textSecondary,
                    ),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.primary),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: SleepQuality.values
                      .map(
                        (e) => AdaptiveCard(
                          backgroundColor: sleepQuality == e
                              ? theme.colors.primary
                              : theme.colors.surface,
                          onTap: () {
                            setStateDialog(() {
                              sleepQuality = e;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Text(
                              e.name,
                              style: theme.typography.bodyMedium.copyWith(
                                color: sleepQuality == e
                                    ? theme.colors.onPrimary
                                    : theme.colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => context.pop(), child: Text(l10n.cancel)),
            TextButton(
              onPressed: () async {
                await sendReq(
                  riseTime,
                  tempRep,
                  statsNotifier,
                  bloc,
                  sleepQuality,
                  textConrtoller,
                  context,
                );
                if (context.mounted) {
                  context.pop();
                }
              },
              child: Text(l10n.done),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendReq(
    TimeOfDay riseTime,
    TempRepository tempRep,
    StatsCalculateNotifier statsNotifier,
    StatsListBloc bloc,
    SleepQuality sleepQuality,
    TextEditingController textConrtoller,
    BuildContext context,
  ) async {
    final AppLocalizations l10n = context.l10n;
    logger.debug('time rise ${riseTime.hour}:${riseTime.minute}');
    final TimeOfDay bedTime =
        await tempRep.getBedTime() ?? TimeOfDay(hour: riseTime.hour, minute: riseTime.minute);

    final TimeOfDay sleepDuration = bedTime.calculationSleepTime(riseTime);

    statsNotifier.setStats();

    bloc.add(
      StatsEventAddStats(
        statsModel: StatsModel(
          bedTime: bedTime,
          riseTime: TimeOfDay(hour: riseTime.hour, minute: riseTime.minute),
          sleepQuality: sleepQuality,
          sleepTime: sleepDuration,
          sleepNotes: textConrtoller.text,
          sleepDate: DateTime.now(),
        ),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.sleepAdded)));

      context.pop();
    }
    await statsNotifier.setStats();
    await tempRep.clearTempData();
  }
}
