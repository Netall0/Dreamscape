import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uikit/uikit.dart';

import '../../../core/util/extension/app_context_extension.dart';
import '../../../core/util/logger/logger.dart';
import '../../../core/l10n/app_localizations.g.dart';
import '../../initialization/widget/depend_scope.dart';
import '../controller/bloc/stats_list_bloc.dart';
import '../controller/notifier/stats_calculate_notifier.dart';
import '../model/stats_model.dart';
import 'sleep_result_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with LoggerMixin {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppTheme theme = context.appTheme;
    final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
    final StatsCalculateNotifier statsNotifier = DependScope.of(context).dependModel.statsNotifier;
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: size.width * 0.6,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                // ignore: inference_failure_on_instance_creation
                MaterialPageRoute(
                  builder: (_) => SleepResultScreen(
                    sleepHours: statsNotifier.totalSleepHours,
                    mood: l10n.goodNight,
                    description: l10n.keepSleepRhythm,
                  ),
                ),
              );
            },
            backgroundColor: theme.colors.primary,
            elevation: 0,
            child: Text(
              l10n.yourAiAssistant,
              style: theme.typography.h6.copyWith(color: theme.colors.onPrimary),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.yourSleepSessions,
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
                          l10n.totalSleep(totalSleepHours.toStringAsFixed(1)),
                          style: theme.typography.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.averageSleep(averageSleepHours.toStringAsFixed(1)),
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
              StatsLoaded() => SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final StatsModel model = state.statsModelList[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            statsNotifier.setStats();
                            logger.debug('Delete button pressed');
                            bloc.add(StatsEventDeleteById(model.id!));
                          },
                          backgroundColor: theme.colors.error,
                          foregroundColor: theme.colors.onError,
                          icon: Icons.delete,
                          label: l10n.delete,
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
                          children: [model.sleepQuality.icon, Text(model.sleepQuality.name)],
                        ),
                        title: Text(
                          l10n.sleptAt(
                            '${model.sleepTime.hour.toString().padLeft(2, '0')}:${model.sleepTime.minute.toString().padLeft(2, '0')}',
                          ),
                          style: theme.typography.h4,
                        ),
                        subtitle: Text(
                          l10n.fromTo(
                            '${model.bedTime.hour.toString().padLeft(2, '0')}:${model.bedTime.minute.toString().padLeft(2, '0')}',
                            '${model.riseTime.hour.toString().padLeft(2, '0')}:${model.riseTime.minute.toString().padLeft(2, '0')}',
                          ),
                          style: theme.typography.h6,
                        ),
                        children: [
                          ListTile(
                            subtitle: Text(model.sleepNotes, style: theme.typography.bodyMedium),
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
              StatsEmpty() => SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => AdaptiveCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: theme.colors.cardBackground,
                    border: Border.all(color: theme.colors.dividerColor),
                  child: Text(l10n.noStatsFound, style: theme.typography.h4),
                ),
              ),
            ),
            StatsError(:final message) => SliverFillRemaining(
              child: Center(
                child: Text(l10n.errorLoadingStats(message), style: theme.typography.h4),
              ),
            ),
            _ => SliverFillRemaining(child: Center(child: Text(l10n.unknownState))),
          },
        ),
      ],
    ),
  );
}
}
