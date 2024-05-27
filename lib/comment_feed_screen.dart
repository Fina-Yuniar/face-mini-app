import 'package:flutter/material.dart';

class CommentFeedScreen extends StatelessWidget {
  const CommentFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://placekitten.com/200/300'),
            ),
            title: Text('User $index'),
            subtitle: Text('This is a comment by user $index.'),
          );
        },
      ),
    );
  }
}
