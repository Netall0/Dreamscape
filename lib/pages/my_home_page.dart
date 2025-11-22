import 'dart:developer';

import 'package:dreamscape/common/gen/assets.gen.dart';
import 'package:dreamscape/common/gen/fonts.gen.dart';
import 'package:dreamscape/constants/icons.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.flavorVersion});

  final String flavorVersion;

  @override
  Widget build(BuildContext context) {
                  print("${AppAssets.images.test.toString()}");
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(AppIcons.upload, size: 100),
              AppAssets.images.test.image(),

            ],
          ),
        ),
      ),
    );
  }
}
