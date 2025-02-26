import 'dart:convert';

import 'package:forum/models/message.dart';
import 'package:forum/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getMessages(int page) async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/messages?page=$page');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erreur de récupération des messages : ${response.reasonPhrase}');
  }
}

Future<int> ajouterMessage(String titre, String message, int id, String type, int? idParent) async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/messages');

  final token = await SecureStorage().readToken();

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final data = jsonEncode({
    'titre': titre,
    'contenu': message,
    'user': "/forum/api/users/$id",
    "modified": false,
    "parent": type == "Réponse"
        ? "/forum/api/messages/$idParent"
        : null
  });
  
  final response = await http.post(url, headers: headers, body: data);
  if (response.statusCode == 201) {
    return 1;
  } else {
    return 2;
  }
}

Future<int> modifierMessage(String titre, String message, int idMessage) async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/messages/${idMessage.toString()}');

  final token = await SecureStorage().readToken();

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/merge-patch+json',
    'Authorization': 'Bearer $token',
  };

  final data = jsonEncode({
    'titre': titre,
    'contenu': message,
    'datePoste': DateTime.now().toIso8601String(),
    "modified": true
  });

  final response = await http.patch(url, headers: headers, body: data);
  print(response.reasonPhrase);
  print(response.statusCode);
  if (response.statusCode == 200) {
    return 1;
  } else {
    return 2;
  }
}

Future<int> supprimerMessage(int idMessage) async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/messages/${idMessage.toString()}');

  final token = await SecureStorage().readToken();

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.delete(url, headers: headers);
  if (response.statusCode == 204) {
    return 1;
  } else {
    return 2;
  }
}