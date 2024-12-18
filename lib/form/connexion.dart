import 'package:flutter/material.dart';
import 'package:forum/api/login.dart';
import 'package:forum/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await login(_emailController.text, _passwordController.text);
      await secureStorage.saveCredentials(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authentification réussie")
        )
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/');
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
                border: OutlineInputBorder()
              ),
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
                    fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, 50))
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