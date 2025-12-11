import 'package:dreamscape/core/services/notifications/notifications_sender.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


final class DependContainer {
  DependContainer({
    required this.sharedPreferences,
    required this.notificationsSender,
  });

  final SharedPreferences sharedPreferences;
  final NotificationsSender notificationsSender;
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
