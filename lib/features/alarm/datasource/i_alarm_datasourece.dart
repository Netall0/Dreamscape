import 'package:dreamscape/features/alarm/datasource/datasource_model.dart';

abstract interface class IAlarmDataSource {
  Future<DatasourceModel?> load();
  Future<void> save(DatasourceModel model);
  Future<void> clear();
}
