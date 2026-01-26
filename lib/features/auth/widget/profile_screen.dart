import 'dart:io';

import 'package:dreamscape/core/l10n/app_localizations.g.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/auth/widget/settings_screen.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uikit/uikit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with LoggerMixin {
  @override
  void initState() {
    DependScope.of(context).dependModel.userInfoNotifier.loadUserInfo();
    super.initState();
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

  final TextEditingController feedbackController = TextEditingController(text: '');

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> _showFeedbackDialog(BuildContext context) async {
    final theme = context.appTheme;
    final colors = theme.colors;
    final l10n = AppLocalizations.of(context)!;

    if (!mounted) return;

    String selectedCategory = 'bug';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: colors.cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.feedbackTitle, style: theme.typography.h2),
                      const SizedBox(height: 8),
                      Text(
                        l10n.feedbackSubtitle,
                        style: theme.typography.bodySmall.copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.feedbackCategory, style: theme.typography.h4),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedCategory = 'bug'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: selectedCategory == 'bug'
                                      ? colors.primary.withOpacity(0.15)
                                      : colors.surface.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedCategory == 'bug'
                                        ? colors.primary
                                        : colors.dividerColor,
                                    width: selectedCategory == 'bug' ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    l10n.feedbackCategoryBug,
                                    style: theme.typography.h5.copyWith(
                                      color: selectedCategory == 'bug'
                                          ? colors.primary
                                          : colors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedCategory = 'suggestion'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: selectedCategory == 'suggestion'
                                      ? colors.primary.withOpacity(0.15)
                                      : colors.surface.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedCategory == 'suggestion'
                                        ? colors.primary
                                        : colors.dividerColor,
                                    width: selectedCategory == 'suggestion' ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    l10n.feedbackCategorySuggestion,
                                    style: theme.typography.h5.copyWith(
                                      color: selectedCategory == 'suggestion'
                                          ? colors.primary
                                          : colors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: feedbackController,
                        maxLines: 5,
                        style: TextStyle(color: colors.textPrimary),
                        decoration: InputDecoration(
                          hintText: l10n.feedbackHint,
                          hintStyle: theme.typography.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                          filled: true,
                          fillColor: colors.surface.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colors.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colors.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colors.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              feedbackController.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.cancel, style: TextStyle(color: colors.textSecondary)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (feedbackController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.feedbackEmpty),
                                    backgroundColor: colors.error,
                                  ),
                                );
                                return;
                              }

                              final feedbackNotifier = DependScope.of(
                                context,
                              ).dependModel.feedbackNotifier;
                              final success = await feedbackNotifier.sendFeedback(
                                message: feedbackController.text.trim(),
                                category: selectedCategory,
                              );

                              if (context.mounted) {
                                Navigator.of(context).pop();
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.feedbackSent),
                                      backgroundColor: colors.primary,
                                    ),
                                  );
                                  feedbackController.clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        feedbackNotifier.errorMessage ?? 'Ошибка отправки',
                                      ),
                                      backgroundColor: colors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(l10n.feedbackSend),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showChangeNameDialog(BuildContext context) async {
    final theme = context.appTheme;
    final colors = theme.colors;
    final l10n = AppLocalizations.of(context)!;
    final userInfoNotifier = DependScope.of(context).dependModel.userInfoNotifier;

    final nameController = TextEditingController(text: userInfoNotifier.userName ?? '');

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, color: colors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.changeName, style: theme.typography.h2)),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.name,
                    hintStyle: theme.typography.bodySmall.copyWith(color: colors.textSecondary),
                    filled: true,
                    fillColor: colors.surface.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.primary, width: 2),
                    ),
                    prefixIcon: Icon(Icons.edit_outlined, color: colors.textSecondary),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        nameController.dispose();
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.cancel, style: TextStyle(color: colors.textSecondary)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.feedbackEmpty),
                              backgroundColor: colors.error,
                            ),
                          );
                          return;
                        }

                        await userInfoNotifier.setUserName(nameController.text.trim());
                        if (context.mounted) {
                          nameController.dispose();
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appTheme;
    final colors = style.colors;
    final l10n = AppLocalizations.of(context)!;
    final userInfoNotifier = DependScope.of(context).dependModel.userInfoNotifier;
    final bloc = DependScope.of(context).dependModel.authBloc;

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
                            onPressed: () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
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
                                  child:
                                      userInfoNotifier.remoteAvatarUrl == null &&
                                          userInfoNotifier.localAvatar == null
                                      ? Icon(Icons.person, size: 40, color: colors.textSecondary)
                                      : null,
                                ),
                                if (userInfoNotifier.isLoading) const CircularProgressIndicator(),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.profile, style: style.typography.h2, textAlign: TextAlign.center),
                      Text(
                        _currentUser!.createdAt.split('T').first,
                        style: style.typography.h3,
                        textAlign: TextAlign.center,
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
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showChangeNameDialog(context),
                            child: RowGeneralWidget(
                              text: userInfoNotifier.userName ?? l10n.name,
                              icon: Icons.person,
                            ),
                          ),
                          RowGeneralWidget(text: _currentUser.email ?? '', icon: Icons.email),
                          RowGeneralWidget(text: l10n.password, icon: Icons.password),
                          GestureDetector(
                            onTap: () => _showFeedbackDialog(context),
                            child: RowGeneralWidget(text: l10n.feedback, icon: Icons.help),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
                  onTap: () => bloc.add(const AuthLogoutRequested()),
                  backgroundColor: colors.cardBackground,
                  child: RowGeneralWidget(text: l10n.signOut, icon: Icons.logout_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowGeneralWidget extends StatelessWidget {
  const RowGeneralWidget({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: colors.textPrimary),
          const SizedBox(width: 24),
          Expanded(child: Text(text, style: context.appTheme.typography.h3)),
        ],
      ),
    );
  }
}
