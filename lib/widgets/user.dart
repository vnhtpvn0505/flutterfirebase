import 'package:firebase_database/firebase_database.dart';

class User {
  String email;
  String firstname;
  String lastname;
  String password;

  User({String emai, String firstname, String lastname, String password});
  factory User.fromJson(Map<String, dynamic> json) {
    var user = User(
        emai: json["email"] as String,
        firstname: json["firstname"] as String,
        lastname: json["lastname"] as String,
        password: json["password"] as String);
    return user;
  }
}
