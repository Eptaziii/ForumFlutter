import 'dart:convert';

import 'package:forum/models/user.dart';
import 'package:forum/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

Future<int> supprimerUtilisateur(int id) async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/users/$id');

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

Future<int> modifierUtilisateur(int id, String role) async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/users/$id');

  final token = await SecureStorage().readToken();

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/merge-patch+json',
    'Authorization': 'Bearer $token',
  };

  final data = jsonEncode({
    'roles': [role],
  });

  final response = await http.patch(url, headers: headers, body: data);
  if (response.statusCode == 200) {
    return 1;
  } else {
    return 2;
  }
}

Future<List<User>?> getAllUsers() async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/users');

  final token = await SecureStorage().readToken();

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<User> users = [];
    for (dynamic u in data) {
      users.add(User.fromMap(u));
    }
    return users;
  } else {
    return null;
  }
}