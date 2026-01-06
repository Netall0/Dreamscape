part of 'stats_list_bloc.dart';

sealed class StatsState {}

final class StatsInitial extends StatsState {}

final class StatsLoaded extends StatsState {
  StatsLoaded(this.statsModelList);
  final List<StatsModel> statsModelList;
}

final class StatsError extends StatsState {
  StatsError(this.message);
  final String message;
}

final class StatsLoading extends StatsState {}

final class StatsEmpty extends StatsState {}
