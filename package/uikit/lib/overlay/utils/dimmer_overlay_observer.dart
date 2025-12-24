import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/utils/dimmed_overlay_level.dart';

class DimmerOverlayObserver extends NavigatorObserver {
  final DimmerOverlayNotifier _notifier;
  final Set<String> _dimmerRoutes;

  DimmerOverlayObserver({
    required DimmerOverlayNotifier notifier,
    required Set<String> dimmerRoutes,
  }) : _notifier = notifier,
       _dimmerRoutes = dimmerRoutes;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRoute(route));

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (previousRoute != null) {
        _checkRoute(previousRoute);
      } else {
        _notifier.setLevel(DimLevel.none);
      }
    });
    super.didPop(route, previousRoute);
  }

  void _checkRoute(Route route) {
    final routeName = route.settings.name;
    log('current route:$route');
    if (_dimmerRoutes.contains(routeName)) {
      _notifier.setLevel(DimLevel.strong);
    } else {
      _notifier.setLevel(DimLevel.none);
    }
  }
}
