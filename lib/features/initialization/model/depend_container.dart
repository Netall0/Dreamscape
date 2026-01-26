import 'package:just_audio/just_audio.dart';

import '../../../core/database/database.dart';
import '../../../core/repository/temp_repository.dart';
import '../../auth/controller/bloc/auth_bloc.dart';
import '../../auth/controller/notifier/load_user_info_notifier.dart';
import '../../stats/controller/bloc/stats_list_bloc.dart';
import '../../stats/controller/notifier/stats_calculate_notifier.dart';

final class DependContainer {

  DependContainer({
    required this.authBloc,
    required this.userInfoNotifier,
    required this.statsNotifier,
    required this.statsBloc,
    required this.audioPlayer,
    required this.appDatabase,
    required this.tempRepository,
  });
  final AudioPlayer audioPlayer;

  final AppDatabase appDatabase;
  final StatsListBloc statsBloc;
  final TempRepository tempRepository;
  final StatsCalculateNotifier statsNotifier;
  final LoadInfoNotifier userInfoNotifier;
  final AuthBloc authBloc;
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
