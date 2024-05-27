import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel('John Doe liked your post.', '2m ago', 'https://placekitten.com/200/300'),
    NotificationModel('Jane Smith commented on your photo.', '10m ago', 'https://placekitten.com/200/300'),
    NotificationModel('Michael Johnson sent you a friend request.', '1h ago', 'https://placekitten.com/200/300'),
    // Tambahkan lebih banyak contoh notifikasi jika diperlukan
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotificationModel {
  final String message;
  final String time;
  final String avatarUrl;

  NotificationModel(this.message, this.time, this.avatarUrl);
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(notification.avatarUrl),
      ),
      title: Text(notification.message),
      subtitle: Text(notification.time),
      trailing: const Icon(Icons.more_horiz),
    );
  }
}
