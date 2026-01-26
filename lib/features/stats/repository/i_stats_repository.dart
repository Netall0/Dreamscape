import '../model/stats_model.dart';

abstract interface class IStatsRepository {
  //stats methods
  Future<double> getTotalSleepHours();
  Future<double> getAverageSleepHours();

  // Fetches all sleep models from the database.
  Future<List<StatsModel>> getSleepModel();
  Future<void> addSleepModel(StatsModel sleepModel);
  Future<void> deleteSleepModel(int id);
  Future<void> clearAll();

  /// Creates a new SleepModel based on temporary data.
}
