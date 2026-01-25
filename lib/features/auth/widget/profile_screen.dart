import 'dart:io';

import 'package:dreamscape/core/config/app_settings_notifier.dart';
import 'package:dreamscape/core/l10n/app_localizations.g.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uikit/uikit.dart';

import '../controller/notifier/load_user_info_notifier.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with LoggerMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final depend = DependScope.of(context).dependModel;
      depend.userInfoNotifier.loadUserInfo();
    });
  }

  ImageProvider? _avatarProvider(File? localAvatar, String? remoteAvatarUrl) {
    if (localAvatar != null) {
      return ResizeImage(FileImage(localAvatar), width: 200, height: 200);
    }

    if (remoteAvatarUrl != null) {
      return ResizeImage(NetworkImage(remoteAvatarUrl), width: 200, height: 200);
    }

    return null;
  }

  final User? _currentUser = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    final AppTheme style = context.appTheme;
    final colors = style.colors;

    final dependModel = DependScope.of(context).dependModel;
    final LoadInfoNotifier userInfoNotifier = dependModel.userInfoNotifier;
    final AuthBloc bloc = dependModel.authBloc;
    final AppSettingsNotifier settings = dependModel.appSettingsNotifier;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AdaptiveCard(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  backgroundColor: colors.cardBackground,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.settings, color: colors.textPrimary),
                            onPressed: () => _showSettingsDialog(context, settings, l10n),
                          ),
                        ],
                      ),
                      ListenableBuilder(
                        listenable: userInfoNotifier,
                        builder: (context, child) {
                          return GestureDetector(
                            onTap: userInfoNotifier.isLoading ? null : userInfoNotifier.pickAvatar,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: colors.surface,
                                  backgroundImage: _avatarProvider(
                                    userInfoNotifier.localAvatar,
                                    userInfoNotifier.remoteAvatarUrl,
                                  ),
                                ),
                                if (userInfoNotifier.isLoading) const CircularProgressIndicator(),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.profile,
                        style: style.typography.h2,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _currentUser?.createdAt.split('T').first ?? '',
                        style: style.typography.h3.copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ListenableBuilder(
                  listenable: userInfoNotifier,
                  builder: (context, child) {
                    return AdaptiveCard(
                      backgroundColor: colors.cardBackground,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showNameDialog(context, userInfoNotifier, l10n),
                            child: RowGeneralWidget(
                              text: userInfoNotifier.userName ?? l10n.name,
                              icon: Icons.person,
                            ),
                          ),
                          Divider(color: colors.dividerColor, height: 1),
                          RowGeneralWidget(text: _currentUser?.email ?? '', icon: Icons.email),
                          Divider(color: colors.dividerColor, height: 1),
                          RowGeneralWidget(text: l10n.password, icon: Icons.password),
                          Divider(color: colors.dividerColor, height: 1),
                          GestureDetector(
                            onTap: () => _showPhoneDialog(context, userInfoNotifier, l10n),
                            child: RowGeneralWidget(
                              text:
                                  (userInfoNotifier.phoneNumber == null ||
                                      userInfoNotifier.phoneNumber!.trim().isEmpty)
                                  ? l10n.undefined
                                  : userInfoNotifier.phoneNumber!,
                              icon: Icons.phone,
                            ),
                          ),
                          Divider(color: colors.dividerColor, height: 1),
                          GestureDetector(
                            onTap: () => _showFeedbackDialog(context, l10n),
                            child: RowGeneralWidget(
                              text: l10n.feedback,
                              icon: Icons.feedback_outlined,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
                  onTap: () => bloc.add(const AuthLogoutRequested()),
                  backgroundColor: colors.error.withOpacity(0.15),
                  child: RowGeneralWidget(
                    text: l10n.signOut,
                    icon: Icons.logout_outlined,
                    iconColor: colors.error,
                    textColor: colors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showNameDialog(
    BuildContext context,
    LoadInfoNotifier userInfoNotifier,
    AppLocalizations l10n,
  ) async {
    final theme = context.appTheme;
    final nameController = TextEditingController(text: userInfoNotifier.userName ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l10n.changeName,
            style: theme.typography.h3.copyWith(color: theme.colors.textPrimary),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            style: TextStyle(color: theme.colors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.name,
              hintStyle: TextStyle(color: theme.colors.textSecondary),
              filled: true,
              fillColor: theme.colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colors.primary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancel, style: TextStyle(color: theme.colors.textSecondary)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colors.primary,
                foregroundColor: theme.colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await userInfoNotifier.setUserName(name);
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    ).whenComplete(() => nameController.dispose());
  }

  Future<void> _showSettingsDialog(
    BuildContext context,
    AppSettingsNotifier settings,
    AppLocalizations l10n,
  ) async {
    final theme = context.appTheme;
    final currentTheme = settings.currentTheme;
    final currentLocale = settings.currentLocale;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: theme.colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings, color: theme.colors.primary),
                    const SizedBox(width: 12),
                    Text(l10n.themeSettings, style: theme.typography.h3),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsOptionCard(
                  title: l10n.darkTheme,
                  subtitle: l10n.darkThemeSubtitle,
                  isSelected: currentTheme == AppThemeKind.dark,
                  icon: Icons.dark_mode,
                  onTap: () async {
                    await settings.setTheme(AppThemeKind.dark);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                ),
                const SizedBox(height: 8),
                _SettingsOptionCard(
                  title: l10n.lightTheme,
                  subtitle: l10n.lightThemeSubtitle,
                  isSelected: currentTheme == AppThemeKind.light,
                  icon: Icons.light_mode,
                  onTap: () async {
                    await settings.setTheme(AppThemeKind.light);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.language, color: theme.colors.primary),
                    const SizedBox(width: 12),
                    Text(l10n.languageSettings, style: theme.typography.h3),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsOptionCard(
                  title: l10n.russian,
                  subtitle: 'Русский язык интерфейса',
                  isSelected: currentLocale == AppLocaleKind.ru,
                  icon: Icons.language,
                  onTap: () async {
                    await settings.setLocale(AppLocaleKind.ru);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                ),
                const SizedBox(height: 8),
                _SettingsOptionCard(
                  title: l10n.english,
                  subtitle: 'English interface language',
                  isSelected: currentLocale == AppLocaleKind.en,
                  icon: Icons.language,
                  onTap: () async {
                    await settings.setLocale(AppLocaleKind.en);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPhoneDialog(
    BuildContext context,
    LoadInfoNotifier userInfoNotifier,
    AppLocalizations l10n,
  ) async {
    final theme = context.appTheme;
    final phoneController = TextEditingController(text: userInfoNotifier.phoneNumber ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.phone, color: theme.colors.primary),
              const SizedBox(width: 12),
              Text(
                l10n.changePhone,
                style: theme.typography.h3.copyWith(color: theme.colors.textPrimary),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.phoneHint,
                style: theme.typography.bodySmall.copyWith(color: theme.colors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                autofocus: true,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: theme.colors.textPrimary, fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: theme.colors.textSecondary),
                  hintText: '+7 (999) 123-45-67',
                  hintStyle: TextStyle(color: theme.colors.textDisabled),
                  filled: true,
                  fillColor: theme.colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colors.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancel, style: TextStyle(color: theme.colors.textSecondary)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colors.primary,
                foregroundColor: theme.colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final phone = phoneController.text.trim();
                if (phone.isEmpty) {
                  Navigator.pop(dialogContext);
                  return;
                }
                try {
                  await userInfoNotifier.setPhoneNumber(phone);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.phoneUpdated),
                        backgroundColor: theme.colors.secondary,
                      ),
                    );
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.phoneError), backgroundColor: theme.colors.error),
                    );
                  }
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    ).whenComplete(() => phoneController.dispose());
  }

  Future<void> _showFeedbackDialog(BuildContext context, AppLocalizations l10n) async {
    final theme = context.appTheme;
    final feedbackController = TextEditingController();
    String selectedCategory = 'suggestion';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setState) {
            return Dialog(
              backgroundColor: theme.colors.cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.feedback_outlined,
                            color: theme.colors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.feedbackTitle, style: theme.typography.h3),
                              Text(
                                l10n.feedbackSubtitle,
                                style: theme.typography.bodySmall.copyWith(
                                  color: theme.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.feedbackCategory, style: theme.typography.h5),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _CategoryChip(
                          label: l10n.feedbackCategoryBug,
                          icon: Icons.bug_report,
                          isSelected: selectedCategory == 'bug',
                          onTap: () => setState(() => selectedCategory = 'bug'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: l10n.feedbackCategorySuggestion,
                          icon: Icons.lightbulb_outline,
                          isSelected: selectedCategory == 'suggestion',
                          onTap: () => setState(() => selectedCategory = 'suggestion'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: feedbackController,
                      maxLines: 5,
                      style: TextStyle(color: theme.colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: l10n.feedbackHint,
                        hintStyle: TextStyle(color: theme.colors.textDisabled),
                        filled: true,
                        fillColor: theme.colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.colors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(color: theme.colors.textSecondary),
                          ),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colors.primary,
                            foregroundColor: theme.colors.onPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.send, size: 18),
                          label: Text(l10n.feedbackSend),
                          onPressed: () {
                            final text = feedbackController.text.trim();
                            if (text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.feedbackEmpty),
                                  backgroundColor: theme.colors.error,
                                ),
                              );
                              return;
                            }
                            // TODO: feedbackService.send(category: selectedCategory, text: text);
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.feedbackSent),
                                backgroundColor: theme.colors.secondary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() => feedbackController.dispose());
  }
}

// ВИДЖЕТ КАК НА ГИТХАБЕ С ЗАКРАШЕННЫМИ КОРОБОЧКАМИ
class GitHubStyleContributionWidget extends StatelessWidget {
  const GitHubStyleContributionWidget({
    super.key,
    required this.count,
    this.maxPerRow = 7,
    this.boxSize = 12.0,
    this.spacing = 3.0,
    this.color,
  });

  final int count;
  final int maxPerRow;
  final double boxSize;
  final double spacing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeColor = color ?? theme.colors.primary;
    final inactiveColor = theme.colors.surface;

    final rows = (count / maxPerRow).ceil();
    final totalBoxes = rows * maxPerRow;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rows - 1 ? spacing : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(maxPerRow, (colIndex) {
              final boxIndex = rowIndex * maxPerRow + colIndex;
              final isActive = boxIndex < count;

              return Padding(
                padding: EdgeInsets.only(right: colIndex < maxPerRow - 1 ? spacing : 0),
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: isActive ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: isActive ? activeColor : theme.colors.dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.colors.primary : theme.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? theme.colors.primary : theme.colors.dividerColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? theme.colors.onPrimary : theme.colors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: theme.typography.bodySmall.copyWith(
                    color: isSelected ? theme.colors.onPrimary : theme.colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsOptionCard extends StatelessWidget {
  const _SettingsOptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colors.primary : theme.colors.dividerColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colors.primary : theme.colors.textPrimary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.typography.h5.copyWith(
                      color: isSelected ? theme.colors.primary : theme.colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.typography.bodySmall.copyWith(color: theme.colors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: theme.colors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class RowGeneralWidget extends StatelessWidget {
  const RowGeneralWidget({
    super.key,
    required this.text,
    required this.icon,
    this.iconColor,
    this.textColor,
  });

  final String text;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? theme.colors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: theme.typography.bodyLarge.copyWith(
                color: textColor ?? theme.colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colors.textDisabled, size: 20),
        ],
      ),
    );
  }
}
