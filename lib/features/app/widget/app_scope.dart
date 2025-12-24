import 'package:dreamscape/features/app/widget/app_widget.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:uikit/uikit.dart';

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
        child: AppMaterial(),
  
      ),
    );
  }
}
