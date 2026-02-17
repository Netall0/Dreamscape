// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_theme.dart';

import '../../../core/l10n/app_localizations.g.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final SettingsController controller = DependScope.of(context).dependModel.settingsController;
    final ThemeModes currentMode = ThemeModes.values.firstWhere(
      (mode) => mode.name == controller.themeMode,
      orElse: () => ThemeModes.light,
    );
    final String localeCode = controller.localeCode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(l10n.settings, style: theme.typography.h1),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: AdaptiveThemeCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.theme, style: theme.typography.h3),
                      const SizedBox(height: 12),
                      ...ThemeModes.values.map(
                        (mode) => ChoiceWidget(
                          title: mode.name == ThemeModes.dark.name ? l10n.dark : l10n.light,
                          isSelected: mode == currentMode,
                          onTap: () => controller.setThemeMode(mode.name),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.backgroundAnimation, style: theme.typography.h3),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.colors.surface,
                          border: Border.all(color: theme.colors.dividerColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.animationEnabled ? l10n.on : l10n.off,
                                  style: theme.typography.bodyMedium.copyWith(
                                    color: theme.colors.textPrimary,
                                  ),
                                ),
                              ),
                              Switch.adaptive(
                                value: controller.animationEnabled,
                                onChanged: controller.setAnimationEnabled,
                                activeColor: theme.colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.language, style: theme.typography.h3),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.colors.surface,
                          border: Border.all(color: theme.colors.dividerColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: localeCode,
                                    isExpanded: true,
                                    items: [
                                      DropdownMenuItem(value: 'ru', child: Text(l10n.languageRussian)),
                                      DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.setLocaleCode(value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdaptiveThemeCard extends StatelessWidget {
  const AdaptiveThemeCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colors.dividerColor),
        color: theme.colors.cardBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class ChoiceWidget extends StatelessWidget {
  const ChoiceWidget({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? theme.colors.primary.withOpacity(0.16) : theme.colors.surface,
            border: Border.all(
              color: isSelected ? theme.colors.primary : theme.colors.dividerColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.typography.h5.copyWith(color: theme.colors.textPrimary),
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? theme.colors.primary : theme.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
