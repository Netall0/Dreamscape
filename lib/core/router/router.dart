import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/utils/dimmer_overlay_observer.dart';
import 'package:uikit/theme/app_theme.dart';
import 'package:uikit/widget/button.dart';
import 'package:uikit/widget/card.dart';
import 'package:uuid/uuid.dart';

import '../../features/app/widget/root_screen.dart';
import '../../features/auth/controller/bloc/auth_bloc.dart';
import '../../features/auth/controller/notifier/load_user_info_notifier.dart';
import '../../features/auth/widget/profile_screen.dart';
import '../../features/auth/widget/sign_in_screen.dart';
import '../../features/auth/widget/sing_up_screen.dart';
import '../../features/home/widget/home_screen.dart';
import '../../features/home/widget/sleep_screen.dart';
import '../../features/initialization/widget/depend_scope.dart';
import '../../features/news/widget/news_screen.dart';
import '../../features/settings/widget/settings_screen.dart';
import '../../features/stats/controller/bloc/stats_list_bloc.dart';
import '../../features/stats/model/stats_model.dart';
import '../../features/stats/widget/analyze_stats_screen.dart';
import '../../features/stats/widget/stats_screen.dart';
import '../service/ai/data/ai_sleep_service.dart';
import '../service/ai/scope/ai_scope_wrapper.dart';
import '../service/feedback/data/feeedback_repository.dart';
import '../service/feedback/feedback_model.dart';
import '../util/extension/app_context_extension.dart';
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

    //news

    //TODO maybe

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

//news shell

class NewsShellBranchData extends StatefulShellBranchData {}

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
      title: Text(context.l10n.addStatsTitle),
      content: Text(context.l10n.addStatsPrompt),
      actions: [
        TextButton(onPressed: () => context.pop(), child: Text(context.l10n.addStatsNo)),
        ElevatedButton(
          onPressed: () {
            try {
              DependScope.of(context).dependModel.statsBloc.add(StatsEventAddFromHealth());
              logger.debug('StatsEventAddFromHealth added to bloc');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(context.l10n.addStatsAdded)));
            } on Object catch (e, stackTrace) {
              logger.error(
                'Failed to add StatsEventAddFromHealth',
                error: e,
                stackTrace: stackTrace,
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${context.l10n.addStatsErrorPrefix}: $e')));
            } finally {
              if (context.mounted) {
                context.pop();
              }
            }
          },
          child: Text(context.l10n.addStatsYes),
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
        title: Text(context.l10n.editNameTitle),
        content: TextField(controller: args.emailController),

        actions: [
          TextButton(child: Text(context.l10n.cancel), onPressed: () => context.pop()),
          TextButton(
            child: Text(context.l10n.save),
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

// feedback dialog

final class FeedbackDialogExtras {
  FeedbackDialogExtras({this.initialName, this.initialEmail});

  final String? initialName;
  final String? initialEmail;
}

@TypedGoRoute<FeedbackDialogRoute>(path: '/feedback-dialog')
class FeedbackDialogRoute extends GoRouteData with $FeedbackDialogRoute {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final args = state.extra as FeedbackDialogExtras?;
    return DialogPage(
      child: _FeedbackDialog(
        initialName: args?.initialName,
        initialEmail: args?.initialEmail,
      ),
    );
  }
}

// sleep dialog

final class SleepDialogExtras {
  SleepDialogExtras({required this.textConrtoller, required this.sleepQualityCallback});
  final TextEditingController textConrtoller;
  final SleepQualityCallback sleepQualityCallback;
}

@TypedGoRoute<SleepDialogRoute>(path: '/sleep-dialog')
class SleepDialogRoute extends GoRouteData with $SleepDialogRoute {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final AppTheme theme = context.appTheme;
    final args = state.extra! as SleepDialogExtras;
    return DialogPage(
      child: AlertDialog.adaptive(
        title: Text(context.l10n.chooseSleepQualityTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            children: [
              TextField(
                maxLines: 10,
                maxLength: 200,
                controller: args.textConrtoller,
                decoration: InputDecoration(
                  hintText: context.l10n.sleepDialogNotesHint,
                  hintStyle: theme.typography.h5,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colors.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colors.primary),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: SleepQuality.values
                    .map(
                      (e) => AdaptiveCard(
                        onTap: () {
                          args.sleepQualityCallback(e);
                        },
                        padding: const .all(16),
                        margin: const .all(4),
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [e.icon, Text(e.name)],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackDialog extends StatefulWidget {
  const _FeedbackDialog({this.initialName, this.initialEmail});

  final String? initialName;
  final String? initialEmail;

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late final TextEditingController _emailController = TextEditingController(
    text: widget.initialEmail ?? '',
  );
  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;
  String? _nameError;
  String? _emailError;
  String? _messageError;
  String? _sendError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(AppTheme theme, String label, IconData icon, String? error) =>
      InputDecoration(
        labelText: label,
        labelStyle: theme.typography.h6.copyWith(color: theme.colors.textSecondary),
        prefixIcon: Icon(icon, color: theme.colors.textSecondary),
        errorText: error,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colors.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colors.textPrimary),
        ),
      );

  bool _validate(AppTheme theme) {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String message = _messageController.text.trim();
    final bool isEmailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    setState(() {
      _nameError = name.isEmpty ? 'Введите имя' : null;
      _emailError = isEmailValid ? null : context.l10n.authInvalidEmailError;
      _messageError = message.length < 3 ? 'Введите сообщение' : null;
    });

    return _nameError == null && _emailError == null && _messageError == null;
  }

  Future<void> _sendFeedback() async {
    if (!_validate(context.appTheme)) {
      return;
    }

    setState(() {
      _isSending = true;
      _sendError = null;
    });

    try {
      await FeeedbackRepository().sendFeedback(
        FeedbackModel(
          id: const Uuid().v4(),
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
      if (mounted) {
        context.pop(true);
      }
    } on Object {
      if (mounted) {
        setState(() => _sendError = 'Не удалось отправить. Попробуйте позже.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;

    return AlertDialog.adaptive(
      backgroundColor: theme.colors.cardBackground,
      title: Row(
        children: [
          Icon(Icons.feedback_outlined, color: theme.colors.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.profileFeedback,
              style: theme.typography.h2,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              enabled: !_isSending,
              decoration: _inputDecoration(
                theme,
                context.l10n.profileNamePlaceholder,
                Icons.person_outline,
                _nameError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              enabled: !_isSending,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                theme,
                context.l10n.authEmailLabel,
                Icons.email_outlined,
                _emailError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              enabled: !_isSending,
              maxLines: 4,
              decoration: _inputDecoration(
                theme,
                'Сообщение',
                Icons.message_outlined,
                _messageError,
              ),
            ),
            if (_sendError != null) ...[
              const SizedBox(height: 8),
              Text(
                _sendError!,
                style: theme.typography.bodyMedium.copyWith(color: theme.colors.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        AdaptiveButton.text(
          onPressed: _isSending ? null : () => context.pop(false),
          child: Text(
            context.l10n.cancel,
            style: theme.typography.h6.copyWith(color: theme.colors.textSecondary),
          ),
        ),
        AdaptiveButton.primary(
          onPressed: _isSending ? null : _sendFeedback,
          child: _isSending
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.save, style: theme.typography.h6),
        ),
      ],
    );
  }
}

//TODO navigation bug
