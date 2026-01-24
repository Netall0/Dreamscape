import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_list_bloc.dart';
import 'package:dreamscape/features/stats/model/stats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/uikit.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with LoggerMixin {
  static const List<Color> _presetColors = [
    ColorConstants.pastelIndigo,
    ColorConstants.duskPurple,
    ColorConstants.nightViolet,
    ColorConstants.pastelBlue,
    ColorConstants.pastelGreen,
    ColorConstants.pastelPeach,
  ];

  Color _baseColor = ColorConstants.pastelIndigo;

  @override
  void initState() {
    super.initState();
    _loadColorPreference();
  }

  Future<void> _loadColorPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getInt('sleep_grid_base_color');

    if (!mounted) return;

    if (savedValue != null) {
      setState(() {
        _baseColor = Color(savedValue);
      });
    }
  }

  Future<void> _saveColorPreference(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sleep_grid_base_color', color.value);
  }

  Future<void> _showColorPicker() async {
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = context.appTheme;
        return Container(
          decoration: const BoxDecoration(
            color: ColorConstants.midnightBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выбери цвет для трекинга сна',
                style: theme.typography.h4.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _presetColors.map((color) {
                  final isSelected = color.value == _baseColor.value;
                  return GestureDetector(
                    onTap: () => _onColorSelected(color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.black54,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onColorSelected(Color color) async {
    if (!mounted) return;

    setState(() {
      _baseColor = color;
    });

    await _saveColorPreference(color);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

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
             actions: [
               IconButton(
                 icon: const Icon(Icons.palette_outlined),
                 tooltip: 'Настроить цвета',
                 onPressed: _showColorPicker,
               ),
             ],
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

          SliverToBoxAdapter(
            child: ListenableBuilder(
              listenable: statsNotifier,
              builder: (context, _) {
                final totalSleepHours = statsNotifier.totalSleepHours;
                final averageSleepHours = statsNotifier.averageSleepHours;
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
              },
            ),
          ),

          SliverToBoxAdapter(
            child: BlocBuilder<StatsListBloc, StatsState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is! StatsLoaded || state.statsModelList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _SleepSessionsGrid(
                  models: state.statsModelList,
                  baseColor: _baseColor,
                );
              },
            ),
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
                    final model = state.statsModelList[index];
                    final sleepDurationHours =
                        model.sleepTime.hour.toString().padLeft(2, '0');
                    final sleepDurationMinutes =
                        model.sleepTime.minute.toString().padLeft(2, '0');
                    final bedHour =
                        model.bedTime.hour.toString().padLeft(2, '0');
                    final bedMinute =
                        model.bedTime.minute.toString().padLeft(2, '0');
                    final riseHour =
                        model.riseTime.hour.toString().padLeft(2, '0');
                    final riseMinute =
                        model.riseTime.minute.toString().padLeft(2, '0');

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
                      child: AdaptiveCard(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: ColorConstants.midnightBlue,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              model.sleepQuality.icon,
                              const SizedBox(height: 4),
                              Text(model.sleepQuality.name),
                            ],
                          ),
                          title: Text(
                            'You slept for $sleepDurationHours:$sleepDurationMinutes',
                            style: theme.typography.h4,
                          ),
                          subtitle: Text(
                            'Bed: $bedHour:$bedMinute • Rise: $riseHour:$riseMinute',
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(16),
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

class _SleepSessionsGrid extends StatelessWidget {
  const _SleepSessionsGrid({
    required this.models,
    required this.baseColor,
  });

  final List<StatsModel> models;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    if (models.isEmpty) {
      return const SizedBox.shrink();
    }

    return AdaptiveCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      backgroundColor: ColorConstants.midnightBlue,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const columns = 7;
          const spacing = 4.0;
          final cellSize =
              (constraints.maxWidth - (columns - 1) * spacing) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleep streak',
                style: context.appTheme.typography.h5,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(models.length, (index) {
                  final model = models[index];
                  final hours = model.sleepTime.hour +
                      (model.sleepTime.minute / 60.0);
                  final color = _colorForHours(hours);

                  return Tooltip(
                    message: '${hours.toStringAsFixed(1)} h',
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _colorForHours(double hours) {
    final clamped = hours.clamp(0.0, 10.0);
    final t = clamped / 10.0;
    return Color.lerp(
          baseColor.withOpacity(0.25),
          baseColor,
          t,
        ) ??
        baseColor;
  }
}
