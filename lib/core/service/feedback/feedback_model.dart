final class FeedbackModel {
  FeedbackModel({required this.id, required this.name, required this.email, required this.message});

  final String id;
  final String name;
  final String email;
  final String message;

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'message': message};
}

//TODO data class
