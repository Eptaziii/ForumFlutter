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