import 'package:dio/dio.dart';

import '../../../util/logger/logger.dart';
import '../feedback_model.dart';
import 'i_feedback_repository.dart';

final class FeeedbackRepository with LoggerMixin implements IFeedbackRepository {
  final Dio dio = Dio(
    
    BaseOptions(followRedirects: true, validateStatus: (status) => status! < 500,),
  );
  @override
  Future<void> sendFeedback(FeedbackModel feedbackModel) async {
    try {
      final Response<dynamic> response = await dio.post(
        'http://87.236.23.155:8080/feedback',
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
