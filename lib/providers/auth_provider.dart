import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_app2/providers/base_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationProvider extends BaseProvider {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool loading = false;

  Future<bool> login(String email, String password) async {
    setBusy(true);
    UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCred.user != null) {
      setBusy(false);
      return true;
    } else {
      setBusy(false);
      return false;
    }
  }

  Future<bool> createAccount(String email, String password, String userName) async {
    UserCredential userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCred.user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .add({"name": userName, "email": email, "user_uid": userCred.user!.uid});

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetpassword(String email) async {
    setBusy(true);
    await firebaseAuth.sendPasswordResetEmail(email: email);

    setBusy(false);
    return true;
  }

  Future<bool> logout() async {
    firebaseAuth.signOut();
    return true;
  }
}
