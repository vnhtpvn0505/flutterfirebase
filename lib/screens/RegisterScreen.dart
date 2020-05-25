import 'package:flutter/material.dart';
import 'package:hello_word/screens/LoginScreen.dart';
import 'package:hello_word/widgets/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  String _email, _password, _firstname, _lastname;
  // gọi table gán vào element
  final userRef = FirebaseDatabase.instance.reference().child('user');
  @override
  void initialState() {
    super.initState();
  }

  bool _validate() {
    final form = _key.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _signUp(BuildContext context) async {
    if (_validate()) {
      await BaseAuth().signUp(email: _email, password: _password);
      print('DONE ');
      //gán giá trị vào db
      await userRef
          .push()
          .set({
            "email": _email,
            "firstname": _firstname,
            "lastname": _lastname,
            "password": _password
          })
          .then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()))
              })
          .catchError((err) => {print("ERROESINUP $err")});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light, accentColor: Colors.black),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Register"),
          ),
          body: Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
              child: SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[showForm()],
                ),
              ))),
    );
  }

  Widget showForm() {
    return new Container(
      child: new Form(
        key: _key,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showInputFirstname(),
            showInputLastname(),
            showInputUsername(),
            showInputPassword(),
            btnRegister()
          ],
        ),
      ),
    );
  }

  Widget showInputFirstname() {
    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: TextFormField(
        onSaved: (value) => _firstname = value.trim(), // gán value to state
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          hintText: "First name ",
        ),
        validator: (value) =>
            value.isEmpty ? 'Firstname can\'t be empty' : null,
      ),
    );
  }

  Widget showInputLastname() {
    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: TextFormField(
        onSaved: (value) => _lastname = value.trim(), // gán value to state
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          hintText: "Last name ",
        ),
        validator: (value) => value.isEmpty ? 'Lastname can\'t be empty' : null,
      ),
    );
  }

  Widget showInputUsername() {
    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: TextFormField(
        onSaved: (value) => _email = value.trim(), // gán value to state
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: "Email ",
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      ),
    );
  }

  Widget showInputPassword() {
    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: TextFormField(
        onSaved: (value) => _password = value.trim(), // gán value to state
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "Password ",
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      ),
    );
  }

  Widget btnRegister() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height * 0.05,
          child: RaisedButton(
            onPressed: () {
              _signUp(context);
            },
            color: Colors.red,
            splashColor: Colors.grey,
            child: Text("Register",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ));
  }
}
