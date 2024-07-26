import 'package:flutter/material.dart';
import 'package:myapp/screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/group_screen.dart';

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Background color for AppBar
          iconTheme: IconThemeData(color: Colors.white), // Icon color
          titleTextStyle: TextStyle(
            color: Colors.white, // Text color
            fontSize: 20, // Font size for title
            fontWeight: FontWeight.bold, // Font weight for title
          ),
        ),
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // Text color for TextButton
          ),
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatScreen(),
        '/groups': (context) => const GroupScreen(),
      },
    );
  }
}
