import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static const _keyToken = 'token';
  static const _keyRole = 'role';
  static const _keyNom = 'nom';
  static const _keyPrenom = 'prenom';
  static const _keyDateInscription = 'dateInscription';
  static const _keyId = 'id';

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<void> saveData(String role,String nom, String prenom, String dateInscription, String id) async {
    await _storage.write(key: _keyRole, value: role);
    await _storage.write(key: _keyNom, value: nom);
    await _storage.write(key: _keyPrenom, value: prenom);
    await _storage.write(key: _keyDateInscription, value: dateInscription);
    await _storage.write(key: _keyId, value: id);
  }

  Future<Map<String, String?>> readCredentials() async {
    String? email = await _storage.read(key: _keyEmail);
    String? password = await _storage.read(key: _keyPassword);
    return {
      'email': email,
      'password': password,
    };
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _keyToken); 
  }

  Future<Map<String, String?>> readData() async {
    String? role = await _storage.read(key: _keyRole);
    String? nom = await _storage.read(key: _keyNom);
    String? prenom = await _storage.read(key: _keyPrenom);
    String? dateInscription = await _storage.read(key: _keyDateInscription);
    String? id = await _storage.read(key: _keyId);
    return {
      'role': role,
      'nom': nom,
      'prenom': prenom,
      'dateInscription': dateInscription,
      'id': id
    };
  }

  Future<void> deleteCredentials() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyPassword);
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRole);
    await _storage.delete(key: _keyNom);
    await _storage.delete(key: _keyPrenom);
    await _storage.delete(key: _keyDateInscription);
    await _storage.delete(key: _keyId);
  }
}