final class FeedbackModel {
  const FeedbackModel({
    required this.message,
    required this.category,
    this.userId,
    this.userEmail,
  });

  final String message;
  final String category; // 'bug' or 'suggestion'
  final String? userId;
  final String? userEmail;

  Map<String, dynamic> toJson() => {
        'message': message,
        'category': category,
        'user_id': userId,
        'user_email': userEmail,
        'created_at': DateTime.now().toIso8601String(),
      };
}

