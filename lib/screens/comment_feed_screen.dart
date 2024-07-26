import 'package:flutter/material.dart';
import 'package:myapp/helpers/database_helper.dart';
import 'package:myapp/helpers/shared_preferences_helper.dart';
import 'package:myapp/models/comment_model.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';

class CommentFeedScreen extends StatefulWidget {
  final Post post;

  const CommentFeedScreen({super.key, required this.post});

  @override
  State<CommentFeedScreen> createState() => _CommentFeedScreenState();
}

class _CommentFeedScreenState extends State<CommentFeedScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadComments();
  }

  Future<void> _loadCurrentUser() async {
    final user = await SharedPreferencesHelper.getUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _loadComments() async {
    final comments = await DatabaseHelper.instance.getComments(widget.post.id!);
    setState(() {
      _comments = comments;
    });
  }

  Future<void> _addComment(String content) async {
    if (_currentUser != null) {
      final newComment = Comment(
        postId: widget.post.id!,
        user: '${_currentUser!.firstName} ${_currentUser!.lastName}',
        content: content,
      );
      await DatabaseHelper.instance.insertComment(newComment);
      _commentController.clear();
      _loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://placekitten.com/200/300'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.post.user,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.post.content),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://placekitten.com/200/300'),
                  ),
                  title: Text(comment.user),
                  subtitle: Text(comment.content),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Add a comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addComment(_commentController.text),
                  child: const Text('Comment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
