import 'package:flutter/widgets.dart';

import '../util/logger/logger.dart';

final class NavObserver extends NavigatorObserver with LoggerMixin{
  @override
  // ignore: strict_raw_type
  void didPush(Route route, Route? previousRoute) {
    logger.debug('➡️ PUSH: ${route.settings.name}');
  }

  @override
  // ignore: strict_raw_type
  void didPop(Route route, Route? previousRoute) {
    logger.debug('⬅️ POP: ${route.settings.name}');
  }

  @override
  // ignore: strict_raw_type
  void didReplace({Route? newRoute, Route? oldRoute}) {
   logger.debug('🔄 REPLACE: ${newRoute?.settings.name}');
  }
}
