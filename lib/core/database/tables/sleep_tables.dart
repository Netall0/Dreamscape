// data/local/database/tables/sleep_info_table.dart
import 'package:drift/drift.dart';

class SleepInfoTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bedTime => integer().nullable()();
  IntColumn get riseTime => integer().nullable()();

  IntColumn get sleepDurationMinutes => integer().nullable()();
  TextColumn get sleepQuality => text().nullable()();

  TextColumn get notes => text().nullable()();

  @override
  String get tableName => 'sleep_info';
}
