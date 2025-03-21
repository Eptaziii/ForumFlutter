import 'dart:convert';

import 'package:forum/models/categorieUser.dart';
import 'package:forum/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<CategorieUser>?> getAllCategories() async {
  final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/categorie_users');

  final token = await SecureStorage().readToken();

  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<CategorieUser> users = [];
    for (dynamic c in data) {
      users.add(CategorieUser.fromMap(c));
    }
    return users;
  } else {
    return null;
  }
}