import '../../stats/model/stats_model.dart';

abstract interface class IHomeSleepRepository {
  //stats methods

  // Fetches all sleep models from the database.
  Future<void> addSleepModel(StatsModel sleepModel);
  Future<void> deleteSleepModel(StatsModel sleepModel);
  Future<void> clearAll();
  Stream<List<StatsModel>> watchSleepModel();

  /// Creates a new SleepModel based on temporary data.

  Future<StatsModel?> createSleepModelFromTemp({
    required SleepQuality quality,
    String notes = '',
  });
}
