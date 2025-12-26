import 'package:dreamscape/features/home/service/home_sleep_service.dart';
import 'package:just_audio/just_audio.dart';

final class DependContainer {
  final AudioPlayer audioPlayer;

  final HomeSleepService homeSleepService;

  DependContainer({required this.audioPlayer, required this.homeSleepService});
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
