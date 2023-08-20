import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authManagerProvider = ChangeNotifierProvider<AuthManager>(
      (ref) {
    return AuthManager();
  },
);

class AuthManager with ChangeNotifier {
  AuthManager() {
    _firebaseAuth.authStateChanges().listen((user) {
      isLoggedIn = user != null;
      notifyListeners();
    });
  }
  final _firebaseAuth = FirebaseAuth.instance;
  bool isLoggedIn = false;
  　　　
  Future<void> signInWithLine() async {
    // 後ほどここにログイン処理を実装していく
  }
}