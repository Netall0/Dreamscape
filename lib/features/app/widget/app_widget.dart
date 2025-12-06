import 'package:dreamscape/features/home/widget/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  // only one theme in app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {'/home': (context) => HomeScreen()},
      home: HomeScreen(),
      theme: ThemeData(useMaterial3: true, extensions: [AppTheme.light]),
      darkTheme: ThemeData(useMaterial3: true, extensions: [AppTheme.dark]),
      debugShowCheckedModeBanner: false,
    );
  }
}

//TODO settings feature
