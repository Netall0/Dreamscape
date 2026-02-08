import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/widget/dimmed_overlay.dart';
import 'package:uikit/uikit.dart';

import '../../../core/router/router.dart';
import '../../auth/controller/bloc/auth_bloc.dart';
import '../../initialization/widget/depend_scope.dart';
import '../../stats/controller/bloc/stats_list_bloc.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

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
  
  // only one theme in app
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(useMaterial3: true, extensions: const [AppTheme.dark]),
      darkTheme: ThemeData(useMaterial3: true, extensions: const [AppTheme.dark]),
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyScrollBehavior(),
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



//allow scrolling on all devices
class MyScrollBehavior extends MaterialScrollBehavior {
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

//TODO settings feature
