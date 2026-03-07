import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/utils/dimmer_overlay_observer.dart';
import 'package:uikit/widget/card.dart';

import '../../features/app/widget/root_screen.dart';
import '../../features/auth/controller/bloc/auth_bloc.dart';
import '../../features/auth/controller/notifier/load_user_info_notifier.dart';
import '../../features/auth/widget/profile_screen.dart';
import '../../features/auth/widget/sign_in_screen.dart';
import '../../features/auth/widget/sing_up_screen.dart';
import '../../features/home/widget/home_screen.dart';
import '../../features/home/widget/sleep_screen.dart';
import '../../features/settings/widget/settings_screen.dart';
import '../../features/stats/model/stats_model.dart';
import '../../features/stats/widget/stats_screen.dart';
import 'navigator_observer.dart';

part 'router.g.dart';

final class AppRouter {
  static GoRouter router(AuthBloc authBloc, DimmerOverlayNotifier dimmedOverlayNotifier) =>
      GoRouter(
        debugLogDiagnostics: true,
        initialLocation: '/signin',
        routes: $appRoutes,
        observers: [
          NavObserver(),

          DimmerOverlayObserver(notifier: dimmedOverlayNotifier, dimmerRoutes: {'home/sleep'}),
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

    //settings
    TypedStatefulShellBranch<SettingsShellBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<SettingScreenData>(path: '/settings')],
    ),

    //profile
    TypedStatefulShellBranch<StatefulShellBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<ProfileScreenData>(path: '/profile')],
    ),
  ],
)
class RootRouteData extends StatefulShellRouteData {
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => RootScreen(navigationShell);
}

//notificaiotions branch

//settings branch

class SettingsShellBranchData extends StatefulShellBranchData {}

class SettingScreenData extends GoRouteData with $SettingScreenData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsScreen();
}

//home branch

class HomeShellBranchData extends StatefulShellBranchData {}

class HomeRouteDate extends GoRouteData with $HomeRouteDate {
  const HomeRouteDate();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class SleepScreenData extends GoRouteData with $SleepScreenData {
  const SleepScreenData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SleepScreen();
}

//statsBracnh

class StatsShellBranchData extends StatefulShellBranchData {}

class StatsData extends GoRouteData with $StatsData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const StatsScreen();
}

// ProfileBranch

class ProfileShellBranchData extends StatefulShellBranchData {}

class ProfileScreenData extends GoRouteData with $ProfileScreenData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileScreen();
}

//auth

@TypedGoRoute<SignInRoute>(
  path: '/signin',
  routes: [TypedGoRoute<SignUpRoute>(path: 'signup')],
)
class SignInRoute extends GoRouteData with $SignInRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) => const SignInScreen();
}

class SignUpRoute extends GoRouteData with $SignUpRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) => const SignUpScreen();
}

//dialog routes

class DialogPage<T> extends Page<T> {
  const DialogPage({required this.child});
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) =>
      DialogRoute<T>(context: context, builder: (context) => child, settings: this);
}

// sleep dialog

final class DialogExtra {
  DialogExtra({required this.sleepQuality});
  SleepQuality sleepQuality;
}

@TypedGoRoute<SleepDialogRoute>(path: '/sleep-dialog')
class SleepDialogRoute extends GoRouteData with $SleepDialogRoute {
  @override
  Page<String?> buildPage(BuildContext context, GoRouterState state) {
    final args = state.extra! as DialogExtra;
    return DialogPage(
      child: AlertDialog.adaptive(
        title: const Text('chose your sleep quality'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: SleepQuality.values
              .map(
                (e) => AdaptiveCard(
                  onTap: () {
                    args.sleepQuality = e;
                    context.pop(e.name);
                  },
                  padding: const .all(16),
                  margin: const .all(4),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [e.icon, Text(e.name)]),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
