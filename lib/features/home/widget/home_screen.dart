import 'dart:async';

import 'package:dreamscape/common/gen/assets.gen.dart';
import 'package:dreamscape/core/util/lottie_utils.dart';
import 'package:dreamscape/core/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:uikit/painter/gradient_background_painter.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/custom_bottom_navigation_bar.dart';
import 'package:uikit/widget/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _ScreenState();
}

class _ScreenState extends State<HomeScreen> {
  late final Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    // Stream создаётся один раз!
    _timeStream = Stream.periodic(
      const Duration(seconds: 1), // Обновляем каждую секунду для плавности
      (_) => DateTime.now(),
    );
  }

  //TODO first running application

  final List<CustomBottomNavigationBarItems> items = [
    CustomBottomNavigationBarItems(name: 'home', icons: Icon(Icons.home)),
    CustomBottomNavigationBarItems(
      name: 'music',
      icons: Icon(Icons.music_note),
    ),
    CustomBottomNavigationBarItems(
      name: 'stats',
      icons: Icon(Icons.graphic_eq),
    ),
    CustomBottomNavigationBarItems(name: 'profile', icons: Icon(Icons.person)),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final size = context.size!;
    return AnimatedBackground(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          color: Colors.transparent,
          height: size.height * 0.1,
          borderValue: AppSizes.radiusMedium,
          items: items,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: AppSizes.screenHeightOfContext(context) * 0.15),
              Text(
                'good ${DayTime.day.value} friend',
                style: theme.typography.h3,
              ),
              StreamBuilder<DateTime>(
                stream: _timeStream,
                builder: (context, snapshot) {
                  return switch (snapshot) {
                    AsyncSnapshot(:final data?) => Text(
                      '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}',
                      style: theme.typography.h1,
                    ),
                    AsyncSnapshot(hasError: true) => Text(
                      'Error: ${snapshot.error}',
                    ),
                    _ => const CircularProgressIndicator(),
                  };
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: 110,
                height: 40,
                child: AdaptiveCard(
                  borderRadius: .all(.circular(24)),
                  backgroundColor: ColorConstants.pastelIndigo,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [Icon(Icons.notifications), Text('08:05')],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Lottie.asset(Assets.lottie.sleepingPolarBear.path),
              SizedBox(
                width: 200,
                height: 60,
                child: AdaptiveCard(
                  borderRadius: .all(.circular(24)),
                  backgroundColor: ColorConstants.pastelIndigo,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [Icon(Icons.notifications), Text('Начать сон')],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
