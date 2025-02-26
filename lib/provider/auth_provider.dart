import 'package:flutter/material.dart';
import 'package:forum/models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  
  void login(User utilisateur) {
    _isLoggedIn = true;
    _user = utilisateur;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
