import 'package:dreamscape/core/router/navigator_observer.dart';
import 'package:dreamscape/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
  late final GoRouter _router;

  @override
  void initState() {
    _router = GoRouter(
      routes: $appRoutes,
      initialLocation: '/home',
      observers: [NavObserver()],
    );
    super.initState();
  }

  // only one theme in app
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(useMaterial3: true, extensions: [AppTheme.light]),
      darkTheme: ThemeData(useMaterial3: true, extensions: [AppTheme.dark]),
      debugShowCheckedModeBanner: false,
    );
  }
}

//TODO settings feature
