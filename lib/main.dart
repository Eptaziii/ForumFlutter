import 'package:flutter/material.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/models/message.dart';
import 'package:forum/page/myhomepage.dart';
import 'package:forum/page/profile.dart';
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
        useMaterial3: false,
      ),
      home: const SplashHomePage(title: "Forum de Geek"),
      routes: {
        '/home': (context) => const MyHomePage(title: 'Forum de Geek'),
        '/profile': (context) => const Profile(title: 'Profile'),
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
  List<Message> _messages = [];
  bool isDataReady = false;
  int nb = 0;

  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    await _loadMessages();
    setState(() {
      isDataReady = true;
    });
    Navigator.popAndPushNamed(context, '/home', arguments: {"messages":_messages});
  }

  Future<void> _loadMessages() async {
    Map<String, dynamic> messages = await getMessages(1);
    int nbPageMax = int.parse(messages["hydra:view"]["hydra:last"].toString().substring(25));
    for (int x = 1; x <= nbPageMax; x++) {
      Map<String, dynamic> messagesPage = await getMessages(x);
      List<dynamic> messagesall = messagesPage["hydra:member"];
      for (int i = 0; i < messagesall.length; i++) {
        Message message = Message(
          messagesall[i]["id"], 
          messagesall[i]["titre"], 
          messagesall[i]["datePoste"], 
          messagesall[i]["contenu"], 
          messagesall[i]["user"],
          messagesall[i]["parent"],
        );
        setState(() {
          _messages.add(message);
          nb++;
        });
      }
    }
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
            Text(nb.toString()),
          ],
        ),
      ),
    );
  }
}
