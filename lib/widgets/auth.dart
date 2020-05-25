import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future signUp({
    String email,
    String password,
  }) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("USEr: $user");
  }

  @override
  Future getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future signIn({String email, String password}) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      print("LOGINI: $user");
      return user.uid;
    } catch (e) {
      print("ERROR LOGIN $e");
    }
  }
}
