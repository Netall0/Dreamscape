import 'alarm_datasource.dart';

class DatasourceModel {

  DatasourceModel({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.id,
  });
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int id;

  Map<AlarmField, int> toMap() => {
    AlarmField.year: year,
    AlarmField.month: month,
    AlarmField.day: day,
    AlarmField.hour: hour,
    AlarmField.minute: minute,
    AlarmField.id: id,
  };

  static DatasourceModel fromMap(Map<AlarmField, int> map) {
    return DatasourceModel(
      year: map[AlarmField.year]!,
      month: map[AlarmField.month]!,
      day: map[AlarmField.day]!,
      hour: map[AlarmField.hour]!,
      minute: map[AlarmField.minute]!,
      id: map[AlarmField.id]!,
    );
  }
}
