import 'package:shared_preferences/shared_preferences.dart';

import 'datasource_model.dart';
import 'i_alarm_datasourece.dart';

enum AlarmField { year, month, day, hour, minute, id }

final class AlarmDatasource implements IAlarmDataSource {

  AlarmDatasource({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;
  final SharedPreferences _sharedPreferences;

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
    for (final String key in map.values) {
      _sharedPreferences.remove(key);
    }
  }

  @override
  Future<DatasourceModel?> load() async {
    final result = <AlarmField, int>{};

    for (final MapEntry<AlarmField, String> entrie in map.entries) {
      final int? value = _sharedPreferences.getInt(entrie.value);
      if (value == null) return null;
      result[entrie.key] = value;
    }
    return DatasourceModel.fromMap(result);
  }

  @override
  Future<void> save(DatasourceModel model) async {
    for (final MapEntry<AlarmField, int> entries in model.toMap().entries) {
      final String key = map[entries.key]!;
      await _sharedPreferences.setInt(key, entries.value);
    }
  }
}
