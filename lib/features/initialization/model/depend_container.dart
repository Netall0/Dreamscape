import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/features/home/repository/home_sleep_repository.dart';
import 'package:just_audio/just_audio.dart';

final class DependContainer {
  final AudioPlayer audioPlayer;

  final AppDatabase appDatabase;
  final HomeSleepRepository homeSleepRepository;

  DependContainer({
    required this.audioPlayer,
    required this.appDatabase,
    required this.homeSleepRepository,
  });
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
