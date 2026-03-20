import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/uikit.dart';

import '../../../core/constants/icons.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../../../core/util/logger/logger.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/bloc/stats_list_bloc.dart';
import '../controller/notifier/stats_calculate_notifier.dart';
import '../model/stats_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with LoggerMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
      if (bloc.state is StatsInitial || bloc.state is StatsError) {
        bloc.add(StatsEventLoadStats());
      }
    });

    logger.debug('init_state');
  }

  Future<void> _addStats() async {
    context.push('/add-from-health-device');
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
    final StatsCalculateNotifier statsNotifier = DependScope.of(context).dependModel.statsNotifier;
    String sleepQualityLabel(SleepQuality quality) => switch (quality) {
      SleepQuality.bad => context.l10n.sleepQualityBad,
      SleepQuality.normal => context.l10n.sleepQualityNormal,
      SleepQuality.good => context.l10n.sleepQualityGood,
    };

    return Scaffold(
      floatingActionButtonLocation: .centerDocked,
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton.extended(
          backgroundColor: theme.colors.primary,
          onPressed: () async {
            var list = <StatsModel>[];

            final StatsState currentState = bloc.state;
            if (currentState is StatsLoaded) {
              list = currentState.statsModelList;
            } else {
              bloc.add(StatsEventLoadStats());
              final StatsState nextState = await bloc.stream.firstWhere(
                (s) => s is StatsLoaded || s is StatsEmpty || s is StatsError,
              );
              if (!context.mounted) {
                return;
              }
              if (nextState is StatsLoaded) {
                list = nextState.statsModelList;
              } else if (nextState is StatsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${context.l10n.statsErrorLoadingLabel}: ${nextState.message}'),
                  ),
                );
                return;
              }
            }

            context.push('/stats/analyze-stats', extra: list);
            logger.info('${list.length} stats sent to AI');
          },
          label: Row(
            children: [
              Icon(AppIcons.ai, color: theme.colors.onPrimary),
              const SizedBox(width: 12),
              Text(
                context.l10n.statsReviewFromAi,
                style: theme.typography.h5.copyWith(color: theme.colors.onPrimary),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: _addStats,
                icon: const Icon(Icons.add),
                tooltip: context.l10n.statsAddFromHealthTooltip,
              ),
            ],
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                context.l10n.statsSleepSessionsTitle,
                style: theme.typography.h2.copyWith(color: theme.colors.textPrimary),
              ),
              centerTitle: true,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ListenableBuilder(
            listenable: statsNotifier,
            builder: (context, _) {
              final double totalSleepHours = statsNotifier.totalSleepHours;
              final double averageSleepHours = statsNotifier.averageSleepHours;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => AdaptiveCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: theme.colors.cardBackground,
                    border: Border.all(color: theme.colors.dividerColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.l10n.statsTotalSleepLabel} '
                          '${totalSleepHours.toStringAsFixed(1)} '
                          '${context.l10n.statsHoursShort}',
                          style: theme.typography.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${context.l10n.statsAverageSleepLabel} '
                          '${averageSleepHours.toStringAsFixed(1)} '
                          '${context.l10n.statsHoursShort}',
                          style: theme.typography.h4,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: Divider(color: theme.colors.dividerColor, height: 24)),
          BlocConsumer<StatsListBloc, StatsState>(
            listener: (context, state) {
              if (state is StatsLoaded) {
                statsNotifier.setStats();
              }
            },
            bloc: bloc,
            builder: (context, state) => switch (state) {
              StatsLoaded() when state.statsModelList.isEmpty => SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => AdaptiveCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: theme.colors.cardBackground,
                    border: Border.all(color: theme.colors.dividerColor),
                    child: Text(context.l10n.statsNoStatsFound, style: theme.typography.h4),
                  ),
                ),
              ),
              StatsLoaded() => SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final StatsModel model = state.statsModelList[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          //TODO: Dssmissible
                          onPressed: (_) {
                            statsNotifier.setStats();
                            logger.debug('Delete button pressed');
                            bloc.add(StatsEventDeleteById(model.id!));
                          },
                          backgroundColor: theme.colors.error,
                          foregroundColor: theme.colors.onError,
                          icon: Icons.delete,
                          label: context.l10n.statsDelete,
                        ),
                      ],
                    ),
                    child: Card(
                      color: theme.colors.cardBackground,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.colors.dividerColor),
                      ),
                      child: ExpansionTile(
                        leading: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            model.sleepQuality.icon,
                            Text(sleepQualityLabel(model.sleepQuality)),
                          ],
                        ),
                        title: Text(
                          '${context.l10n.statsSleptAtLabel} '
                          '${model.sleepTime.hour.toString().padLeft(2, '0')}:'
                          '${model.sleepTime.minute.toString().padLeft(2, '0')}',
                          style: theme.typography.h4,
                        ),
                        subtitle: Text(
                          '${context.l10n.statsFromLabel} '
                          '${model.bedTime.hour.toString().padLeft(2, '0')}:'
                          '${model.bedTime.minute.toString().padLeft(2, '0')} '
                          '${context.l10n.statsToLabel} '
                          '${model.riseTime.hour.toString().padLeft(2, '0')}:'
                          '${model.riseTime.minute.toString().padLeft(2, '0')}',
                          style: theme.typography.h6,
                        ),
                        children: [
                          if (model.sleepNotes.isNotEmpty)
                            Padding(
                              padding: const .all(16),
                              child: Text(
                                '${context.l10n.statsNotesLabel}: ${model.sleepNotes}',
                                style: theme.typography.h4,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }, childCount: state.statsModelList.length),
              ),
              StatsInitial() => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              StatsLoading() => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              StatsEmpty() => SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => AdaptiveCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: theme.colors.cardBackground,
                    border: Border.all(color: theme.colors.dividerColor),
                    child: Text(context.l10n.statsNoStatsFound, style: theme.typography.h4),
                  ),
                ),
              ),
              StatsError(:final message) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    '${context.l10n.statsErrorLoadingLabel}: $message',
                    style: theme.typography.h4,
                  ),
                ),
              ),
              // ignore: unreachable_switch_case
              _ => SliverFillRemaining(child: Center(child: Text(context.l10n.statsUnknownState))),
            },
          ),
        ],
      ),
    );
  }
}
