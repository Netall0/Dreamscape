import 'package:dreamscape/features/app/widget/app_widget.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:flutter/widgets.dart';

class AppScope extends StatelessWidget {
  const AppScope({super.key, required this.dependContainer});

  final DependContainer dependContainer;

  @override
  Widget build(BuildContext context) {
    return DependScope(
      dependModel: dependContainer, child: App(),
    );
  }
}