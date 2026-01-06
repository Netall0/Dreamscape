import 'dart:io';

import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with LoggerMixin {
  @override
  void initState() {
    super.initState();
    DependScope.of(context).dependModel.avatarNotifier.loadAvatar();
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

  @override
  Widget build(BuildContext context) {
    final style = context.appTheme;
    final avatarNotifier = DependScope.of(context).dependModel.avatarNotifier;

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
                        listenable: avatarNotifier,
                        builder: (context, child) {
                          return GestureDetector(
                            onTap: avatarNotifier.isLoading
                                ? null
                                : avatarNotifier.pickAvatar,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.red,
                                  backgroundImage: _avatarProvider(
                                    avatarNotifier.localAvatar,
                                    avatarNotifier.remoteAvatarUrl,
                                  ),
                                ),
                                if (avatarNotifier.isLoading)
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
                        'date registered',
                        style: style.typography.h3,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
                  backgroundColor: ColorConstants.midnightBlue,
                  child: Column(
                    children: const [
                      SizedBox(height: 8),
                      RowGeneralWidget(text: 'name', icon: Icons.person),
                      RowGeneralWidget(text: 'email', icon: Icons.email),
                      RowGeneralWidget(text: 'password', icon: Icons.password),
                      RowGeneralWidget(text: 'phone number', icon: Icons.phone),
                      RowGeneralWidget(text: 'feedback', icon: Icons.help),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
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
