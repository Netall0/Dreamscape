import 'package:dio/dio.dart';

import '../../../util/logger/logger.dart';
import '../feedback_model.dart';
import 'i_feedback_repository.dart';

final class FeeedbackRepository with LoggerMixin implements IFeedbackRepository {
  final Dio dio = Dio();
  @override
  Future<void> sendFeedback(FeedbackModel feedbackModel) async {
    try {
      final Response<dynamic> response = await dio.post(
        'http://10.0.2.2:8080/feedback',
        data: feedbackModel.toJson(),
      );
      logger.info('post  server feedback, ${response.data}');
    } on Object catch (e, st) {
      logger.error(e.toString());
      logger.info(st.toString());
      
    }
  }
}

//TODO unifield code style
