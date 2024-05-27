import 'package:flutter/material.dart';
import 'package:myapp/chat_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'comment_feed_screen.dart';
import 'profile_screen.dart';
import 'chat_messenger_screen.dart';
import 'group_screen.dart';

// Fina Yuniar - 411211180
// Djihan Al Madani - 411211052
// Siska Mailana - 411211071

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceMini App UI Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/comments': (context) => const CommentFeedScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => ChatScreen(),
        '/chat_messenger': (context) => const ChatMessengerScreen(),
        '/groups': (context) => const GroupScreen(),
      },
    );
  }
}
