import 'datasource_model.dart';

abstract interface class IAlarmDataSource {
  Future<DatasourceModel?> load();
  Future<void> save(DatasourceModel model);
  Future<void> clear();
}
