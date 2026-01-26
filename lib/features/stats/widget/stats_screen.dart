import 'package:dreamscape/core/l10n/app_localizations.g.dart';
import 'package:dreamscape/core/util/extension/app_context_extension.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/initialization/widget/depend_scope.dart';
import 'package:dreamscape/features/stats/controller/bloc/stats_list_bloc.dart';
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
    ColorConstants.primaryDark,
    ColorConstants.pastelBlue,
    ColorConstants.pastelGreen,
    ColorConstants.pastelPeach,
    ColorConstants.slate500,
    ColorConstants.infoDark,
  ];

  Color _baseColor = ColorConstants.primaryDark;

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

    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: theme.colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.palette, color: theme.colors.primary),
                    const SizedBox(width: 12),
                    Text(l10n.colorPickerTitle, style: theme.typography.h3),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _presetColors.map((color) {
                    final isSelected = color.value == _baseColor.value;
                    return GestureDetector(
                      onTap: () => _onColorSelected(color, dialogContext),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? theme.colors.primary : theme.colors.dividerColor,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? Icon(Icons.check, color: theme.colors.onPrimary, size: 24)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onColorSelected(Color color, BuildContext dialogContext) async {
    if (!mounted) return;

    setState(() {
      _baseColor = color;
    });

    await _saveColorPreference(color);

    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bloc = DependScope.of(context).dependModel.statsBloc;
    final statsNotifier = DependScope.of(context).dependModel.statsNotifier;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1024;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.colors.background,
            expandedHeight: 100,
            actions: [
              IconButton(
                icon: const Icon(Icons.palette_outlined),
                tooltip: l10n.paletteTooltip,
                onPressed: _showColorPicker,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.sleepSessions,
                style: theme.typography.h2.copyWith(color: theme.colors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Stats section
          SliverToBoxAdapter(
            child: ListenableBuilder(
              listenable: statsNotifier,
              builder: (context, _) {
                final totalSleepHours = statsNotifier.totalSleepHours;
                final averageSleepHours = statsNotifier.averageSleepHours;
                final sessionsCount = statsNotifier.sessionsCount;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isDesktop ? 1200.0 : (isTablet ? 800.0 : double.infinity)),
                    child: AdaptiveCard(
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                        vertical: 8,
                      ),
                      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
                      backgroundColor: theme.colors.cardBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.nightlight_round,
                              color: theme.colors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.totalSleepHours(totalSleepHours.toStringAsFixed(1)),
                              style: theme.typography.h3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.access_time,
                              label: l10n.averageSleepHours(averageSleepHours.toStringAsFixed(1)),
                              color: theme.colors.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.calendar_today,
                              label: l10n.sessionsCount(sessionsCount),
                              color: theme.colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                    ),
                  ),
                );
              },
            ),
          ),

          // GitHub Style Grid
          SliverToBoxAdapter(
            child: BlocBuilder<StatsListBloc, StatsState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is! StatsLoaded || state.statsModelList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isDesktop ? 1200.0 : (isTablet ? 800.0 : double.infinity)),
                    child: AdaptiveCard(
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                        vertical: 8,
                      ),
                      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
                      backgroundColor: theme.colors.cardBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.grid_on, color: theme.colors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Sleep Activity',
                                style: theme.typography.h4.copyWith(
                                  color: theme.colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _baseColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${state.statsModelList.length} sessions',
                              style: theme.typography.bodySmall.copyWith(
                                color: _baseColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: _SleepSessionsGrid(
                          count: state.statsModelList.length,
                          maxPerRow: 10,
                          boxSize: 14.0,
                          spacing: 4.0,
                          color: _baseColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _GridLegendItem(
                            color: theme.colors.surface,
                            label: 'No session',
                            borderColor: theme.colors.dividerColor,
                          ),
                          const SizedBox(width: 16),
                          _GridLegendItem(
                            color: _baseColor,
                            label: 'Session',
                            borderColor: _baseColor,
                          ),
                        ],
                      ),
                    ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Sessions List
          BlocConsumer(
            listener: (context, state) {
              if (state is StatsLoaded) {
                statsNotifier.setStats();
              }
            },
            bloc: bloc,
            builder: (context, state) {
              return switch (state) {
                StatsLoaded() =>
                  state.statsModelList.isEmpty
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(childCount: 1, (context, index) {
                            return AdaptiveCard(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: theme.colors.cardBackground,
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.bedtime_outlined,
                                      size: 48,
                                      color: theme.colors.textSecondary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.noStatsFound,
                                      style: theme.typography.h4.copyWith(
                                        color: theme.colors.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final model = state.statsModelList[index];
                            final sleepDurationHours = model.sleepTime.hour.toString().padLeft(
                              2,
                              '0',
                            );
                            final sleepDurationMinutes = model.sleepTime.minute.toString().padLeft(
                              2,
                              '0',
                            );
                            final bedHour = model.bedTime.hour.toString().padLeft(2, '0');
                            final bedMinute = model.bedTime.minute.toString().padLeft(2, '0');
                            final riseHour = model.riseTime.hour.toString().padLeft(2, '0');
                            final riseMinute = model.riseTime.minute.toString().padLeft(2, '0');

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
                                    foregroundColor: theme.colors.onPrimary,
                                    icon: Icons.delete_outline,
                                    label: l10n.delete,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ],
                              ),
                              child: AdaptiveCard(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                padding: const EdgeInsets.all(16),
                                backgroundColor: theme.colors.cardBackground,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: theme.colors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          model.sleepQuality.icon,
                                          const SizedBox(height: 4),
                                          Text(
                                            model.sleepQuality.name,
                                            style: theme.typography.bodySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.bedtime,
                                                size: 18,
                                                color: theme.colors.primary,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                l10n.youSleptFor(
                                                  '$sleepDurationHours:$sleepDurationMinutes',
                                                ),
                                                style: theme.typography.h4,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 16,
                                                color: theme.colors.textSecondary,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  l10n.bedRiseTime(
                                                    '$bedHour:$bedMinute',
                                                    '$riseHour:$riseMinute',
                                                  ),
                                                  style: theme.typography.bodySmall.copyWith(
                                                    color: theme.colors.textSecondary,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                StatsEmpty() => SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: 1, (context, index) {
                    return AdaptiveCard(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: theme.colors.cardBackground,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.bedtime_outlined,
                              size: 48,
                              color: theme.colors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.noStatsFound,
                              style: theme.typography.h4.copyWith(
                                color: theme.colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                StatsError(:final message) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: theme.colors.error),
                        const SizedBox(height: 12),
                        Text(
                          'Error: $message',
                          style: theme.typography.h4.copyWith(color: theme.colors.error),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                _ => SliverFillRemaining(
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.unknownState),
                    ),
                  ),
              };
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      );
        },
      ),
    );
  }
}

// GitHub Style Grid Widget
class _SleepSessionsGrid extends StatelessWidget {
  const _SleepSessionsGrid({
    required this.count,
    this.maxPerRow = 7,
    this.boxSize = 12.0,
    this.spacing = 3.0,
    this.color,
  });

  final int count;
  final int maxPerRow;
  final double boxSize;
  final double spacing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeColor = color ?? theme.colors.primary;
    final inactiveColor = theme.colors.surface;

    final rows = (count / maxPerRow).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rows - 1 ? spacing : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(maxPerRow, (colIndex) {
              final boxIndex = rowIndex * maxPerRow + colIndex;
              final isActive = boxIndex < count;

              return Padding(
                padding: EdgeInsets.only(right: colIndex < maxPerRow - 1 ? spacing : 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: isActive ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: isActive ? activeColor : theme.colors.dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

// Legend Item for Grid
class _GridLegendItem extends StatelessWidget {
  const _GridLegendItem({required this.color, required this.label, required this.borderColor});

  final Color color;
  final String label;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.typography.bodySmall.copyWith(
            color: theme.colors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
