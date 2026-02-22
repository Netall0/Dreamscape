// screens/sleep_result_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';
import '../../../core/l10n/app_localizations.g.dart';
import '../../../core/data/ai/ai_sleep_service.dart';
import '../../../core/util/extension/app_context_extension.dart';
import '../model/stats_model.dart';

class SleepResultScreen extends StatefulWidget {
  final List<StatsModel> sessions;
  final double totalSleepHours;
  final double averageSleepHours;
  final Map<String, dynamic>? phoneHealthData;

  const SleepResultScreen({
    required this.sessions,
    required this.totalSleepHours,
    required this.averageSleepHours,
    this.phoneHealthData,
  });

  @override
  State<SleepResultScreen> createState() => _SleepResultScreenState();
}

class _SleepResultScreenState extends State<SleepResultScreen> {
  final SleepAiService _sleepService = SleepAiService();
  String _displayedText = '';
  String _fullText = '';
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      final List<String> sleepEntries = widget.sessions.map(_sessionToPromptEntry).toList();
      final Map<String, int> moodDistribution = _buildMoodDistribution();
      final String result = await _sleepService.analyzeSleepHistory(
        sessionCount: widget.sessions.length,
        totalSleepHours: widget.totalSleepHours,
        averageSleepHours: widget.averageSleepHours,
        sleepEntries: sleepEntries,
        moodDistribution: moodDistribution,
        phoneHealthData: widget.phoneHealthData,
      );

      setState(() {
        _fullText = result;
        _isLoading = false;
      });

      // Запускаем анимацию появления текста
      _animateText();
    } catch (e) {
      setState(() {
        _fullText = 'Ошибка: $e';
        _isLoading = false;
        _displayedText = _fullText;
      });
    }
  }

  String _sessionToPromptEntry(StatsModel session) {
    final String bedTime = _formatTime(session.bedTime);
    final String riseTime = _formatTime(session.riseTime);
    final String duration = _formatTime(session.sleepTime);
    final String notes = session.sleepNotes.trim().isEmpty ? 'без заметок' : session.sleepNotes.trim();
    return 'сон: $duration, качество: ${session.sleepQuality.name}, отбой: $bedTime, подъем: $riseTime, заметки: $notes';
  }

  Map<String, int> _buildMoodDistribution() {
    final Map<String, int> distribution = <String, int>{};
    for (final session in widget.sessions) {
      distribution.update(session.sleepQuality.name, (value) => value + 1, ifAbsent: () => 1);
    }
    return distribution;
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  double _toHours(TimeOfDay duration) {
    return duration.hour + duration.minute / 60.0;
  }

  void _animateText() {
    var charIndex = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (charIndex < _fullText.length) {
        setState(() {
          _displayedText = _fullText.substring(0, charIndex + 1);
        });
        charIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppTheme theme = context.appTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sleepAnalysis, style: theme.typography.h4),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colors.primary),
                  const SizedBox(height: 16),
                  Text(l10n.analyzingSleep, style: theme.typography.bodyMedium),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Сводка данных
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colors.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.yourData, style: theme.typography.h5),
                        const SizedBox(height: 8),
                        Text(
                          l10n.totalSleep(widget.totalSleepHours.toStringAsFixed(1)),
                          style: theme.typography.bodyMedium,
                        ),
                        Text(
                          l10n.averageSleep(widget.averageSleepHours.toStringAsFixed(1)),
                          style: theme.typography.bodyMedium,
                        ),
                        Text(
                          l10n.sessionsCount(widget.sessions.length.toString()),
                          style: theme.typography.bodyMedium,
                        ),
                        if (widget.sessions.isNotEmpty)
                          Text(
                            l10n.lastSleep(
                              _toHours(widget.sessions.first.sleepTime).toStringAsFixed(1),
                              widget.sessions.first.sleepQuality.name,
                            ),
                            style: theme.typography.bodyMedium,
                          ),
                        if (widget.phoneHealthData != null) ...[
                          const SizedBox(height: 8),
                          Text(l10n.phoneDataTitle, style: theme.typography.bodyMedium),
                          Text(
                            l10n.stepsLabel('${widget.phoneHealthData!['steps'] ?? 0}'),
                            style: theme.typography.bodyMedium,
                          ),
                          Text(
                            l10n.caloriesLabel('${widget.phoneHealthData!['calories'] ?? 0}'),
                            style: theme.typography.bodyMedium,
                          ),
                          Text(
                            l10n.avgHeartRateLabel('${widget.phoneHealthData!['avgHeartRate'] ?? 0}'),
                            style: theme.typography.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Результат анализа
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colors.primary, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.nightlight_round, color: theme.colors.primary),
                            const SizedBox(width: 8),
                            Text(l10n.aiAnalysis, style: theme.typography.h4),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _displayedText,
                          style: theme.typography.bodyMedium.copyWith(height: 1.5),
                        ),
                        if (_displayedText.length < _fullText.length)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 16,
                            color: theme.colors.primary,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
