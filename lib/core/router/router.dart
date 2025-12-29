import 'package:dreamscape/features/app/widget/root_screen.dart';
import 'package:dreamscape/features/home/widget/home_screen.dart';
import 'package:dreamscape/features/stats/widget/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dreamscape/features/home/widget/sleep_screen.dart';

part 'router.g.dart';

@TypedStatefulShellRoute<RootRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    //home
    TypedStatefulShellBranch<HomeShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRouteDate>(
          path: '/home',
          routes: [TypedGoRoute<SleepScreenData>(path: 'home/sleep')],
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
    return HomeScreen();
  }
}

class SleepScreenData extends GoRouteData with $SleepScreenData {
  const SleepScreenData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SleepScreen();
  }
}

//statsBracnh

class StatsShellBranchData extends StatefulShellBranchData {}

class StatsData extends GoRouteData with $StatsData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StatsScreen();
  }
}

// ProfileBranch

class ProfileShellBranchData extends StatefulShellBranchData {}

class ProfileScreenData extends GoRouteData with $ProfileScreenData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: implement build
    return ProfileScreen();
  }
}

//TODO Delete when  finish the corresponding features

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.green);
  }
}
