part of 'stats_list_bloc.dart';

sealed class StatsEvent {}

final class StatsEventLoadStats extends StatsEvent {}

final class StatsEventClearAll extends StatsEvent {}

final class StatsEventDeleteById extends StatsEvent {
  StatsEventDeleteById(this.id);
  final int id;
}

final class StatsEventUpdateStats extends StatsEvent {
  StatsEventUpdateStats(this.statsModel);
  final StatsModel statsModel;
}

final class StatsEventAddStats extends StatsEvent {
  StatsEventAddStats({required this.statsModel});
  final StatsModel statsModel;
}
