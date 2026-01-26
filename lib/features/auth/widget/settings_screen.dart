import 'package:dreamscape/core/config/app_settings_notifier.dart';
import 'package:dreamscape/core/l10n/app_localizations.g.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final l10n = AppLocalizations.of(context)!;
    final appSettings = DependScope.of(context).dependModel.appSettingsNotifier;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.settings,
            style: theme.typography.h2,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListenableBuilder(
            listenable: appSettings,
            builder: (context, _) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AdaptiveCard(
                      backgroundColor: colors.cardBackground,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.palette, color: colors.primary),
                              const SizedBox(width: 12),
                              Text(
                                l10n.themeSettings,
                                style: theme.typography.h3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _ThemeOption(
                            title: l10n.darkTheme,
                            subtitle: l10n.darkThemeSubtitle,
                            isSelected: appSettings.currentTheme == AppThemeKind.dark,
                            onTap: () => appSettings.setTheme(AppThemeKind.dark),
                          ),
                          const SizedBox(height: 12),
                          _ThemeOption(
                            title: l10n.lightTheme,
                            subtitle: l10n.lightThemeSubtitle,
                            isSelected: appSettings.currentTheme == AppThemeKind.light,
                            onTap: () => appSettings.setTheme(AppThemeKind.light),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AdaptiveCard(
                      backgroundColor: colors.cardBackground,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.language, color: colors.primary),
                              const SizedBox(width: 12),
                              Text(
                                l10n.languageSettings,
                                style: theme.typography.h3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _LanguageOption(
                            title: l10n.english,
                            locale: AppLocaleKind.en,
                            isSelected: appSettings.currentLocale == AppLocaleKind.en,
                            onTap: () => appSettings.setLocale(AppLocaleKind.en),
                          ),
                          const SizedBox(height: 12),
                          _LanguageOption(
                            title: l10n.russian,
                            locale: AppLocaleKind.ru,
                            isSelected: appSettings.currentLocale == AppLocaleKind.ru,
                            onTap: () => appSettings.setLocale(AppLocaleKind.ru),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.15)
              : colors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.typography.h4.copyWith(
                      color: isSelected ? colors.primary : colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.typography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final AppLocaleKind locale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.15)
              : colors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.typography.h4.copyWith(
                  color: isSelected ? colors.primary : colors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

