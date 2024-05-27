import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final List<ChatModel> chatList = [
    ChatModel(
        'John Doe', 'Hey, how are you?', 'https://placekitten.com/200/300'),
    ChatModel('Jane Smith', 'Are you coming to the party?',
        'https://placekitten.com/200/300'),
    ChatModel('Michael Johnson', 'Let\'s catch up sometime!',
        'https://placekitten.com/200/300'),
    // Tambahkan lebih banyak contoh chat jika diperlukan
  ];

  ChatScreen({super.key});

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
            // navigation back
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          return ChatTile(chatModel: chatList[index]);
        },
      ),
    );
  }
}

class ChatModel {
  final String name;
  final String lastMessage;
  final String avatarUrl;

  ChatModel(this.name, this.lastMessage, this.avatarUrl);
}

class ChatTile extends StatelessWidget {
  final ChatModel chatModel;

  const ChatTile({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(chatModel.avatarUrl),
      ),
      title: Text(chatModel.name),
      subtitle: Text(chatModel.lastMessage),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // navigate to chat messengger screen
        Navigator.pushNamed(
          context,
          '/chat_messenger',
        );
      },
    );
  }
}
