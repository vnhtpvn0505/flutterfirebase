import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/widgets/auth.dart';
import 'package:hello_word/widgets/user.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> data = <String>[
    "Phuc Huynh",
    "Cao Le",
    "Tri Nguyen",
    "Tri Tran",
  ];
  List<User> _userList = new List();

  void getUser() async {
    var db = FirebaseDatabase.instance
        .reference()
        .child("user")
        .child("NSJBylIJhF1kuoZkbRFi")
        .onValue;
    print("DBBBB$db");
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("KYANON MEMBER"),
      ),
      body: Container(
          child: ListView.builder(
        itemCount: data.length,
        itemBuilder: _getListItemMember,
      )),
    );
  }

  Widget _getListItemMember(BuildContext context, int index) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.1, color: Colors.black)),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: FlatButton(
          onPressed: () {
            getUser();
          },
          child: Text(
            data[index],
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}
