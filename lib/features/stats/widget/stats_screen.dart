import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uikit/uikit.dart';

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
      _addStats();
    });

    logger.debug('init_state');
  }

  Future<void> _addStats() => showDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: const Text('Add Stats'),
      content: const Text('Do you want to add stats from Health?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('No')),
        ElevatedButton(
          onPressed: () {
            DependScope.of(context).dependModel.statsBloc.add(StatsEventAddFromHealth());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('')));
            Navigator.of(context).pop();
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
    final StatsCalculateNotifier statsNotifier = DependScope.of(context).dependModel.statsNotifier;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Your Sleep Sessions',
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
                          'Total Sleep: ${totalSleepHours.toStringAsFixed(1)} hrs',
                          style: theme.typography.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Average Sleep: ${averageSleepHours.toStringAsFixed(1)} hrs',
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
                          label: 'Delete',
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
                      child: ListTile(
                        leading: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [model.sleepQuality.icon, Text(model.sleepQuality.name)],
                        ),
                        title: Text(
                          'Slept at ${model.sleepTime.hour.toString().padLeft(2, '0')}:${model.sleepTime.minute.toString().padLeft(2, '0')}',
                          style: theme.typography.h4,
                        ),
                        subtitle: Text(
                          'From ${model.bedTime.hour.toString().padLeft(2, '0')}:${model.bedTime.minute.toString().padLeft(2, '0')} to ${model.riseTime.hour.toString().padLeft(2, '0')}:${model.riseTime.minute.toString().padLeft(2, '0')}',
                          style: theme.typography.h6,
                        ),
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
                    child: Text('No stats found', style: theme.typography.h4),
                  ),
                ),
              ),
              StatsError(:final message) => SliverFillRemaining(
                child: Center(
                  child: Text('Error loading stats: $message', style: theme.typography.h4),
                ),
              ),
              _ => const SliverFillRemaining(child: Center(child: Text('Unknown state'))),
            },
          ),
        ],
      ),
    );
  }
}
