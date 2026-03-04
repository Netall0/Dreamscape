import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/sleep_tables.dart';

part 'sleep_dao.g.dart';

@DriftAccessor(tables: [SleepInfoTable])
class SleepDao extends DatabaseAccessor<AppDatabase> with _$SleepDaoMixin {
  SleepDao(super.db);

  Future<List<SleepInfoTableData>> getAllSleepInfo() => select(sleepInfoTable).get();

  Future<SleepInfoTableData?> getSleepInfoByDate(DateTime date) {
    final int dateInMillis = date.millisecondsSinceEpoch;
    return (select(
      sleepInfoTable,
    )..where((tbl) => tbl.sleepData.equals(dateInMillis))).getSingleOrNull();
  }

  Future<int> insertSleepInfo(SleepInfoTableCompanion entry) => into(sleepInfoTable).insert(entry);

  Future<bool> updateSleepInfo(SleepInfoTableCompanion entry) =>
      update(sleepInfoTable).replace(entry);

  Future<int> saveSleepInfo(SleepInfoTableCompanion entry) =>
      into(sleepInfoTable).insert(entry, mode: InsertMode.insertOrReplace);

  Future<int> deleteSleepInfo(int id) =>
      (delete(sleepInfoTable)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> clearAll() => delete(sleepInfoTable).go();

  Stream<List<SleepInfoTableData>> watchAllSleepInfo() => select(sleepInfoTable).watch();
}
