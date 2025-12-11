import 'package:dreamscape/core/services/alarm/model/alarm_model.dart';

abstract interface class IAlarmService {
  Future<void> setAlarm(AlarmModel model);
  Future<void> cancelAlarm(
    int id
  );
  
}
