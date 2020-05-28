import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/widgets/books.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _StateHomeScreen createState() => _StateHomeScreen();
}

class _StateHomeScreen extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference().child("books");
  List<Books> data;

  void _addBook() async {
    if (_formKey.currentState.validate()) {
      dbRef.push().set({
        "title": titleController.text,
        "description": descriptionController.text
      }).then((_) {
        print("done");
      }).catchError((onError) {
        print("err $onError");
      });
    }
  }

  @override
  void initialState() {
    super.initState();
    data = new List();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("KYANON MEMBER"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[_form(), _showData()],
          ),
        ));
  }

  Widget _showData() {
    return StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map values = snap.data.snapshot.value;
            List item = [];
            values.forEach(
              (key, values) {
                item.add({'key': key, ...values});
              },
            );
            return new ListView.builder(
              shrinkWrap: true,
              itemCount: item.length,
              itemBuilder: (BuildContext context, int index) {
                print(item[index]['title']);
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Title:" + item[index]["title"]),
                      Text("Description:" + item[index]["description"]),
                    ],
                  ),
                );
              },
            );
          }
        });
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Enter  Name",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter  Name';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Enter  Description",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter  Description';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text('Submit', style: TextStyle(color: Colors.white)),
            color: Colors.blue,
            onPressed: () {
              _addBook();
            },
          )
        ],
      ),
    );
  }
}
