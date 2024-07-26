import 'package:flutter/material.dart';
import 'package:myapp/helpers/database_helper.dart';
import 'package:myapp/helpers/shared_preferences_helper.dart';
import 'package:myapp/models/user_model.dart';
import 'message_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<User> _chatUsers = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await SharedPreferencesHelper.getUser();
    setState(() {
      _currentUser = user;
    });
    _loadChatUsers();
  }

  Future<void> _loadChatUsers() async {
    if (_currentUser != null) {
      final chatUsers =
          await DatabaseHelper.instance.getChatUsers(_currentUser!.id!);
      setState(() {
        _chatUsers = chatUsers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _chatUsers.length,
        itemBuilder: (context, index) {
          final user = _chatUsers[index];
          return ChatTile(user: user);
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final User user;

  const ChatTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://placekitten.com/200/300'),
      ),
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: const Text(
          'Last message preview...'), // Update with actual last message
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(userId: user.id!),
          ),
        );
      },
    );
  }
}
