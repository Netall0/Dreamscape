import 'package:shared_preferences/shared_preferences.dart';

final class DependContainer {
  DependContainer({required this.sharedPreferences});



final SharedPreferences sharedPreferences;}



final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
