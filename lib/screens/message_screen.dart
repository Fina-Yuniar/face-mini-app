import 'package:flutter/material.dart';
import 'package:myapp/helpers/database_helper.dart';
import 'package:myapp/helpers/shared_preferences_helper.dart';
import 'package:myapp/models/user_message.dart';
import 'package:myapp/models/user_model.dart';

class MessageScreen extends StatefulWidget {
  final int userId;

  const MessageScreen({super.key, required this.userId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<UserMessage> _messages = [];
  User? _currentUser;
  User? _chatUser;

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
    _loadChatUser();
  }

  Future<void> _loadChatUser() async {
    final user = await DatabaseHelper.instance.getUserById(widget.userId);
    setState(() {
      _chatUser = user;
    });
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_currentUser != null && _chatUser != null) {
      final messages = await DatabaseHelper.instance
          .getUserMessages(_currentUser!.id!, widget.userId);
      setState(() {
        _messages = messages;
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (_currentUser != null && message.isNotEmpty) {
      final newMessage = UserMessage(
        senderId: _currentUser!.id!,
        receiverId: widget.userId,
        message: message,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.insertUserMessage(newMessage);
      _messageController.clear();
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatUser != null
            ? '${_chatUser!.firstName} ${_chatUser!.lastName}'
            : 'Chat'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == _currentUser?.id;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[200] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMe ? 'You' : _chatUser?.firstName ?? 'Other user',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(message.message),
                        const SizedBox(height: 5),
                        Text(
                          message.timestamp.toLocal().toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _sendMessage(_messageController.text),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
