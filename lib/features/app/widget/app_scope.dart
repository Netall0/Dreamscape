import 'package:flutter/widgets.dart';
import 'package:uikit/uikit.dart';

import '../../initialization/model/depend_container.dart';
import '../../initialization/model/platform_depend_container.dart';
import '../../initialization/widget/depend_scope.dart';
import 'app_widget.dart';

class AppScope extends StatefulWidget {
  const AppScope({
    super.key,
    required this.dependContainer,
    required this.platformDependContainer,
  });

  final DependContainer dependContainer;
  final PlatformDependContainer platformDependContainer;

  @override
  State<AppScope> createState() => _AppScopeState();
}

class _AppScopeState extends State<AppScope> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
/*************  ✨ Windsurf Command ⭐  *************/
/*******  64e4690f-538e-4635-b938-8d9caf8fea2b  *******/
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.platformDependContainer.clockNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScope(
      child: DependScope(
        dependModel: widget.dependContainer,
        platformDependContainer: widget.platformDependContainer,
        child: const AppMaterial(),
  
      ),
    );
  }
}
