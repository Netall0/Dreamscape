import 'dart:async';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/home/model/sleep_model.dart';
import 'package:dreamscape/features/home/repository/home_sleep_repository.dart';

final class StatsController with LoggerMixin {
  final HomeSleepRepository _homeSleepRepository;
  StreamSubscription<List<SleepModel>>? _subscription;

  final _sleepModelsController = StreamController<List<SleepModel>>.broadcast();
  Stream<List<SleepModel>> get sleepModelsStream =>
      _sleepModelsController.stream;

  StatsController({required HomeSleepRepository homeSleepRepository})
    : _homeSleepRepository = homeSleepRepository {
    _init();
  }

  Future<void> _init() async {
    try {
      final sleepModels = await _homeSleepRepository.getSleepModel();
      _sleepModelsController.add(sleepModels);
    } on Object catch (e, st) {
      logger.error('Error loading initial data: $e', stackTrace: st);
      _sleepModelsController.addError(e, st);
    }

    _subscription = _homeSleepRepository.watchSleepModel().listen(
      (models) {
        _sleepModelsController.add(models);
      },
      onError: (e, st) {
        logger.error('Error watching sleep models: $e', stackTrace: st);
        _sleepModelsController.addError(e, st);
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _sleepModelsController.close();
  }
}
