import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:dreamscape/features/stats/repository/stats_repository.dart';

part 'stats_list_event.dart';
part 'stats_list_state.dart';

class StatsListBloc extends Bloc<StatsEvent, StatsState> with LoggerMixin {
  final StatsRepository _statsRepository;
  StatsListBloc({required StatsRepository statsRepository})
    : _statsRepository = statsRepository,
      super(StatsInitial()) {
    on<StatsEvent>(
      (event, emit) => switch (event) {
        StatsEventLoadStats() => _onLoadStats(event, emit),
        StatsEventAddStats() => _onAddStats(event, emit),
        StatsEventClearAll() => _onClearAll(event, emit),
        StatsEventDeleteById() => _onDeleteById(event, emit),
        _ => null,
      },
      // transformer:
    );
  }

  Future<void> _onDeleteById(
    StatsEventDeleteById event,
    Emitter<StatsState> emit,
  ) async {
    try {
      await _statsRepository.deleteSleepModel(event.id);
      logger.debug('StatsModel deleted with id: ${event.id}');
      final list = await _statsRepository.getSleepModel();
      if (list.isEmpty) {
        emit(StatsEmpty());
      } else {
        emit(StatsLoaded(list));
      }
    } on Object catch (e, st) {
      emit(StatsError(e.toString()));
      logger.error('Error in _onDeleteById: $e', stackTrace: st);
    }
  }

  Future<void> _onClearAll(
    StatsEventClearAll event,
    Emitter<StatsState> emit,
  ) async {
    try {
      await _statsRepository.clearAll();
      logger.debug('All stats cleared');
      emit(StatsEmpty());
    } on Object catch (e, st) {
      emit(StatsError(e.toString()));
      logger.error('Error in _onClearAll: $e', stackTrace: st);
    }
  }

  Future<void> _onAddStats(
    StatsEventAddStats event,
    Emitter<StatsState> emit,
  ) async {
    try {
      await _statsRepository.addSleepModel(event.statsModel);
      logger.debug('StatsModel added: ${event.statsModel}');
      emit(StatsLoaded(await _statsRepository.getSleepModel()));
    } on Object catch (e, st) {
      emit(StatsError(e.toString()));
      logger.error('Error in _onAddStats: $e', stackTrace: st);
    }
  }

  Future<void> _onLoadStats(
    StatsEventLoadStats event,
    Emitter<StatsState> emit,
  ) async {
    emit(StatsLoading());
    try {
      final statsModelList = await _statsRepository.getSleepModel();
      if (statsModelList.isEmpty) {
        emit(StatsEmpty());
      } else {
        emit(StatsLoaded(statsModelList));
      }
    } on Object catch (e, st) {
      emit(StatsError(e.toString()));
      logger.error('Error in _onLoadStats: $e', stackTrace: st);
    }
  }

  // Future<void> _onCreateFromTemp(
  //   StatsEventCreateFromTemp event,
  //   Emitter<StatsState> emit,
  // ) async {
  //   emit(StatsLoading());
  //   try {
  //     await _buildStatsFromTemp.statsRepo.
  //   } on Object catch (e, st) {
  //     emit(StatsError(e.toString()));
  //     logger.error('Error in _onCreateFromTemp: $e', stackTrace: st);
  //   }
  // }
}
