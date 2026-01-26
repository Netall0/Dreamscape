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
  void dispose() {
    // _slidableController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme;
    final StatsListBloc bloc = DependScope.of(context).dependModel.statsBloc;
    final StatsCalculateNotifier statsNotifier = DependScope.of(context).dependModel.statsNotifier;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Your Sleep Sessions',
                style: theme.typography.h2.copyWith(color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),

          //stats section
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          ListenableBuilder(
            listenable: statsNotifier,
            builder: (context, _) {
              final double totalSleepHours = statsNotifier.totalSleepHours;
              final double averageSleepHours = statsNotifier.averageSleepHours;
              return SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (
                  context,
                  index,
                ) {
                  return AdaptiveCard(
                    margin: const .symmetric(horizontal: 16, vertical: 8),
                    padding: const .all(16),
                    backgroundColor: ColorConstants.midnightBlue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Total Sleep Hours: ${totalSleepHours.toStringAsFixed(1)} hrs',
                          style: theme.typography.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Average Sleep Hours: ${averageSleepHours.toStringAsFixed(1)} hrs',
                          style: theme.typography.h4,
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),

          const SliverToBoxAdapter(child: Divider()),
          // list section
          BlocConsumer(
            listener: (context, state) {
              if (state is StatsLoaded) {
                statsNotifier.setStats();
              }
            },
            bloc: bloc,

            builder: (context, state) {
              return switch (state) {
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
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Card(
                        color: ColorConstants.midnightBlue,
                        margin: const .symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Column(
                            children: [
                              model.sleepQuality.icon,
                              Text(model.sleepQuality.name),
                            ],
                          ),
                          title: Text(
                            'You slept at ${model.sleepTime.hour.toString().padLeft(2, '0')}:${model.sleepTime.minute.toString().padLeft(2, '0')}',
                            style: theme.typography.h4,
                          ),
                          subtitle: Text(
                            'You went to sleep at ${model.bedTime.hour.toString().padLeft(2, '0')}:${model.bedTime.minute.toString().padLeft(2, '0')} and woke up at ${model.riseTime.hour.toString().padLeft(2, '0')}:${model.riseTime.minute.toString().padLeft(2, '0')}',
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
                  delegate: SliverChildBuilderDelegate(childCount: 1, (
                    context,
                    index,
                  ) {
                    return AdaptiveCard(
                      margin: const .symmetric(horizontal: 16, vertical: 8),
                      padding: const .all(16),
                      backgroundColor: ColorConstants.midnightBlue,
                      child: Text('No stats found', style: theme.typography.h4),
                    );
                  }),
                ),
                StatsError(:final message) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error loading stats: $message',
                      style: theme.typography.h4,
                    ),
                  ),
                ),
                _ => const SliverFillRemaining(
                  child: Center(child: Text('Unknown state')),
                ),
              };
            },
          ),
        ],
      ),
    );
  }
}
