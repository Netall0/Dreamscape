import 'package:dreamscape/features/meditation/widget/meditation_screen.dart';
import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

ValueNotifier themeSwitcher = ValueNotifier(AppTheme);

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeSwitcher,
      builder: (context, child) {
        return MaterialApp(
          home: MeditationScreen(),
          theme: ThemeData(useMaterial3: true, extensions: [AppTheme.light]),
          darkTheme: ThemeData(useMaterial3: true, extensions: [AppTheme.dark]),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

//TODO settings feature
