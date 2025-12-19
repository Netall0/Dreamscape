import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:flutter/widgets.dart';

final class NavObserver extends NavigatorObserver with LoggerMixin{
  @override
  void didPush(Route route, Route? previousRoute) {
    logger.debug('➡️ PUSH: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    logger.debug('⬅️ POP: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
   logger.debug('🔄 REPLACE: ${newRoute?.settings.name}');
  }
}
