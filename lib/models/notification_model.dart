class NotificationModel {
  final int? id;
  final String message;
  final String time;
  final String avatarUrl;

  NotificationModel(
      {this.id,
      required this.message,
      required this.time,
      required this.avatarUrl});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'time': time,
      'avatarUrl': avatarUrl,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
      time: json['time'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
