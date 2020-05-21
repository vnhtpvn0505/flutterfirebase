import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  List<String> data = <String>[
    "Phuc Huynh",
    "Cao Le",
    "Tri Nguyen",
    "Tri Tran",
  ];

  void getUser() {
    var db = FirebaseDatabase.instance.reference().child("user");
    db.once().then((DataSnapshot snapshot) {
      var values = snapshot.value;

      values.forEach((key, value) {
        var ls = value.toString();
        print("LS $ls");
      });
    });
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
