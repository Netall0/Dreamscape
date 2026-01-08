import 'dart:io';

import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      return ResizeImage(
        NetworkImage(remoteAvatarUrl),
        width: 200,
        height: 200,
      );
    }

    return null;
  }

  final User? _currentUser = Supabase.instance.client.auth.currentUser;

  final TextEditingController emailController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final style = context.appTheme;
    final userInfoNotifier = DependScope.of(
      context,
    ).dependModel.userInfoNotifier;
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
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  backgroundColor: ColorConstants.midnightBlue,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.settings, color: Colors.white),
                        ],
                      ),
                      ListenableBuilder(
                        listenable: userInfoNotifier,
                        builder: (context, child) {
                          return GestureDetector(
                            onTap: userInfoNotifier.isLoading
                                ? null
                                : userInfoNotifier.pickAvatar,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.red,
                                  backgroundImage: _avatarProvider(
                                    userInfoNotifier.localAvatar,
                                    userInfoNotifier.remoteAvatarUrl,
                                  ),
                                ),
                                if (userInfoNotifier.isLoading)
                                  const CircularProgressIndicator(),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'profile',
                        style: style.typography.h2,
                        textAlign: TextAlign.center,
                      ),
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
                      backgroundColor: ColorConstants.midnightBlue,
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              if (mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('change name'),
                                      content: TextField(
                                        controller: emailController,
                                      ),

                                      actions: [
                                        TextButton(
                                          child: const Text('cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        TextButton(
                                          child: const Text('save'),
                                          onPressed: () async {
                                            await userInfoNotifier.setUserName(
                                              emailController.text,
                                            );
                                            if (context.mounted) {
                                              context.pop();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: RowGeneralWidget(
                              text: userInfoNotifier.userName ?? 'name',
                              icon: Icons.person,
                            ),
                          ),
                          RowGeneralWidget(
                            text: _currentUser.email ?? '',
                            icon: Icons.email,
                          ),
                          RowGeneralWidget(
                            text: 'password',
                            icon: Icons.password,
                          ),
                          RowGeneralWidget(
                            text:
                                (_currentUser.phone == null ||
                                    _currentUser.phone!.trim().isEmpty)
                                ? 'undefined'
                                : _currentUser.phone ?? '',
                            icon: Icons.phone,
                          ),
                          RowGeneralWidget(text: 'feedback', icon: Icons.help),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
                  onTap: () => bloc.add(const AuthLogoutRequested()),

                  backgroundColor: ColorConstants.midnightBlue,
                  child: const RowGeneralWidget(
                    text: 'sign out',
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 24),
          Text(text, style: context.appTheme.typography.h3),
        ],
      ),
    );
  }
}
