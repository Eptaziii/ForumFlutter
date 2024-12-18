import 'package:flutter/material.dart';
import 'package:forum/myhomepage.dart';

void main() {
  runApp(const MyApp());
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
      },
    );
  }
}
