import 'package:dreamscape/core/database/dao/sleep_dao.dart';
import 'package:dreamscape/core/database/tables/sleep_tables.dart'
    show SleepInfoTable;
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DriftDatabase(tables: [SleepInfoTable], daos: [SleepDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'dreamscape.db'));

  AppDatabase.defaults({required String name})
    : super(
        driftDatabase(
          name: name,
          native: const DriftNativeOptions(shareAcrossIsolates: true),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  //TODO: Add migration logic when changing the database schema - https://drift.simonbinder.eu/migrations/

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from == 1 && to == 2) {
        await customStatement('DELETE FROM sleep_info');
      }
    },
  );
}
