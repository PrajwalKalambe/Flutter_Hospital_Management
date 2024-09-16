class NotificationModel {
  final String user_name;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.user_name,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      user_name: json['user_name'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
