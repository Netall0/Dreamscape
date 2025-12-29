import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/home/repository/home_sleep_repository.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:dreamscape/features/stats/controller/stats_controller.dart';
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
    final AudioPlayer audioPlayer = await _initAudioPlayer();
    final AppDatabase appDatabase = _initAppDatabase();
    final HomeSleepRepository homeSleepRepository = _initHomeSleepRepository(
      sharedPreferences,
      appDatabase,
    );

    try {
      return DependContainer(
        statsController: StatsController(
          homeSleepRepository: homeSleepRepository,
        ),
        appDatabase: appDatabase,
        audioPlayer: audioPlayer,
        homeSleepRepository: homeSleepRepository,
      );
    } catch (e, stackTrace) {
      logger.error('Ошибка в _initDepend', error: e, stackTrace: stackTrace);
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

  HomeSleepRepository _initHomeSleepRepository(
    SharedPreferences sharedPreferences,
    AppDatabase appDatabase,
  ) {
    try {
      final homeSleepRepository = HomeSleepRepository(
        sharedPreferences: sharedPreferences,
        appDatabase: appDatabase,
      );
      return homeSleepRepository;
    } on Object catch (e, stackTrace) {
      logger.error('home sleep service', error: e, stackTrace: stackTrace);
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