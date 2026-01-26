import 'package:dreamscape/features/auth/model/feedback_model.dart';

abstract interface class IFeedbackRepository {
  Future<void> sendFeedback(FeedbackModel feedback);
}

