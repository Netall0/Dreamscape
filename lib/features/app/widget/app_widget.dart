import 'package:dreamscape/core/config/app_settings_notifier.dart';
import 'package:dreamscape/core/l10n/app_localizations.g.dart';
import 'package:dreamscape/core/router/router.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/overlay/controller/dimmer_overlay_notifier.dart';
import 'package:uikit/overlay/widget/dimmed_overlay.dart';
import 'package:uikit/uikit.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
  late final GoRouter _router;
  final DimmerOverlayNotifier _dimmedOverlayNotifier = DimmerOverlayNotifier();
  late final AuthBloc _authBloc;
  late final AppSettingsNotifier _appSettings;
  @override
  void initState() {
    final depend = DependScope.of(context).dependModel;
    _authBloc = depend.authBloc;
    _appSettings = depend.appSettingsNotifier;
    _router = AppRouter.router(_authBloc, _dimmedOverlayNotifier);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    DependScope.of(context).dependModel.statsBloc.add(StatsEventLoadStats());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dimmedOverlayNotifier.dispose();
    super.dispose();
  }

  // only one theme in app
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appSettings,
      builder: (context, _) {
        final appTheme = _appSettings.currentAppTheme;
        return MaterialApp.router(
          routerConfig: _router,
          theme: ThemeData(useMaterial3: true, extensions: [appTheme]),
          darkTheme: ThemeData(useMaterial3: true, extensions: [appTheme]),
          debugShowCheckedModeBanner: false,
          locale: _appSettings.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                AnimatedBuilder(
                  animation: _dimmedOverlayNotifier,
                  builder: (context, _) {
                    return DimmedOverlay(_dimmedOverlayNotifier.dimLevel);
                  },
                ),
                if (!_appSettings.isOnboardingCompleted)
                  _OnboardingOverlay(onFinish: _appSettings.completeOnboarding),
              ],
            );
          },
        );
      },
    );
  }
}

class _OnboardingOverlay extends StatefulWidget {
  const _OnboardingOverlay({required this.onFinish});

  final Future<void> Function() onFinish;

  @override
  State<_OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<_OnboardingOverlay> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.background.withValues(alpha: 0.96)),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) => setState(() => _page = index),
                    children: [
                      _OnboardingPage(
                        title: l10n.onboardingTitle1,
                        subtitle: l10n.onboardingSubtitle1,
                        placeholder: l10n.onboardingPlaceholder,
                      ),
                      _OnboardingPage(
                        title: l10n.onboardingTitle2,
                        subtitle: l10n.onboardingSubtitle2,
                        placeholder: l10n.onboardingPlaceholder,
                      ),
                      _OnboardingPage(
                        title: l10n.onboardingTitle3,
                        subtitle: l10n.onboardingSubtitle3,
                        placeholder: l10n.onboardingPlaceholder,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isActive = index == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? colors.primary : colors.textSecondary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: AdaptiveCard(
                      onTap: () async {
                        if (_page < 2) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        } else {
                          await widget.onFinish();
                        }
                      },
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      backgroundColor: colors.primary,
                      child: Center(
                        child: Text(
                          _page < 2 ? l10n.onboardingNext : l10n.onboardingStart,
                          style: Theme.of(
                            context,
                          ).extension<AppTheme>()!.typography.h5.copyWith(color: colors.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.title, required this.subtitle, required this.placeholder});

  final String title;
  final String subtitle;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.sizeOf(context);
        final circleSize = size.width * 0.55;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.typography.h1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subtitle,
                      style: theme.typography.bodyLarge,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(circleSize / 2),
                      color: theme.colors.cardBackground,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          placeholder,
                          textAlign: TextAlign.center,
                          style: theme.typography.h3,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
