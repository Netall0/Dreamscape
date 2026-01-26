import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/utils/dimmer_overlay_observer.dart';

import '../../features/app/widget/root_screen.dart';
import '../../features/auth/controller/bloc/auth_bloc.dart';
import '../../features/auth/widget/profile_screen.dart';
import '../../features/auth/widget/sign_in_screen.dart';
import '../../features/auth/widget/sing_up_screen.dart';
import '../../features/home/widget/home_screen.dart';
import '../../features/home/widget/sleep_screen.dart';
import '../../features/stats/widget/stats_screen.dart';
import 'navigator_observer.dart';

part 'router.g.dart';

final class AppRouter {
  static GoRouter router(AuthBloc authBloc, dimmedOverlayNotifier) => GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/signin',
    routes: $appRoutes,
    observers: [
      NavObserver(),

      DimmerOverlayObserver(
        notifier: DimmerOverlayNotifier(),
        dimmerRoutes: {'home/sleep'},
      ),
    ],
    redirect: (context, state) {
      final AuthState authState = authBloc.state;
      final String currentLocation = state.matchedLocation;

      final authPaths = ['/signin', '/signin/signup'];

      switch (state) {
        case _ when authState is AuthLoading:
          return null;

        case _ when authState is AuthUnauthenticated:
          if (authPaths.contains(currentLocation)) {
            return null;
          }
          return '/signin';

        case _ when authState is AuthAuthenticated:
          if (currentLocation == '/signin/signup') {
            return '/signin';
          }
          if (currentLocation == '/signin') {
            return '/home';
          }
      }

      return null;
    },
    refreshListenable: BlocListenable(authBloc.stream),
  );
}

class BlocListenable<T> extends ChangeNotifier {

  BlocListenable(Stream<T> s) : stream = s.asBroadcastStream() {
    _sub = stream.listen((_) => notifyListeners());
  }
  final Stream<T> stream;
  late final StreamSubscription<T> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

@TypedStatefulShellRoute<RootRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    //home
    TypedStatefulShellBranch<HomeShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRouteDate>(
          path: '/home',
          routes: [TypedGoRoute<SleepScreenData>(path: 'sleep')],
        ),
      ],
    ),

    // stats
    TypedStatefulShellBranch<StatsShellBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<StatsData>(path: '/stats')],
    ),

    //profile
    TypedStatefulShellBranch<StatefulShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileScreenData>(path: '/profile'),
      ],
    ),
  ],
)
class RootRouteData extends StatefulShellRouteData {
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return RootScreen(navigationShell);
  }
}

//notificaiotions branch

//home branch

class HomeShellBranchData extends StatefulShellBranchData {}

class HomeRouteDate extends GoRouteData with $HomeRouteDate {
  const HomeRouteDate();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class SleepScreenData extends GoRouteData with $SleepScreenData {
  const SleepScreenData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SleepScreen();
  }
}

//statsBracnh

class StatsShellBranchData extends StatefulShellBranchData {}

class StatsData extends GoRouteData with $StatsData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StatsScreen();
  }
}

// ProfileBranch

class ProfileShellBranchData extends StatefulShellBranchData {}

class ProfileScreenData extends GoRouteData with $ProfileScreenData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileScreen();
  }
}

@TypedGoRoute<SignInRoute>(
  path: '/signin',
  routes: [TypedGoRoute<SignUpRoute>(path: 'signup')],
)
class SignInRoute extends GoRouteData with $SignInRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInScreen();
  }
}

class SignUpRoute extends GoRouteData with $SignUpRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignUpScreen();
  }
}
