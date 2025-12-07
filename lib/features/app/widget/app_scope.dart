import 'package:dreamscape/features/app/widget/app_widget.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:uikit/uikit.dart';

class AppScope extends StatelessWidget {
  const AppScope({
    super.key,
    required this.dependContainer,
    required this.platformDependContainer,
  });

  final DependContainer dependContainer;
  final PlatformDependContainer platformDependContainer;

  @override
  Widget build(BuildContext context) {
    return LayoutScope(
      child: DependScope(
        dependModel: dependContainer,
        platformDependContainer: platformDependContainer,
        child: AppMaterial(),
      ),
    );
  }
}
