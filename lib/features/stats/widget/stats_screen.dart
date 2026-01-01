import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:dreamscape/features/stats/bloc/stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/colors/color_constant.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with LoggerMixin {
  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bloc = DependScope.of(context).dependModel.statsBloc;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Your Sleep Stats',
                    style: theme.typography.h2.copyWith(color: Colors.white),
                  ),
                  centerTitle: true,
                ),
              ),
              switch (state) {
                StatsLoaded() => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final model = state.statsModelList[index];
                    return Card(
                      color: ColorConstants.midnightBlue,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                    );
                  }, childCount: state.statsModelList.length),
                ),
                StatsInitial() => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator.adaptive()),
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
              },
            ],
          );
        },
      ),
    );
  }
}
