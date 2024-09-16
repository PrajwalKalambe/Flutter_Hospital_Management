class NotificationModel {
  final String message;
  final String userId;
  final String userName;
  final String doctorId;
  final String id;

  NotificationModel({
    required this.message,
    required this.userId,
    required this.userName,
    required this.doctorId,
    required this.id,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      message: json['message'],
      userId: json['user_id'],
      userName: json['user_name'],
      doctorId: json['doctor_id'],
      id: json['id'],
    );
  }
}
