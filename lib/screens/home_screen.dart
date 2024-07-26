import 'package:flutter/material.dart';
import 'package:myapp/screens/comment_feed_screen.dart';
import 'package:myapp/screens/group_screen.dart';
import 'package:myapp/helpers/database_helper.dart';
import 'package:myapp/helpers/shared_preferences_helper.dart';
import 'package:myapp/models/notification_model.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/screens/notification_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/screens/user_detail_screen.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _postController = TextEditingController();
  List<Post> _posts = [];
  User? _currentUser;
  int _tabBottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadPosts();
  }

  Future<void> _loadCurrentUser() async {
    final user = await SharedPreferencesHelper.getUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _loadPosts() async {
    final posts = await DatabaseHelper.instance.getPosts();
    setState(() {
      _posts = posts;
    });
  }

  Future<void> _addPost(String content) async {
    if (_currentUser != null) {
      final newPost = Post(
        userId: _currentUser!.id!,
        user: '${_currentUser!.firstName} ${_currentUser!.lastName}',
        content: content,
      );
      await DatabaseHelper.instance.insertPost(newPost);
      _postController.clear();

      final newNotification = NotificationModel(
        message: '${_currentUser?.firstName} posted a new message.',
        time: 'Just now',
        avatarUrl:
            'https://placekitten.com/200/300', // Replace with actual avatar URL
      );
      await DatabaseHelper.instance.insertNotification(newNotification);

      _loadPosts();
    }
  }

  Future<void> _toggleLike(Post post) async {
    if (_currentUser != null) {
      if (post.likedBy.contains(_currentUser!.email)) {
        post.likedBy.remove(_currentUser!.email);
      } else {
        post.likedBy.add(_currentUser!.email);
      }
      await DatabaseHelper.instance.updatePost(post);
      _loadPosts();
    }
  }

  void _sharePost(Post post) {
    Share.share('Check out this post from ${post.user}: ${post.content}');
  }

  List<Widget> _listScreen() {
    return [
      _homeContent(),
      const GroupScreen(),
      NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _homeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _postController,
                decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _addPost(_postController.text),
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PostCard(
                  userId: post.userId,
                  user: post.user,
                  content: post.content,
                  likes: post.likedBy.length,
                  shares: post.shares,
                  isLiked: post.likedBy.contains(_currentUser?.email),
                  onLike: () => _toggleLike(post),
                  onShare: () => _sharePost(post),
                  onComment: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentFeedScreen(post: post),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('FaceMini App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
        ],
      ),
      body: _listScreen()[_tabBottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabBottomIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          setState(() {
            _tabBottomIndex = value;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String user;
  final String content;
  final int likes;
  final int shares;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onComment;
  final int userId; // Add userId to PostCard

  const PostCard({
    super.key,
    required this.user,
    required this.content,
    required this.likes,
    required this.shares,
    required this.isLiked,
    required this.onLike,
    required this.onShare,
    required this.onComment,
    required this.userId, // Initialize userId
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(userId: userId),
                      ),
                    );
                  },
                  child: Text(
                    user,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: onLike,
                  child: Text(isLiked ? 'Unlike' : 'Like'),
                ),
                TextButton(
                  onPressed: onComment,
                  child: const Text('Comment'),
                ),
                TextButton(
                  onPressed: onShare,
                  child: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
