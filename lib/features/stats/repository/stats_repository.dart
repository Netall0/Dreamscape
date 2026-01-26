import '../../../core/database/database.dart';
import '../../../core/util/logger/logger.dart';
import '../model/stats_model.dart';
import 'i_stats_repository.dart';

final class StatsRepository with LoggerMixin implements IStatsRepository {

  StatsRepository({required AppDatabase appDatabase})
    : _appDatabase = appDatabase;
  final AppDatabase _appDatabase;

  //stats methods


  @override
  Future<double> getTotalSleepHours() async {
    try {
      final List<SleepInfoTableData> allModels = await _appDatabase.sleepDao.getAllSleepInfo();

      if (allModels.isEmpty) return 0.0;

      var total = 0.0;
      for (final model in allModels) {
        final sleepModel = StatsModel.fromDriftRow(model);
        final double hours =
            sleepModel.sleepTime.hour + (sleepModel.sleepTime.minute / 60.0);
        total += hours;
      }

      logger.info('Total sleep hours calculated: $total');
      return total;
    } on Object catch (e, st) {
      logger.error('Error calculating total sleep hours: $e', stackTrace: st);
      return 0.0;
    }
  }

  @override
  Future<double> getAverageSleepHours() async {
    try {
      final List<SleepInfoTableData> allModels = await _appDatabase.sleepDao.getAllSleepInfo();

      if (allModels.isEmpty) return 0.0;

      var total = 0.0;
      for (final model in allModels) {
        final sleepModel = StatsModel.fromDriftRow(model);
        final double hours =
            sleepModel.sleepTime.hour + (sleepModel.sleepTime.minute / 60.0);
        total += hours;
      }

      final double average = total / allModels.length;
      logger.info('Average sleep hours calculated: $average');
      return average;
    } on Object catch (e, st) {
      logger.error('Error calculating average sleep hours: $e', stackTrace: st);
      return 0.0;
    }
  }

  @override
  Future<List<StatsModel>> getSleepModel() async {
    try {
      final List<SleepInfoTableData> listSleepModels = await _appDatabase.sleepDao.getAllSleepInfo();
      logger.debug('Fetched ${listSleepModels.length} sleep models');
      return listSleepModels.map((e) => StatsModel.fromDriftRow(e)).toList();
    } on Object catch (e, st) {
      logger.error('Error getting sleep models: $e', stackTrace: st);
      return [];
    }
  }

  @override
  Future<void> addSleepModel(StatsModel sleepModel) async {
    try {
      if (sleepModel.id == null) {
        await _appDatabase.sleepDao.insertSleepInfo(
          sleepModel.toSleepInfoTableCompanion(sleepModel),
        );
      } else {
        await _updateSleepModel(sleepModel);
      }

      logger.info('Sleep model added successfully');
    } on Object catch (e, st) {
      logger.error('Error adding sleep model: $e', stackTrace: st);
    }
  }

  Future<void> _updateSleepModel(StatsModel sleepModel) async {
    try {
      await _appDatabase.sleepDao.updateSleepInfo(
        sleepModel.toSleepInfoTableCompanion(sleepModel),
      );
      logger.info('Sleep model updated successfully');
    } on Object catch (e, st) {
      logger.error('Error updating sleep model: $e', stackTrace: st);
    }
  }

  @override
  Future<void> deleteSleepModel(int id) async {
    try {
      await _appDatabase.sleepDao.deleteSleepInfo(id);
      logger.info('Sleep model deleted successfully');
    } on Object catch (e, st) {
      logger.error('Error deleting sleep model: $e', stackTrace: st);
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _appDatabase.sleepDao.clearAll();
      logger.info('All sleep models cleared successfully');
    } on Object catch (e, st) {
      logger.error('Error clearing all sleep models: $e', stackTrace: st);
    }
  }
}
