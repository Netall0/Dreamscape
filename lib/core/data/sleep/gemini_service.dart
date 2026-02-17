import 'package:google_generative_ai/google_generative_ai.dart';

final class GeminiService {
  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      generationConfig: GenerationConfig(temperature: 0.7, maxOutputTokens: 1400),
      apiKey: 'AIzaSyBbD6iREqr8DCVRCRngZd7264ExbjXVIHY',
    );
  }
  late final GenerativeModel _model;

  Future<String> analyzeSleepNote({
    required String sleepQuality,
    required String sleepNotes,
    required String sleepTime,
  }) async {
    try {
      final prompt =
          '''
Ты - эксперт по анализу качества сна. Проанализируй данные о сне пользователя и дай краткую, но полезную оценку.

**ДАННЫЕ О СНЕ:**
- Продолжительность: $sleepTime часов
- Настроение после сна: $sleepQuality
${sleepNotes.isNotEmpty ? '- Дополнительная информация: $sleepNotes' : ''}

**ИНСТРУКЦИИ:**
1. Оцени качество сна по шкале от 1 до 10
2. Дай краткий анализ (2-3 предложения)
3. Укажи, достаточно ли это количество сна
4. Дай 2-3 конкретных совета для улучшения сна (если нужно)
5. Отметь возможные проблемы (если есть)
6. при малом кол-ве сна, оцена не может быть выше 6, при плохом настроении - выше 5

**ФОРМАТ ОТВЕТА:**
Используй эмодзи для наглядности. Пиши по-русски, дружелюбно, но профессионально.

Начни с "Оценка сна: X/10 ⭐" и далее анализ.
''';
      final String result = await _generateWithContinuation(prompt);
      return result.isEmpty ? 'Нет данных для генерации заметки о сне.' : result;
    } on Object catch (e) {
      // Handle errors appropriately
      return 'Error generating sleep note: $e';
    }
  }

  Future<String> _generateWithContinuation(
    String prompt, {
    int step = 0,
    String current = '',
  }) async {
    if (step >= 3) {
      return current.trim();
    }

    final GenerateContentResponse response = await _model.generateContent([Content.text(prompt)]);
    final String chunk = response.text?.trim() ?? '';
    final String merged = [current, chunk].where((e) => e.isNotEmpty).join('\n').trim();

    final FinishReason? reason = response.candidates.isNotEmpty
        ? response.candidates.first.finishReason
        : null;

    if (reason == FinishReason.maxTokens) {
      final String tail = merged.length > 1500 ? merged.substring(merged.length - 1500) : merged;
      return _generateWithContinuation(
        '''
Ниже уже сгенерированная часть ответа:
$tail

Продолжи ответ строго с места остановки.
Не повторяй уже написанное. Сохрани стиль и формат.
''',
        step: step + 1,
        current: merged,
      );
    }

    return merged;
  }
}
