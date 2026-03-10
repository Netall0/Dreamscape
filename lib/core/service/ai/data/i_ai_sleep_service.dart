import '../../../../features/stats/model/stats_model.dart';

abstract interface class IAiSleepService {

  Stream<String> analyzeSleepHistoryStream(
    List<StatsModel> sleepHistory,
  );


  Future<String> analyzeSleepHistory(
    List<StatsModel> sleepHistory,  
  );

}
