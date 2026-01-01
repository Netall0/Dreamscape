import 'package:dreamscape/core/repository/i_temp_repository.dart';
import 'package:dreamscape/core/util/extension/time_of_day_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:dreamscape/features/stats/repository/i_stats_repository.dart';

class BuildStatsFromTemp with LoggerMixin {
  final ITempRepository tempRepo;
  final IStatsRepository statsRepo;

  BuildStatsFromTemp(this.tempRepo, this.statsRepo);

  @override
  Future<StatsModel?> createSleepModelFromTemp({
    SleepQuality quality = SleepQuality.normal,
    String notes = '',
  }) async {
    try {
      final bedTime = await tempRepo.getBedTime();
      final riseTime = await tempRepo.getRiseTime();

      if (bedTime == null || riseTime == null) {
        logger.error('Cannot create sleep model: missing bed or rise time');
        return null;
      }

      final sleepTime = bedTime.calculationSleepTime(riseTime);

      final sleepModel = StatsModel(
        bedTime: bedTime,
        riseTime: riseTime,
        sleepTime: sleepTime,
        sleepQuality: quality,
        sleepNotes: notes,
      );

      await statsRepo.addSleepModel(sleepModel);

      await tempRepo.clearTempData();

      logger.info('Sleep model created from temp data successfully');

      return sleepModel;
    } on Object catch (e, st) {
      logger.error(
        'Error creating sleep model from temp data: $e',
        stackTrace: st,
      );
      rethrow;
    }
  }
}
