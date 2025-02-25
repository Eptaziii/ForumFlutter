// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<int> registerUser(String nom, String prenom, String email, String mdp) async {
    Uri url = Uri.parse("https://s3-4137.nuage-peda.fr/forum/api/users");
    var headers = {'Content-Type': 'application/json'};
    String data = json.encode({
      'email': email,
      'password': mdp,
      'nom': nom,
      'prenom': prenom,
    });

    try {
      var reponse = await http.post(url, headers: headers, body: data);
      if (reponse.statusCode == 201) {
        return reponse.statusCode;
      } else {
        print("Echec de la requête : ${reponse.statusCode}, Réponse : ${reponse.body}");
        return reponse.statusCode;
      }
    } catch (e) {
      print("Exception lors de la reqûete : $e");
      return 0;
    }
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }
    try {
      print("${_nomController.text}, ${_prenomController.text}, ${_emailController.text}, ${_passwordController.text}");
      int result = await registerUser(
        _nomController.text, 
        _prenomController.text, 
        _emailController.text, 
        _passwordController.text
      );
      Navigator.of(context).pop();
      if (result == 201) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Inscription réussie !"), 
            content: Text("Bonjour ${_prenomController.text} ${_nomController.text}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true).pop();
                }, 
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Echec de l'inscription !"), 
            content: Text("Une erreur est survenue : $result. Veuillez réessayer"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Echec de l'inscription !"), 
          content: Text("Une erreur est survenue : $e. Veuillez réessayer"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
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
              "Inscription",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            const Divider(),
            const Padding(padding: EdgeInsets.all(8.0)),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder()
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            TextFormField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder()
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prénom';
                }
                return null;
              },
            ),
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
            const Padding(padding: EdgeInsets.all(8.0)),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder()
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un mot de passe';
                }
                return null;
              },
              onChanged: (value) => setState(() {}),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "• 12 caractères",
                      style: TextStyle(color: _passwordController.text.length >= 12 ? Colors.green : Colors.red),
                    ),
                  ]
                ),
                Row(
                  children: [
                    Text(
                      "• minuscule",
                      style: TextStyle(color: _passwordController.text.contains(RegExp(r'[a-z]')) ? Colors.green : Colors.red),
                    ),
                  ]
                ),
                Row(
                  children: [
                    Text(
                      "• majuscule",
                      style: TextStyle(color: _passwordController.text.contains(RegExp(r'[A-Z]')) ? Colors.green : Colors.red),
                    ),
                  ]
                ),
                Row(
                  children: [
                    Text(
                      "• chiffre",
                      style: TextStyle(color: _passwordController.text.contains(RegExp(r'[0-9]')) ? Colors.green : Colors.red),
                    ),
                  ]
                ),
                Row(
                  children: [
                    Text(
                      "• caractères spéciaux (*#%@/-_\$?!&.,;:)",
                      style: TextStyle(color: _passwordController.text.contains(RegExp(r'[*#%@/-_\$?!&.,;:]')) ? Colors.green : Colors.red),
                    ),
                  ]
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_passwordController.text.length >= 12 && _passwordController.text.contains(RegExp(r'[a-z]')) && _passwordController.text.contains(RegExp(r'[A-Z]')) && _passwordController.text.contains(RegExp(r'[0-9]')) && _passwordController.text.contains(RegExp(r'[*#%@/-_\$?!&.,;:]'))) {
                    submitForm();
                  } else {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Erreur mot de passe"),
                          content: const Text("Veuillez entrer un mot de passe valide"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, 50))
              ), 
              child: const Text(
                'S\'inscrire',
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