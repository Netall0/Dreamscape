// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_theme.dart';

import '../../../core/util/extension/app_context_extension.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final Size size = context.sizeOf;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text('Settings', style: theme.typography.h1),
          ),

          SliverToBoxAdapter(child: SizedBox(height: size.height * 0.1)),

          // theme changer ui
          SliverPadding(
            padding: const .symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * 0.3,
                width: size.width,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: .circular(12),
                    border: .all(color: Colors.white.withOpacity(0.12)),
                    color: Colors.black.withOpacity(0.22),
                  ),
                  child: Padding(
                    padding: const .all(16),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text('Theme Changer', style: theme.typography.h3),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: .spaceEvenly,
                            children: [
                              ChoiseWidget(size: size),
                              ChoiseWidget(size: size),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//TODO learn adaptive ui, make something good

class ChoiseWidget extends StatefulWidget {
  const ChoiseWidget({super.key, required this.size});

  final Size size;

  @override
  State<ChoiseWidget> createState() => _ChoiseWidgetState();
}

class _ChoiseWidgetState extends State<ChoiseWidget> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16),
      child: GestureDetector(
        onTap: () => setState(() => tapped = !tapped),
        child: SizedBox(
          height: widget.size.height * 0.1,
          width: widget.size.width * 0.2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              border: .all(color: tapped ? Colors.white : Colors.white.withOpacity(0.12)),
              color: Colors.black.withOpacity(0.22),
            ),
          ),
        ),
      ),
    );
  }
}
