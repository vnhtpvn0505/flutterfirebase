import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  List<String> data = <String>[
    "Phuc Huynh",
    "Cao Le",
    "Tri Nguyen",
    "Tri Tran",
  ];

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
        child: Text(
          data[index],
          style: TextStyle(fontSize: 18),
        ));
  }
}
