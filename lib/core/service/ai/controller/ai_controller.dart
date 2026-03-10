import 'package:flutter/material.dart';

import '../../../../features/stats/model/stats_model.dart';
import '../../../util/logger/logger.dart';
import '../data/ai_sleep_service.dart';

final class AiSleepController extends ChangeNotifier with LoggerMixin {
  AiSleepController({required AiSleepService aiSleepService}) : _aiSleepService = aiSleepService;

  final AiSleepService _aiSleepService;

  bool isLoading = false;
  bool isDone = false;
  String buffer = '';
  String? error;

  Stream<String> analyzeSleepHistoryStream(List<StatsModel> sleepHistory) async* {
    isLoading = true;
    isDone = false;
    error = null;
    buffer = '';

    try {
      await for (final String chunk in _aiSleepService.analyzeSleepHistoryStream(sleepHistory)) {
        buffer += chunk;
        yield buffer;
        notifyListeners();
      }
      isDone = true;
    } on Object catch (e, st) {
      logger.error('Error analyzing sleep history: $e', stackTrace: st);
      error = 'Ошибка при анализе данных. Пожалуйста, попробуйте позже.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
