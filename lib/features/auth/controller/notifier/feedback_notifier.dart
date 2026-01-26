import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:dreamscape/features/auth/model/feedback_model.dart';
import 'package:dreamscape/features/auth/repository/i_feedback_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class FeedbackNotifier extends ChangeNotifier with LoggerMixin {
  final IFeedbackRepository _feedbackRepository;

  FeedbackNotifier({required IFeedbackRepository feedbackRepository})
      : _feedbackRepository = feedbackRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> sendFeedback({
    required String message,
    required String category,
  }) async {
    if (message.trim().isEmpty) {
      _errorMessage = 'Сообщение не может быть пустым';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      final feedback = FeedbackModel(
        message: message.trim(),
        category: category,
        userId: user?.id,
        userEmail: user?.email,
      );

      await _feedbackRepository.sendFeedback(feedback);

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on Object catch (e, st) {
      logger.error('Ошибка при отправке feedback', error: e, stackTrace: st);
      _isLoading = false;
      _errorMessage = 'Не удалось отправить feedback. Попробуйте позже.';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

