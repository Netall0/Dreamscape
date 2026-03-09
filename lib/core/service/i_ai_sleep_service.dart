import '../../features/stats/model/stats_model.dart';

abstract interface class IAiSleepService {
  Future<String> analyzeSleepHistory(
    List<StatsModel> sleepHistory,  
  );

}
