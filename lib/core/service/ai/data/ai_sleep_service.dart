import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../features/stats/model/stats_model.dart';
import '../../../config/app_config.dart';
import '../../../util/logger/logger.dart';
import 'i_ai_sleep_service.dart';

final class AiSleepService with LoggerMixin implements IAiSleepService {
  AiSleepService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrls.first,
          headers: {'Authorization': 'Bearer $_apiKey', 'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

  final Dio _dio;

  static const String _apiKey = AppConfig.openAIApiKey;

  static const List<String> _baseUrls = <String>['https://routerai.ru/api/v1'];

  static const String _model = 'qwen/qwen-2.5-72b-instruct';

  @override
  Stream<String> analyzeSleepHistoryStream(List<StatsModel> sleepHistory) async* {
    final String formattedHistory = _formatSleepHistory(sleepHistory);
    final prompt =
        '''
Ты — эксперт по анализу сна. Ниже — структурированная история сна пользователя.

ДАННЫЕ (список сессий):
$formattedHistory

ЗАДАЧА:
1) Сгруппируй наблюдения по темам: длительность, время отхода ко сну, время подъема, качество.
2) Рассчитай средние значения: средняя длительность сна, среднее время отхода ко сну, среднее время подъема.
3) Кратко оцени тренд качества сна по шкале 1–10.
4) Дай 3–5 рекомендаций, опираясь на конкретные сессии.
5) Укажи риски, если тренд не улучшится.

ФОРМАТ ОТВЕТА:
Пиши по-русски, кратко и структурировано.
Вывод должен иметь блоки:
1) "Оценка сна: X/10"
2) "Средние значения:" (список)
3) "Что вижу по данным:" (маркированный список по темам)
4) "Риски:" (короткий список)
5) "Что делать дальше:" (3–5 пунктов)
6) "Список сессий:" (перепиши список сессий в сжатом виде)
Без эмодзи и нестандартных символов. Используй обычные дефисы и кавычки.
''';
    final Map<String, Object> body = {
      'model': _model,
      'stream': true,
      'messages': [
        {'role': 'system', 'content': 'Ты эксперт по сну. Отвечай строго по-русски.'},
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 1400,
      'temperature': 0.3,
    };

    late final Response<ResponseBody> response;

    try {
      response = await _dio.post<ResponseBody>(
        '/chat/completions',
        data: body,
        options: Options(responseType: ResponseType.stream),
      );
    } on Object catch (e) {
      logger.error('Stream request failed: $e');
      rethrow;
    }

    final Stream<Uint8List>? stream = response.data?.stream;

    if (stream == null) {
      logger.error('No stream in response');
      return;
    }

    final buffer = StringBuffer();

    var gotFirstChunk = false;
    await for (final Uint8List chunk in stream.timeout(
      const Duration(seconds: 25),
      onTimeout: (sink) => sink.close(),
    )) {
      final String raw = utf8.decode(chunk);
      if (!gotFirstChunk) {
        gotFirstChunk = true;
        logger.info('First AI stream chunk: ${raw.substring(0, raw.length.clamp(0, 400))}');
      }

      for (final String line in raw.split('\n')) {
        final String trimmed = line.trim();

        if (trimmed.isEmpty || !trimmed.startsWith('data: ')) {
          continue;
        }

        final String data = trimmed.substring(5).trim();

        if (data == '[DONE]') {
          return;
        }

        try {
          final json = jsonDecode(data) as Map<String, Object?>;

          final delta = (json['choices'] as List?)?.firstOrNull?['delta']?['content'] as String?;

          if (delta != null && delta.isNotEmpty) {
            final String cleaned = _cleanText(delta);
            if (cleaned.isNotEmpty) {
              buffer.write(cleaned);
              yield cleaned;
            }
          }

          logger.info(buffer.toString());
        } on FormatException catch (e) {
          logger.error('Format error parsing line: $line, error: $e');
          continue;
        } on Object catch (e) {
          logger.error('Failed to parse line: $line, error: $e');
          continue;
        }
      }
    }
  }

  @override
  Future<String> analyzeSleepHistory(List<StatsModel> sleepHistory) async {
    try {
      final String formattedHistory = _formatSleepHistory(sleepHistory);

      final prompt =
          '''
Ты — эксперт по анализу сна. Ниже — структурированная история сна пользователя.

ДАННЫЕ (список сессий):
$formattedHistory

ЗАДАЧА:
1) Сгруппируй наблюдения по темам: длительность, время отхода ко сну, время подъема, качество.
2) Рассчитай средние значения: средняя длительность сна, среднее время отхода ко сну, среднее время подъема.
3) Кратко оцени тренд качества сна по шкале 1–10.
4) Дай 3–5 рекомендаций, опираясь на конкретные сессии.
5) Укажи риски, если тренд не улучшится.

ФОРМАТ ОТВЕТА:
Пиши по-русски, кратко и структурировано.
Вывод должен иметь блоки:
1) "Оценка сна: X/10"
2) "Средние значения:" (список)
3) "Что вижу по данным:" (маркированный список по темам)
4) "Риски:" (короткий список)
5) "Что делать дальше:" (3–5 пунктов)
6) "Список сессий:" (перепиши список сессий в сжатом виде)
Без эмодзи и нестандартных символов. Используй обычные дефисы и кавычки.
''';

      final Response<Map<String, Object?>> response = await _postChatCompletions(
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': 'Ты эксперт по сну. Отвечай строго по-русски.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1400,
          'temperature': 0.3,
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
      final String cleaned = _cleanText(content ?? '');

      return cleaned.isNotEmpty ? cleaned : 'Нет данных для анализа.';
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
            '/chat/completions',
            data: data,
            options: Options(
              headers: <String, String>{
                'HTTP-Referer': 'https://dreamscape.app',
                'X-Title': 'Dreamscape', //TODO app config
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

  String _formatSleepHistory(List<StatsModel> sleepHistory) {
    if (sleepHistory.isEmpty) {
      return '- (нет данных)';
    }
    final buffer = StringBuffer();
    for (int i = 0; i < sleepHistory.length; i++) {
      final StatsModel s = sleepHistory[i];
      final String date =
          s.sleepDate != null ? s.sleepDate!.toIso8601String().split('T').first : 'unknown';
      final String bed = _formatTimeOfDay(s.bedTime);
      final String rise = _formatTimeOfDay(s.riseTime);
      final String duration = _formatTimeOfDay(s.sleepTime);
      final String notes = s.sleepNotes.trim().isEmpty ? '-' : s.sleepNotes.trim();
      buffer.writeln(
        '${i + 1}. date=$date | bed=$bed | rise=$rise | duration=$duration | quality=${s.sleepQuality.name} | notes=$notes',
      );
    }
    return buffer.toString().trimRight();
  }

  String _formatTimeOfDay(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _cleanText(String input) {
    if (input.isEmpty) {
      return input;
    }
    // Remove control characters but keep common whitespace.
    var cleaned = input.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
    cleaned = cleaned.replaceAll('\r', '');
    cleaned = cleaned.replaceAll('•', '-');
    cleaned = cleaned.replaceAll('–', '-');
    cleaned = cleaned.replaceAll('—', '-');
    return cleaned;
  }
}
