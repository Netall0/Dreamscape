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
import '../../features/initialization/widget/depend_scope.dart';
import '../../features/settings/widget/settings_screen.dart';
import '../../features/stats/controller/bloc/stats_list_bloc.dart';
import '../../features/stats/model/stats_model.dart';
import '../../features/stats/widget/analyze_stats_screen.dart';
import '../../features/stats/widget/stats_screen.dart';
import '../service/ai/data/ai_sleep_service.dart';
import '../service/ai/scope/ai_scope_wrapper.dart';
import '../util/logger/logger.dart';
import 'navigator_observer.dart';

part 'router.g.dart';

typedef SleepQualityCallback = void Function(SleepQuality quality);

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
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<StatsData>(
          path: '/stats',
          routes: [TypedGoRoute<AnalyzeStatsData>(path: 'analyze-stats')],
        ),
      ],
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

class AnalyzeStatsData extends GoRouteData with $AnalyzeStatsData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Object? extra = state.extra;
    final List<StatsModel> sleepHistory = extra is List<StatsModel> ? extra : const <StatsModel>[];
    return AiScopeWrapper(
      aiSleepService: AiSleepService(),
      child: AnalyzeStatsScreen(sleepHistory: sleepHistory),
    );
  } //TODO pass real sleep history
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

//add from watch

final class AddFromHealthDeviceExtras {}

@TypedGoRoute<AddFromWatchRoute>(path: '/add-from-health-device')
class AddFromWatchRoute extends GoRouteData with $AddFromWatchRoute, LoggerMixin {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => DialogPage(
    child: AlertDialog.adaptive(
      title: const Text('Add Stats'),
      content: const Text('Do you want to add stats from Health?'),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('No')),
        ElevatedButton(
          onPressed: () {
            try {
              DependScope.of(context).dependModel.statsBloc.add(StatsEventAddFromHealth());
              logger.debug('StatsEventAddFromHealth added to bloc');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Stats added from Health')));
            } on Object catch (e, stackTrace) {
              logger.error(
                'Failed to add StatsEventAddFromHealth',
                error: e,
                stackTrace: stackTrace,
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('error adding stats: $e')));
            } finally {
              if (context.mounted) {
                context.pop();
              }
            }
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}

//add from wathch dialog
final class EditNameExtras {
  EditNameExtras({
    required this.userInfoNotifier,
    required this.emailController,
    required this.voidCallback,
  });

  final LoadInfoNotifier userInfoNotifier;
  final TextEditingController emailController;
  final VoidCallback voidCallback;
}

@TypedGoRoute<EditNameRoute>(path: '/edit-name')
class EditNameRoute extends GoRouteData with $EditNameRoute {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final args = state.extra! as EditNameExtras;

    return DialogPage(
      child: AlertDialog.adaptive(
        title: const Text('change name'),
        content: TextField(controller: args.emailController),

        actions: [
          TextButton(child: const Text('cancel'), onPressed: () => context.pop()),
          TextButton(
            child: const Text('save'),
            onPressed: () async {
              if (context.mounted) {
                context.pop();
              }
              args.userInfoNotifier.setUserName(args.emailController.text);
            },
          ),
        ],
      ),
    );
  }
}

// sleep dialog

@TypedGoRoute<SleepDialogRoute>(path: '/sleep-dialog')
class SleepDialogRoute extends GoRouteData with $SleepDialogRoute {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final args = state.extra! as SleepQualityCallback;
    return DialogPage(
      child: AlertDialog.adaptive(
        title: const Text('chose your sleep quality'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: SleepQuality.values
              .map(
                (e) => AdaptiveCard(
                  onTap: () {
                    args(e);
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


//TODO navigation bug
