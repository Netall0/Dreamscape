import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/widget/dimmed_overlay.dart';
import 'package:uikit/uikit.dart';
import 'package:uikit/widget/gradient_background.dart';

import '../../../core/router/router.dart';
import '../../auth/controller/bloc/auth_bloc.dart';
import '../../initialization/model/depend_container.dart';
import '../../initialization/widget/depend_scope.dart';
import '../../stats/controller/bloc/stats_list_bloc.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key, required this.dependContainer});

  final DependContainer dependContainer;

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
  late final GoRouter _router;
  final DimmerOverlayNotifier _dimmedOverlayNotifier = DimmerOverlayNotifier();
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = DependScope.of(context).dependModel.authBloc;
    _router = AppRouter.router(_authBloc, _dimmedOverlayNotifier);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    DependScope.of(context).dependModel.statsBloc.add(StatsEventLoadStats());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dimmedOverlayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.dependContainer.settingsController,
    builder: (context, child) => MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        extensions: const [AppTheme.light],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        extensions: const [AppTheme.dark],
      ),
      themeMode: widget.dependContainer.settingsController.themeMode == 'light'
          ? ThemeMode.light
          : ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyScrollBehavior(),
      builder: (context, child) => Stack(
        children: [
          AnimatedBackground(child: child!),
          AnimatedBuilder(
            animation: _dimmedOverlayNotifier,
            builder: (context, child) => DimmedOverlay(_dimmedOverlayNotifier.dimLevel),
          ),
        ],
      ),
    ),
  );
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
