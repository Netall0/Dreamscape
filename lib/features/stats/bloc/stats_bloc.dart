import 'package:bloc/bloc.dart';
import 'package:dreamscape/features/stats/app/build_stats_from_temp.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:meta/meta.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final BuildStatsFromTemp _buildStatsFromTemp;
  StatsBloc({required BuildStatsFromTemp buildStatsFromTemp})
    : _buildStatsFromTemp = buildStatsFromTemp,

      super(StatsInitial()) {
    on<StatsEvent>((event, emit) {
      // return switch (event) {
      //   StatsEventCreateFromTemp() => _onCreateFromTemp(event, emit),
      //   StatsEventClearAll() => _onClearAll(event, emit),
      //   StatsEventDeleteById() => _onDeleteById(event, emit),
      //   StatsEventUpdateStats() => _onUpdateStats(event, emit),
      //   StatsEventAddStats() => _onAddStats(event, emit),
      // };
    });
  }
}
