import 'package:dreamscape/features/alarm/datasource/datasource_model.dart';
import 'package:dreamscape/features/alarm/datasource/i_alarm_datasourece.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AlarmField { year, month, day, hour, minute, id }

final class AlarmDatasource implements IAlarmDataSource {
  final SharedPreferences _sharedPreferences;

  AlarmDatasource({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  static const Map<AlarmField, String> map = {
    AlarmField.year: 'alarm_year',
    AlarmField.month: 'alarm_month',
    AlarmField.day: 'alarm_day',
    AlarmField.hour: 'alarm_hour',
    AlarmField.minute: 'alarm_minute',
    AlarmField.id: 'alarm_id',
  };

  @override
  Future<void> clear() async {
    for (final key in map.values) {
      _sharedPreferences.remove(key);
    }
  }

  @override
  Future<DatasourceModel?> load() async {
    final result = <AlarmField, int>{};

    for (var entrie in map.entries) {
      final value = _sharedPreferences.getInt(entrie.value);
      if (value == null) return null;
      result[entrie.key] = value;
    }
    return DatasourceModel.fromMap(result);
  }

  @override
  Future<void> save(DatasourceModel model) async {
    for (final entries in model.toMap().entries) {
      final key = map[entries.key]!;
      await _sharedPreferences.setInt(key, entries.value);
    }
  }
}
