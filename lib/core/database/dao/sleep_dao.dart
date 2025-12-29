import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/database/tables/sleep_tables.dart';
import 'package:drift/drift.dart';

part 'sleep_dao.g.dart';

@DriftAccessor(tables: [SleepInfoTable])
class SleepDao extends DatabaseAccessor<AppDatabase> with _$SleepDaoMixin {
  SleepDao(super.db);

  Future<List<SleepInfoTableData>> getAllSleepInfo() =>
      select(sleepInfoTable).get();

  Future<int> insertSleepInfo(SleepInfoTableCompanion entry) {
    return into(sleepInfoTable).insert(entry);
  }

  Future<bool> updateSleepInfo(SleepInfoTableCompanion entry) {
    return update(sleepInfoTable).replace(entry);
  }

  Future<int> saveSleepInfo(SleepInfoTableCompanion entry) {
    return into(sleepInfoTable).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<int> deleteSleepInfo(int id) {
    return (delete(sleepInfoTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> clearAll() {
    return delete(sleepInfoTable).go();
  }
}
