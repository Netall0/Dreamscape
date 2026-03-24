// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $rootRouteData,
  $signInRoute,
  $addFromWatchRoute,
  $editNameRoute,
  $feedbackDialogRoute,
  $sleepDialogRoute,
];

RouteBase get $rootRouteData => StatefulShellRouteData.$route(
  factory: $RootRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          factory: $HomeRouteDate._fromState,
          routes: [
            GoRouteData.$route(
              path: 'sleep',
              factory: $SleepScreenData._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/stats',
          factory: $StatsData._fromState,
          routes: [
            GoRouteData.$route(
              path: 'analyze-stats',
              factory: $AnalyzeStatsData._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          factory: $SettingScreenData._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          factory: $ProfileScreenData._fromState,
        ),
      ],
    ),
  ],
);

extension $RootRouteDataExtension on RootRouteData {
  static RootRouteData _fromState(GoRouterState state) => RootRouteData();
}

mixin $HomeRouteDate on GoRouteData {
  static HomeRouteDate _fromState(GoRouterState state) => const HomeRouteDate();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SleepScreenData on GoRouteData {
  static SleepScreenData _fromState(GoRouterState state) =>
      const SleepScreenData();

  @override
  String get location => GoRouteData.$location('/home/sleep');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StatsData on GoRouteData {
  static StatsData _fromState(GoRouterState state) => StatsData();

  @override
  String get location => GoRouteData.$location('/stats');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AnalyzeStatsData on GoRouteData {
  static AnalyzeStatsData _fromState(GoRouterState state) => AnalyzeStatsData();

  @override
  String get location => GoRouteData.$location('/stats/analyze-stats');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingScreenData on GoRouteData {
  static SettingScreenData _fromState(GoRouterState state) =>
      SettingScreenData();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileScreenData on GoRouteData {
  static ProfileScreenData _fromState(GoRouterState state) =>
      ProfileScreenData();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRoute => GoRouteData.$route(
  path: '/signin',
  factory: $SignInRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'signup', factory: $SignUpRoute._fromState),
  ],
);

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) => SignInRoute();

  @override
  String get location => GoRouteData.$location('/signin');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SignUpRoute on GoRouteData {
  static SignUpRoute _fromState(GoRouterState state) => SignUpRoute();

  @override
  String get location => GoRouteData.$location('/signin/signup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $addFromWatchRoute => GoRouteData.$route(
  path: '/add-from-health-device',
  factory: $AddFromWatchRoute._fromState,
);

mixin $AddFromWatchRoute on GoRouteData {
  static AddFromWatchRoute _fromState(GoRouterState state) =>
      AddFromWatchRoute();

  @override
  String get location => GoRouteData.$location('/add-from-health-device');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editNameRoute =>
    GoRouteData.$route(path: '/edit-name', factory: $EditNameRoute._fromState);

mixin $EditNameRoute on GoRouteData {
  static EditNameRoute _fromState(GoRouterState state) => EditNameRoute();

  @override
  String get location => GoRouteData.$location('/edit-name');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $feedbackDialogRoute => GoRouteData.$route(
  path: '/feedback-dialog',
  factory: $FeedbackDialogRoute._fromState,
);

mixin $FeedbackDialogRoute on GoRouteData {
  static FeedbackDialogRoute _fromState(GoRouterState state) =>
      FeedbackDialogRoute();

  @override
  String get location => GoRouteData.$location('/feedback-dialog');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sleepDialogRoute => GoRouteData.$route(
  path: '/sleep-dialog',
  factory: $SleepDialogRoute._fromState,
);

mixin $SleepDialogRoute on GoRouteData {
  static SleepDialogRoute _fromState(GoRouterState state) => SleepDialogRoute();

  @override
  String get location => GoRouteData.$location('/sleep-dialog');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
