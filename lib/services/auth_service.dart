import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile']);

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      if (kDebugMode) {
        print("User signed out");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error signing out: $error");
      }
    }
  }
}
