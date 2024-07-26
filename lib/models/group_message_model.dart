class GroupMessage {
  final int? id;
  final int groupId;
  final String sender;
  final String message;
  final DateTime timestamp;

  GroupMessage({
    this.id,
    required this.groupId,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'sender': sender,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GroupMessage.fromJson(Map<String, dynamic> json) {
    return GroupMessage(
      id: json['id'],
      groupId: json['groupId'],
      sender: json['sender'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
