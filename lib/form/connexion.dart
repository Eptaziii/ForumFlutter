import 'package:flutter/material.dart';
import 'package:forum/api/login.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/api/users.dart';
import 'package:forum/models/message.dart';
import 'package:forum/models/user.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:forum/utils/secure_storage.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  List<Message> _messages = [];

  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    final credentials = await secureStorage.readCredentials();
    setState(() {
      _emailController.text = credentials["email"] ?? "";
      _passwordController.text = credentials["password"] ?? "";
    });
  }

  Future<void> _loadMessages() async {
    _messages.clear();
    List<Message> mess = [];
    Map<String, dynamic> messages = await getMessages(1);
    int nbPageMax = int.parse(messages["hydra:view"]["hydra:last"].toString().substring(25));
    for (int x = 1; x <= nbPageMax; x++) {
      Map<String, dynamic> messagesPage = await getMessages(x);
      List<dynamic> messagesall = messagesPage["hydra:member"];
      for (int i = 0; i < messagesall.length; i++) {
        Message message = Message.fromMap(messagesall[i]);
        mess.add(message);
      }
      setState(() {
        _messages = mess;
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    await _loadMessages();

    try {
      final response = await login(_emailController.text, _passwordController.text);
      final responseData = json.decode(response.body);

      await secureStorage.saveCredentials(_emailController.text, _passwordController.text);
      await secureStorage.saveToken(responseData['token']);
      await secureStorage.saveData(
        responseData['data']['roles'][0], 
        responseData['data']['nom'], 
        responseData['data']['prenom'], 
        responseData['data']['dateInscription'], 
        responseData['data']['categorie'].toString(), 
        responseData['data']['id'].toString(),
      );

      User user = User(
        id: responseData['data']['id'], 
        nom: responseData['data']['nom'], 
        prenom: responseData['data']['prenom'], 
        email: _emailController.text, 
        role: responseData['data']['roles'][0], 
        dateInscription: responseData['data']['dateInscription'],
        categorie: responseData['data']['categorie']
      );

      setState(() {
        _messages = _messages.where((m) => m.getUser()["@id"].toString().substring(17) == user.getId().toString()).toList();
      });

      final categorie = user.getCategorie();

      if (categorie != user.getMoyenneMessagesInt(_messages.length)) {
        user.setCategorie(categorie);
        await modifierUtilisateurCategorie(user.getId(), user.getCategorie());
      }

      Provider.of<AuthProvider>(context, listen: false).login(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authentification réussie")
        )
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Echec de l'authentification : $e")
        )
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void submitForm() {

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Connexion",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            const Divider(),
            const Padding(padding: EdgeInsets.all(8.0)),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder()
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un email';
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un mot de passe';
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _login();
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, 50)),
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)
                  ), 
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 30
                    ),
                  ),
                ),
          ],
        )
      ),
    );
  }
}