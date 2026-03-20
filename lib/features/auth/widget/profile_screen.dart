import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uikit/uikit.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../../../core/router/router.dart';
import '../../../core/service/feedback/data/feeedback_repository.dart';
import '../../../core/service/feedback/feedback_model.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../../../core/util/logger/logger.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/bloc/auth_bloc.dart';
import '../controller/notifier/load_user_info_notifier.dart';

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

  final TextEditingController emailController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final AppTheme style = context.appTheme;
    final LoadInfoNotifier userInfoNotifier = DependScope.of(context).dependModel.userInfoNotifier;
    final AuthBloc bloc = DependScope.of(context).dependModel.authBloc;
    MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListenableBuilder(
                  listenable: userInfoNotifier,
                  builder: (context, child) => GestureDetector(
                    onTap: userInfoNotifier.isLoading ? null : userInfoNotifier.pickAvatar,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: style.colors.surface,
                          backgroundImage: _avatarProvider(
                            userInfoNotifier.localAvatar,
                            userInfoNotifier.remoteAvatarUrl,
                          ),
                        ),
                        if (userInfoNotifier.isLoading) const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.profileTitle,
                  style: style.typography.h2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  _currentUser!.createdAt.split('T').first,
                  style: style.typography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ListenableBuilder(
                  listenable: userInfoNotifier,
                  builder: (context, child) => AdaptiveCard(
                    backgroundColor: style.colors.cardBackground,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            context.push(
                              '/edit-name',
                              extra: EditNameExtras(
                                voidCallback: () => context.pop(),
                                userInfoNotifier: userInfoNotifier,
                                emailController: emailController,
                              ),
                            );
                          },
                          child: RowGeneralWidget(
                            text: userInfoNotifier.userName ?? context.l10n.profileNamePlaceholder,
                            icon: Icons.person,
                          ),
                        ),
                        RowGeneralWidget(text: _currentUser.email ?? '', icon: Icons.email),
                        RowGeneralWidget(
                          text: context.l10n.profilePasswordLabel,
                          icon: Icons.password,
                        ),
                        RowGeneralWidget(
                          text: (_currentUser.phone == null || _currentUser.phone!.trim().isEmpty)
                              ? context.l10n.profileUndefined
                              : _currentUser.phone ?? '',
                          icon: Icons.phone,
                        ),
                        InkWell(
                          onTap: () async {
                            // await showDialog(context: context, builder: builder)
                            FeeedbackRepository().sendFeedback(
                              FeedbackModel(
                                id: const Uuid().v4(),
                                name: 'alex',
                                email: 'gromovd139@gmail.com,',
                                message: 'не работает это позор братуха полный ахахахахахах',
                              ),
                            );
                          },
                          child: RowGeneralWidget(
                            text: context.l10n.profileFeedback,
                            icon: Icons.help,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
                  onTap: () => bloc.add(const AuthLogoutRequested()),

                  backgroundColor: style.colors.cardBackground,
                  child: RowGeneralWidget(
                    text: context.l10n.profileSignOut,
                    icon: Icons.logout_outlined,
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

class RowGeneralWidget extends StatelessWidget {
  const RowGeneralWidget({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Icon(icon, color: context.appTheme.colors.textPrimary),
        const SizedBox(width: 24),
        Expanded(child: Text(text, style: context.appTheme.typography.h3)),
      ],
    ),
  );
}
