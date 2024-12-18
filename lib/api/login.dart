import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> login(String email, String mdp) async {
    final url = Uri.parse('https://s3-4137.nuage-peda.fr/forum/api/authentication_token');

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final data = jsonEncode({
      'email': email,
      'password': mdp,
    });

    final response = await http.post(url, headers: headers, body: data);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Erreur de connexion : ${response.reasonPhrase}');
    }
  }