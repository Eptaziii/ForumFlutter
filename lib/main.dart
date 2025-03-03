import 'package:flutter/material.dart';
import 'package:forum/page/list_users_page.dart';
import 'package:forum/page/message_page.dart';
import 'package:forum/page/messages_user_page.dart';
import 'package:forum/page/home_page.dart';
import 'package:forum/page/profil_page.dart';
import 'package:forum/page/user_page.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('fr_FR', null);
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
        primaryColor: Colors.black87,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black87,
          colorScheme: ThemeData.light().colorScheme.copyWith(
            primary: Colors.black87
          )
        ),
        colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: Colors.black87
        ),
        useMaterial3: false,
      ),
      home: const SplashHomePage(title: "Forum de Geek"),
      routes: {
        '/home': (context) => const MyHomePage(title: 'Forum de Geek'),
        '/profil': (context) => const Profile(title: 'Profil'),
        '/messagesUser': (context) => const MessagesUser(title: 'Vos messages'),
        '/message': (context) => const MessagePage(),
        '/liste_users': (context) => const ListUsersPage(),
        '/user': (context) => const UserPage(),
      },
    );
  }
}

class SplashHomePage extends StatefulWidget {
  const SplashHomePage({super.key, required this.title});

  final String title;

  @override
  State<SplashHomePage> createState() => _SplashHomePageState();
}

class _SplashHomePageState extends State<SplashHomePage> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.popAndPushNamed(context, '/home');
    },);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("assets/images/logoForum.png", height: 200, width: 200,),
            LoadingAnimationWidget.newtonCradle(
              color: Colors.white, 
              size: 100
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chargement des données ...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
