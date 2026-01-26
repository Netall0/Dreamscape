import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/model/feedback_model.dart';
import 'package:dreamscape/features/auth/repository/i_feedback_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class FeedbackRepository with LoggerMixin implements IFeedbackRepository {
  // ignore: unused_field
  final SupabaseClient _supabase;

  FeedbackRepository() : _supabase = Supabase.instance.client;

  @override
  Future<void> sendFeedback(FeedbackModel feedback) async {
    try {
      // TODO: Реализовать отправку feedback на сервер
      // Пример реализации через Supabase:
      // await _supabase.from('feedback').insert(feedback.toJson());
      
      // Временная заглушка для логирования
      logger.info('Feedback отправлен: ${feedback.toJson()}');
      
      // Здесь можно добавить отправку через Supabase таблицу или другой API
      // Раскомментируйте следующую строку после создания таблицы 'feedback' в Supabase:
      // await _supabase.from('feedback').insert(feedback.toJson());
      
    } on Object catch (e, st) {
      logger.error('Ошибка при отправке feedback', error: e, stackTrace: st);
      rethrow;
    }
  }
}

