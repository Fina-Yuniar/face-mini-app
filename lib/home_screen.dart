import 'package:flutter/material.dart';
import 'package:myapp/group_screen.dart';
import 'package:myapp/notification_screen.dart';
import 'package:myapp/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _listScreen =  [
          // Add your pages here
          ListView(
            children: const [
              PostCard(user: 'User 1', content: 'This is a post by user 1.'),
              PostCard(user: 'User 2', content: 'This is a post by user 2.'),
              // Add more PostCard widgets here
            ],
          ),
          const GroupScreen(),
          NotificationScreen(),
          const ProfileScreen(),
        ];
  int _tabBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaceMini App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
        ],
      ),
      body: _listScreen[_tabBottomIndex],
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
        onTap: (value) => {setState(() {
          _tabBottomIndex = value;
        })},
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, // Change the color of the active tab
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String user;
  final String content;

  const PostCard({super.key, required this.user, required this.content});

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
                Text(
                  user,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Like'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Comment'),
                ),
                TextButton(
                  onPressed: () {},
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
