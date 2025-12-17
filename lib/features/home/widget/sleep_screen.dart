import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:dreamscape/features/home/widget/clock_widget.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uikit/colors/color_constant.dart';
import 'package:uikit/layout/app_size.dart';
import 'package:uikit/theme/app_theme.dart';
import 'package:uikit/widget/gradient_background.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _player.setAsset(Assets.sound.alarm);
    await _player.setLoopMode(LoopMode.one);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final size = MediaQuery.of(context).size;
    final clockStream = DependScope.of(
      context,
    ).platformDependContainer.clockNoitifier;
    return AnimatedBackground(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyActions: true,
        ), //TODO testing delete after
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: .center,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              ClockWidget(clockStream: clockStream, theme: theme),
              SizedBox(height: AppSizes.double20),

              Stack(
                alignment: .center,
                children: [
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
              SizedBox(height: size.height * 0.1),
              Text('rain.mp3'),
            ],
          ),
        ),
      ),
    );
  }
}
