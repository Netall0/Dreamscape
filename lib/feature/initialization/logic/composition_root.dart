import 'package:dreamscape/core/util/logger.dart';
import 'package:dreamscape/core/util/timer.dart';
import 'package:dreamscape/feature/initialization/model/depend_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

// typedef OnError =
//     void Function(String message, Object error, [StackTrace? stackTrace]);
// typedef OnProgress = void Function(String name);
// typedef OnComplete = void Function(String message);

final class InheritedResult {
  final int ms;
  final DependContainer dependModel;

  const InheritedResult({required this.ms, required this.dependModel});
}

class CompositionRoot with LoggerMixin, AppTimerMixin {
  Future<InheritedResult> compose() async {
    logOnProgress('Старт инициализации');

    final stopwatch = Stopwatch()..start();

    final depend = await _initDepend();

    stopwatch.stop();

    logOnComplete('Dependencies');

    return InheritedResult(
      ms: stopwatch.elapsedMilliseconds,
      dependModel: depend,
    );
  }

  Future<DependContainer> _initDepend() async {
    try {
      logOnProgress('SharedPreferences');
      final sharedPreferences = await _initSharedPreference();
      return DependContainer(sharedPreferences: sharedPreferences);
    } catch (e, stackTrace) {
      logError('Ошибка в _initDepend', e, stackTrace);
      rethrow;
    }
  }

  Future<SharedPreferences> _initSharedPreference() async {
    try {
      return await SharedPreferences.getInstance();
    } on Object catch (e, st) {
      logError('SharedPreferences.getInstance() failed', e, st);
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