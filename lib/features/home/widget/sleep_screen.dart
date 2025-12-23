import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/extension/app_context_extension.dart';
import 'package:dreamscape/features/home/widget/alarm_time_picker_widget.dart';
import 'package:dreamscape/features/home/widget/clock_widget.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setAsset(Assets.sound.rain);
      if (!mounted) return;

      await _player.setLoopMode(LoopMode.one);
      if (!mounted) return;

      setState(() => _isInitialized = true);
    } catch (e, stackTrace) {
      logger.error('audio', error: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _player.pause();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final size = MediaQuery.of(context).size;
    final clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNotifier;
    final alarmService = DependScope.of(
      context,
    ).platformDependContainer.alarmService;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyActions: true,
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
              height: size.height * 0.1,
              child: AdaptiveCard(child: Column()),
            ),

            SizedBox(
              height: size.height * 0.05,
              width: size.width * 0.5,
              child: AdaptiveButton.primary(
                onPressed: () {},
                color: ColorConstants.nightViolet,
                child: Text(
                  'Начать сон',
                  style: theme.typography.h5.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
