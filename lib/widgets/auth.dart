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
    print("USEr: $user.id");
  }
}
