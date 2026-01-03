import 'package:dreamscape/core/database/database.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_bloc.dart';
import 'package:dreamscape/features/stats/repository/stats_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/uikit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    final theme = context.appTheme;
    final bloc = DependScope.of(context).dependModel.statsBloc;
    final statsNotifier = DependScope.of(context).dependModel.statsNotifier;
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
              final totalSleepHours = statsNotifier.totalSleepHours;
              final averageSleepHours = statsNotifier.averageSleepHours;
              return SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (
                  context,
                  index,
                ) {
                  return AdaptiveCard(
                    margin: .symmetric(horizontal: 16, vertical: 8),
                    padding: .all(16),
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

          SliverToBoxAdapter(child: Divider()),
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
                    final model = state.statsModelList[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
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
                        margin: .symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
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
                      margin: .symmetric(horizontal: 16, vertical: 8),
                      padding: .all(16),
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
