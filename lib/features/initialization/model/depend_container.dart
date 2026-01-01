import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/repository/temp_repository.dart';
import 'package:dreamscape/features/stats/repository/stats_repository.dart';
import 'package:dreamscape/features/stats/bloc/stats_bloc.dart';
import 'package:just_audio/just_audio.dart';

final class DependContainer {
  final AudioPlayer audioPlayer;

  final AppDatabase appDatabase;
  final StatsRepository statsRepository;
  final StatsBloc statsBloc;
  final TempRepository tempRepository;

  DependContainer({
    required this.statsBloc,
    required this.audioPlayer,
    required this.appDatabase,
    required this.statsRepository,
    required this.tempRepository,
  });
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
