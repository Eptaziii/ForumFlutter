import 'dart:convert';

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