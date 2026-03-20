import '../feedback_model.dart';

abstract interface class IFeedbackRepository {
  void sendFeedback(FeedbackModel feedbackModel);
}
