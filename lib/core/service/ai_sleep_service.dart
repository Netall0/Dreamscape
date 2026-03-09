import 'package:dio/dio.dart';

import '../../features/stats/model/stats_model.dart';
import '../config/app_config.dart';
import '../util/logger/logger.dart';
import 'i_ai_sleep_service.dart';

final class AiSleepService with LoggerMixin implements IAiSleepService {
  AiSleepService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrls.first,
          headers: {'Authorization': 'Bearer $_apiKey', 'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 40),
        ),
      ) {
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
  }

  final Dio _dio;

  static const String _apiKey = AppConfig.openAIApiKey;

  static const List<String> _baseUrls = <String>['https://routerai.ru/api/v1'];

  static const String _model = 'meta-llama/llama-3.3-70b-instruct';

  @override
  Future<String> analyzeSleepHistory(List<StatsModel> sleepHistory) async {
    try {
      final sleepData = sleepHistory.toString();

      final prompt =
          '''
Ты - эксперт по анализу качества сна. Проанализируй историю сна пользователя и дай структурированную оценку на основе всех записей.

**ОБЩАЯ СТАТИСТИКА:**
$sleepData
(повтори данные в виде списка, не обобщая, но при анализе учти все записи)



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

      final Response<Map<String, Object?>> response = await _postChatCompletions(
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': 'Ты эксперт по сну. Отвечай строго по-русски.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1400,
          'temperature': 0.7,
        },
      );

      final Map<String, Object?>? data = response.data;
      final choices = data?['choices'] as List<Object?>?;
      if (choices == null || choices.isEmpty) {
        return 'Нет данных для анализа.';
      }

      final firstChoice = choices.first! as Map<String, Object?>;
      final message = firstChoice['message']! as Map<String, Object?>;
      final String? content = (message['content'] as String?)?.trim();

      return (content?.isNotEmpty ?? false) ? content! : 'Нет данных для анализа.';
    } on Object catch (e) {
      logger.error('Error analyzing sleep history: $e');
      rethrow;

      //TODO errod utils handling
    }
  }

  Future<Response<Map<String, Object?>>> _postChatCompletions({
    required Map<String, Object> data,
  }) async {
    DioException? lastError;

    for (final String baseUrl in _baseUrls) {
      for (var attempt = 0; attempt < 3; attempt++) {
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
    return [429, 500, 502, 503, 504].contains(status);
  }
}
