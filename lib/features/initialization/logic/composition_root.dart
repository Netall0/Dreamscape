import 'package:dreamscape/core/config/app_settings_notifier.dart';
import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/repository/temp_repository.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/controller/bloc/auth_bloc.dart';
import 'package:dreamscape/features/auth/controller/notifier/feedback_notifier.dart';
import 'package:dreamscape/features/auth/controller/notifier/load_user_info_notifier.dart';
import 'package:dreamscape/features/auth/repository/auth_repository.dart';
import 'package:dreamscape/features/auth/repository/feedback_repository.dart';
import 'package:dreamscape/features/stats/controller/notifier/stats_calculate_notifier.dart';
import 'package:dreamscape/features/stats/repository/stats_repository.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_list_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// typedef OnError =
//     void Function(String message, Object error, [StackTrace? stackTrace]);
// typedef OnProgress = void Function(String name);
// typedef OnComplete = void Functioфring message);

class CompositionRoot with LoggerMixin {
  final PlatformDependContainer platformDependContainer;
  final SharedPreferences sharedPreferences;

  CompositionRoot({
    required this.platformDependContainer,
    required this.sharedPreferences,
  });

  Future<InheritedResult> compose() async {
    logger.debug('initialization start');

    final stopwatch = Stopwatch()..start();

    final depend = await _initDepend();

    stopwatch.stop();

    logger.debug('initialized depend ${stopwatch.elapsedMilliseconds}ms');

    return InheritedResult(
      ms: stopwatch.elapsedMilliseconds,
      dependModel: depend,
    );
  }

  Future<DependContainer> _initDepend() async {
    final AudioPlayer audioPlayer =
        await _initAudioPlayer(); //AudioPlayer()..setReleaseMode(ReleaseMode.STOP);
    final AppDatabase appDatabase = _initAppDatabase();
    final StatsRepository statsRepository = _initStatsRepository(
      sharedPreferences,
      appDatabase,
    );
    final AuthRepository authRepository = AuthRepository();
    final FeedbackRepository feedbackRepository = FeedbackRepository();

    final TempRepository tempRepository = _initTempRepository(
      sharedPreferences,
    );
    final StatsCalculateNotifier statsNotifier = _initStatsNotifier(
      statsRepository,
    );
    final StatsListBloc statsBloc = _initStatsBloc(statsRepository);

    final LoadInfoNotifier avatarNotifier = _initAvatarNotiifer(authRepository);

    final AuthBloc authBloc = _initAuthBloc(authRepository);

    final AppSettingsNotifier appSettingsNotifier = AppSettingsNotifier(
      sharedPreferences: sharedPreferences,
    );

    final FeedbackNotifier feedbackNotifier = _initFeedbackNotifier(feedbackRepository);

    try {
      return DependContainer(
        authBloc: authBloc,
        userInfoNotifier: avatarNotifier,
        statsNotifier: statsNotifier,
        tempRepository: tempRepository,
        statsBloc: statsBloc,
        appDatabase: appDatabase,
        audioPlayer: audioPlayer,
        appSettingsNotifier: appSettingsNotifier,
        feedbackNotifier: feedbackNotifier,
      );
    } on Object catch (e, stackTrace) {
      logger.error('Ошибка в _initDepend', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  AuthBloc _initAuthBloc(AuthRepository authRepository) {
    try {
      final authBloc = AuthBloc(authRepository: authRepository);
      return authBloc;
    } on Object catch (e, stackTrace) {
      logger.error('auth bloc', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  LoadInfoNotifier _initAvatarNotiifer(AuthRepository authRepository) {
    try {
      final avatarNotifier = LoadInfoNotifier(authRepository: authRepository);
      return avatarNotifier;
    } on Object catch (e, stackTrace) {
      logger.error('avatar notifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  StatsListBloc _initStatsBloc(StatsRepository statsRepository) {
    try {
      final statsBloc = StatsListBloc(statsRepository: statsRepository);
      return statsBloc;
    } on Object catch (e, stackTrace) {
      logger.error('stats bloc', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  StatsCalculateNotifier _initStatsNotifier(StatsRepository statsRepository) {
    try {
      final statsNotifier = StatsCalculateNotifier(
        statsRepository: statsRepository,
      );
      return statsNotifier;
    } on Object catch (e, stackTrace) {
      logger.error('stats notifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  TempRepository _initTempRepository(SharedPreferences sharedPreferences) {
    try {
      final tempRepository = TempRepository(
        sharedPreferences: sharedPreferences,
      );
      return tempRepository;
    } on Object catch (e, stackTrace) {
      logger.error('temp repository', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  AppDatabase _initAppDatabase() {
    try {
      final appDatabase = AppDatabase();
      return appDatabase;
    } on Object catch (e, stackTrace) {
      logger.error('app database', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  StatsRepository _initStatsRepository(
    SharedPreferences sharedPreferences,
    AppDatabase appDatabase,
  ) {
    try {
      final homeSleepRepository = StatsRepository(appDatabase: appDatabase);
      return homeSleepRepository;
    } on Object catch (e, stackTrace) {
      logger.error('home sleep service', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  FeedbackNotifier _initFeedbackNotifier(FeedbackRepository feedbackRepository) {
    try {
      final feedbackNotifier = FeedbackNotifier(feedbackRepository: feedbackRepository);
      return feedbackNotifier;
    } on Object catch (e, stackTrace) {
      logger.error('feedback notifier', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<AudioPlayer> _initAudioPlayer() async {
    try {
      final player = AudioPlayer();
      return player;
    } on Object catch (e, stackTrace) {
      logger.error('just audio initialized', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}





//_________________________________________________________________________________________________________
//____________________________________________________________________________________________________________
// ____________________________________________________________________________________________________________

// abstract class AsyncFactory<T> {
//   const AsyncFactory();

//   Future<T> create({
//     OnError? onError,
//     OnComplete? onComplete,
//     OnProgress? onProgress,
//   });
// }

// abstract class Factory<T> {
//   const Factory();

//   T create({OnError? onError, OnComplete? onComplete, OnProgress? onProgress});
// }


/// void main() async {
///   final root = CompositionRoot();
///   
///   final result = await root.compose(
///     onError: (msg, error, [stackTrace]) => print('Error: $msg'),
///     onProgress: (name) => print('Progress: $name'),
///     onComplete: (msg) => print('Complete: $msg'),
///   );
///   
///   print('Initialized in ${result.ms}ms');
/// }
/// 