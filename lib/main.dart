
import 'package:dreamscape/common/config/app_config.dart';
import 'package:flutter/cupertino.dart';

import 'package:dreamscape/pages/my_home_page.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyHomePage(flavorVersion: AppEnv.dev.toString()));
}

