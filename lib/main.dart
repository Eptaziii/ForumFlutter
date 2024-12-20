import 'package:flutter/material.dart';
import 'package:forum/page/myhomepage.dart';
import 'package:forum/page/profile.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forum',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black87,
        ),
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Forum de Geek'),
        '/profile': (context) => const Profile(title: 'Profile'),
      },
    );
  }
}
