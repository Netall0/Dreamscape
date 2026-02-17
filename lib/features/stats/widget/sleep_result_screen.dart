// screens/sleep_result_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uikit/uikit.dart';
import '../../../core/l10n/app_localizations.g.dart';
import '../../../core/data/sleep/gemini_service.dart' show GeminiService;
import '../../../core/util/extension/app_context_extension.dart';

class SleepResultScreen extends StatefulWidget {
  final double sleepHours;
  final String mood;
  final String? description;

  const SleepResultScreen({required this.sleepHours, required this.mood, this.description});

  @override
  State<SleepResultScreen> createState() => _SleepResultScreenState();
}

class _SleepResultScreenState extends State<SleepResultScreen> {
  final GeminiService _sleepService = GeminiService();
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
      // Получаем полный ответ от AI
      final String result = await _sleepService.analyzeSleepNote(
        sleepQuality: widget.mood,
        sleepTime: widget.sleepHours.toString(),
        sleepNotes: widget.description ?? '',
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
                        l10n.sleepHours(widget.sleepHours.toStringAsFixed(1)),
                        style: theme.typography.bodyMedium,
                      ),
                      Text(l10n.moodLabel(widget.mood), style: theme.typography.bodyMedium),
                      if (widget.description != null)
                        Text(l10n.notesLabel(widget.description!), style: theme.typography.bodyMedium),
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
                      Text(_displayedText, style: theme.typography.bodyMedium.copyWith(height: 1.5)),
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
