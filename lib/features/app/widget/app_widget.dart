import 'package:dreamscape/core/router/navigator_observer.dart';
import 'package:dreamscape/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/utils/dimmer_overlay_observer.dart';
import 'package:uikit/overlay/widget/dimmed_overlay.dart';
import 'package:uikit/uikit.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
  late final GoRouter _router;
  final DimmerOverlayNotifier _dimmedOverlayNotifier = DimmerOverlayNotifier();

  @override
  void initState() {
    _router = GoRouter(
      routes: $appRoutes,
      initialLocation: '/home',
      observers: [
        NavObserver(),

        DimmerOverlayObserver(
          notifier: _dimmedOverlayNotifier,
          dimmerRoutes: {'home/sleep'},
        ),
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    _dimmedOverlayNotifier.dispose();
    super.dispose();
  }

  // only one theme in app
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(useMaterial3: true, extensions: [AppTheme.dark]),
      darkTheme: ThemeData(useMaterial3: true, extensions: [AppTheme.dark]),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            AnimatedBuilder(
              animation: _dimmedOverlayNotifier,
              builder: (context, child) {
                return DimmedOverlay(_dimmedOverlayNotifier.dimLevel);
              },
            ),
          ],
        );
      },
    );
  }
}

//TODO settings feature
