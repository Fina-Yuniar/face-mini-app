import 'package:flutter/material.dart';
import 'package:myapp/helpers/database_helper.dart';
import 'package:myapp/helpers/shared_preferences_helper.dart';
import 'package:myapp/models/group_message_model.dart';
import 'package:myapp/models/user_model.dart';

class GroupChatScreen extends StatefulWidget {
  final int groupId;
  final String groupName;

  const GroupChatScreen(
      {super.key, required this.groupId, required this.groupName});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<GroupMessage> _messages = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMessages();
  }

  Future<void> _loadCurrentUser() async {
    final user = await SharedPreferencesHelper.getUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _loadMessages() async {
    final messages =
        await DatabaseHelper.instance.getGroupMessages(widget.groupId);
    setState(() {
      _messages = messages;
    });
  }

  Future<void> _sendMessage(String message) async {
    if (_currentUser != null && message.isNotEmpty) {
      final newMessage = GroupMessage(
        groupId: widget.groupId,
        sender: '${_currentUser!.firstName} ${_currentUser!.lastName}',
        message: message,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.insertGroupMessage(newMessage);
      _messageController.clear();
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sender ==
                    '${_currentUser?.firstName} ${_currentUser?.lastName}';
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
                          message.sender,
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
