import 'package:dio/dio.dart';

import '../../config/app_config.dart';

final class SleepAiService {
  SleepAiService() {
    final String apiKey = _apiKey.trim();
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrls.first,
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 40),
      ),
    );
  }

  static const String _apiKey = AppConfig.openAIApiKey;

  static const List<String> _baseUrls = <String>['https://routerai.ru/api/v1'];

  static const String _model = 'meta-llama/llama-3.3-70b-instruct';

  late final Dio _dio;

  Future<String> analyzeSleepHistory({
    required int sessionCount,
    required double totalSleepHours,
    required double averageSleepHours,
    required List<String> sleepEntries,
    required Map<String, int> moodDistribution,
    Map<String, dynamic>? phoneHealthData,
  }) async {
    try {
      final String sessionsText = sleepEntries.isEmpty
          ? 'История сна отсутствует.'
          : sleepEntries
                .asMap()
                .entries
                .map((entry) => '${entry.key + 1}. ${entry.value}')
                .join('\n');
      final String moodText = moodDistribution.isEmpty
          ? 'нет данных'
          : moodDistribution.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
      final String phoneDataText = phoneHealthData == null
          ? 'Данные телефона/часов отсутствуют.'
          : 'Шаги: ${phoneHealthData['steps'] ?? 0}, '
                'Калории: ${phoneHealthData['calories'] ?? 0}, '
                'Пульс (средний): ${phoneHealthData['avgHeartRate'] ?? 0}, '
                'Сон по health: ${phoneHealthData['sleepHours'] ?? 0} ч';

      final prompt =
          '''
Ты - эксперт по анализу качества сна. Проанализируй историю сна пользователя и дай структурированную оценку на основе всех записей.

**ОБЩАЯ СТАТИСТИКА:**
- Всего сессий: $sessionCount
- Суммарный сон: ${totalSleepHours.toStringAsFixed(1)} часов
- Средний сон: ${averageSleepHours.toStringAsFixed(1)} часов
- Распределение качества сна: $moodText

**ПОЛНАЯ ИСТОРИЯ СЕССИЙ:**
$sessionsText

**ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ С ТЕЛЕФОНА/ЧАСОВ:**
$phoneDataText

**ИНСТРУКЦИИ:**
1. Оцени общий тренд качества сна по шкале от 1 до 10
2. Выдели ключевые закономерности по времени, длительности и качеству
3. Укажи сильные и слабые стороны режима сна
4. Дай 3-5 конкретных рекомендаций на основе истории
5. Назови потенциальные риски, если тренд не улучшится
6. Ссылайся на конкретные данные из истории, а не на одну сессию

**ФОРМАТ ОТВЕТА:**
Пиши по-русски, профессионально и кратко.
Структура ответа:
1) "Оценка сна: X/10"
2) "Что вижу по данным:"
3) "Риски:"
4) "Что делать дальше:"
''';

      final Response<dynamic> response = await _postChatCompletions(
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': 'Ты эксперт по сну. Отвечай строго по-русски.'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 1400,
        },
      );

      // ignore: avoid_dynamic_calls
      final choices = response.data['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        return 'Нет данных для генерации заметки о сне.';
      }

      final String content = choices.first['message']['content'] as String? ?? '';
      return content.trim().isEmpty ? 'Нет данных для генерации заметки о сне.' : content.trim();
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;
      final Object? responseData = e.response?.data;
      if (statusCode != null) {
        if (statusCode == 401) {
          return 'Ошибка API (401): невалидный API-ключ или нет доступа к модели.';
        }
        if (statusCode == 503) {
          return 'Ошибка API (503): сервис временно недоступен. Попробуй чуть позже.';
        }
        return 'Ошибка API ($statusCode): ${responseData ?? e.message}';
      }
      return 'Ошибка сети: ${e.message}';
    } on Object catch (e) {
      return 'Error generating sleep note: $e';
    }
  }

  Future<Response<dynamic>> _postChatCompletions({required Map<String, Object> data}) async {
    DioException? lastError;

    for (final String baseUrl in _baseUrls) {
      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          return await _dio.post(
            '$baseUrl/chat/completions',
            data: data,
            options: Options(
              headers: <String, String>{
                'HTTP-Referer': 'https://dreamscape.app',
                'X-Title': 'Dreamscape',
              },
            ),
          );
        } on DioException catch (e) {
          lastError = e;
          if (_shouldRetry(e) && attempt < 2) {
            await Future<void>.delayed(Duration(milliseconds: 250 * (attempt + 1)));
            continue;
          }
          break;
        }
      }
    }

    throw lastError ?? DioException(requestOptions: RequestOptions(path: '/chat/completions'));
  }

  bool _shouldRetry(DioException e) {
    final int? status = e.response?.statusCode;
    if (status == null) {
      return e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError;
    }
    return status == 429 || status == 500 || status == 502 || status == 503 || status == 504;
  }
}
