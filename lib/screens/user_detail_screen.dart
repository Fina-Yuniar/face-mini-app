import 'package:flutter/material.dart';
import 'package:myapp/helpers/database_helper.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/message_screen.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  User? _user;
  List<Post> _userPosts = [];
  bool _isFriend = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadUserPosts();
  }

  Future<void> _loadUser() async {
    final user = await DatabaseHelper.instance.getUserById(widget.userId);
    // Check if the user is already a friend
    // Implement the logic to check the friendship status from the database
    setState(() {
      _user = user;
      _isFriend = false; // Replace with actual check
    });
  }

  Future<void> _loadUserPosts() async {
    final posts = await DatabaseHelper.instance.getUserPosts(widget.userId);
    setState(() {
      _userPosts = posts;
    });
  }

  Future<void> _toggleFriendship() async {
    setState(() {
      _isFriend = !_isFriend;
    });
    // Implement the logic to add or remove friend in the database
  }

  void _messageUser() {
    // Implement navigation to message screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageScreen(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.blue,
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage('https://placekitten.com/200/300'),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_user!.firstName} ${_user!.lastName}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'User bio or status message',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _toggleFriendship,
                        child: Text(_isFriend ? 'Remove Friend' : 'Add Friend'),
                      ),
                      ElevatedButton(
                        onPressed: _messageUser,
                        child: const Text('Message'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: _userPosts.map((post) {
                      return PostCard(
                        userId: post.userId,
                        user: post.user,
                        content: post.content,
                        likes: post.likedBy.length,
                        shares: post.shares,
                        isLiked: post.likedBy.contains(_user?.email),
                        onLike: () {}, // Implement like functionality
                        onShare: () {}, // Implement share functionality
                        onComment: () {}, // Implement comment functionality
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
