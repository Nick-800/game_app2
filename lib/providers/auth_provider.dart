import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCred.user != null) {
      return true;
    } else {
      return false;
    }
  }
}
