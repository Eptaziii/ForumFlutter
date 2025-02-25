import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forum/form/connexion.dart';
import 'package:forum/form/inscription.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submitForm() {

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 30, 34),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logoForum.png',
              width: 50,
              height: 50,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ]
        ), 
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: const Connexion(),
                  );
                },
              );
            }, 
            tooltip: "Se connecter",
            icon: const Icon(Icons.login)
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: const Inscription(),
                  );
                },
              );
            }, 
            tooltip: "S'inscrire",
            icon: const FaIcon(FontAwesomeIcons.userPen)
          ),
        ],
      ),
      body: Center(
        
      ),
    );
  }
}