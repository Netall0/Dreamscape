import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/initialization/model/depend_container.dart';
import 'package:dreamscape/features/initialization/model/platform_depend_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

// typedef OnError =
//     void Function(String message, Object error, [StackTrace? stackTrace]);
// typedef OnProgress = void Function(String name);
// typedef OnComplete = void Function(String message);



class CompositionRoot with LoggerMixin {
  final PlatformDependContainer platformDependContainer;

  CompositionRoot({required this.platformDependContainer});

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
    try {
      final sharedPreferences = await _initSharedPreference();
      logger.debug('sharedPreference init');
      logger.debug('alarmService init');
      return DependContainer(
        sharedPreferences: sharedPreferences,
      );
    } catch (e, stackTrace) {
      logger.error('Ошибка в _initDepend', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }



  Future<SharedPreferences> _initSharedPreference() async {
    try {
      logger.debug('SharedPreferences');
      return await SharedPreferences.getInstance();
    } on Object catch (e, stackTrace) {
      logger.error(
        'shared preference init error',
        error: e,
        stackTrace: stackTrace,
      );
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