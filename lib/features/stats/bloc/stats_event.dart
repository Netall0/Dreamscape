part of 'stats_bloc.dart';

@immutable
sealed class StatsEvent {}

final class StatsEventCreateFromTemp extends StatsEvent {}

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
  StatsEventAddStats(this.statsModel);
  final StatsModel statsModel;
}
