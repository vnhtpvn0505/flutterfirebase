import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/screens/LoginScreen.dart';
import 'package:hello_word/widgets/books.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _StateHomeScreen createState() => _StateHomeScreen();
}

class _StateHomeScreen extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name, desc;
  final dbRef = FirebaseDatabase.instance.reference().child("books");
  List<Books> data;
  bool up;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _addBook() async {
    if (_formKey.currentState.validate()) {
      dbRef.push().set({
        "title": titleController.text,
        "description": descriptionController.text
      }).then((_) {
        print("done");
        titleController.clear();
        descriptionController.clear();
      }).catchError((onError) {
        print("err $onError");
      });
    }
  }

  void _updateBook(id) async {
    await dbRef.child(id).update({
      "title": titleController.text,
      'description': descriptionController.text
    }).then((_) => {print('UpdateDone')});
  }

  void _deleteBook(id) async {
    await dbRef.child(id).remove().then((_) => {print("Remove Dataa ")});
  }

  @override
  void initialState() {
    super.initState();
    data = new List();
    up = false;
    name = "";
    desc = "";
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("BOOK STORE"),
          leading: Text(""),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _firebaseAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(
                Icons.launch,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[_form(), _showData()],
            ),
          ),
        ));
  }

  Widget _showData() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: StreamBuilder(
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
                    return Container(
                        margin: EdgeInsets.only(top: 5),
                        child: FlatButton(
                          onPressed: () {
                            titleController = item[index]["title"];
                          },
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _itemBooks(
                                  item[index]["title"],
                                  item[index]["description"],
                                  item[index]['key'])
                            ],
                          ),
                        ));
                  },
                );
              } else {
                return new Container(
                  child: CircularProgressIndicator(
                    value: 2.0,
                  ),
                );
              }
            }));
  }

  Widget _itemBooks(String title, String desc, String id) {
    return Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://i.picsum.photos/id/1051/200/300.jpg'),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                )),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          up:
                          true;
                        });
                        _updateBook(id);
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _deleteBook(id);
                      },
                      icon: Icon(
                        Icons.remove,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
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
            onSaved: (val) {
              setState(() {
                name:
                val;
              });
            },
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
            onSaved: (val) {
              setState(() {
                name:
                val;
              });
            },
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
