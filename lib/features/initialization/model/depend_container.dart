import 'package:dreamscape/core/config/app_settings_notifier.dart';
import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/repository/temp_repository.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/auth/controller/notifier/load_user_info_notifier.dart';
import 'package:dreamscape/features/stats/controller/notifier/stats_calculate_notifier.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_list_bloc.dart';
import 'package:just_audio/just_audio.dart';

final class DependContainer {
  final AudioPlayer audioPlayer;

  final AppDatabase appDatabase;
  final StatsListBloc statsBloc;
  final TempRepository tempRepository;
  final StatsCalculateNotifier statsNotifier;
  final LoadInfoNotifier userInfoNotifier;
  final AuthBloc authBloc;
  final AppSettingsNotifier appSettingsNotifier;

  DependContainer({
    required this.authBloc,
    required this.userInfoNotifier,
    required this.statsNotifier,
    required this.statsBloc,
    required this.audioPlayer,
    required this.appDatabase,
    required this.tempRepository,
    required this.appSettingsNotifier,
  });
}

final class InheritedResult {
  InheritedResult({required this.dependModel, required this.ms});
  final DependContainer dependModel;

  final int ms;
}
