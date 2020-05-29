import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/screens/HomeScreen.dart';
import 'package:hello_word/screens/RegisterScreen.dart';

//Statefull  requires at least two class:
//StatefullWidget   create State class
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();
  String _email, _password;

  @override
  void initialState() {
    super.initState();
  }

  bool _validate() {
    final form = _key.currentState;
    //form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _signIn(BuildContext context) async {
    if (_validate()) {
      try {
        AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
            email: _email, password: _password);

        FirebaseUser user = result.user;
        if (user.email == 'vnhtpvn0505@gmail.com') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } catch (e) {
        print("LOGINFAIL");
      }
    }
    print("LOGIN");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:
            ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
        home: Scaffold(
          body: Padding(
            padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[showLogo(), showForm()],
            ),
          ),
        ));
  }

  Widget showLogo() {
    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 70.0),
      child: Image(
        image: AssetImage("assets/blogo.png"),
      ),
    );
  }

  Widget showForm() {
    return new Container(
        child: new Form(
      key: _key,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          showInputUsername(),
          showInputPassword(),
          btnLogin(),
          btnRegister()
        ],
      ),
    ));
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
      padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
      child: TextFormField(
        obscureText: true,
        onSaved: (value) => _password = value.trim(), // gán value to state
        decoration: const InputDecoration(hintText: "Password"),
        validator: (value) => value.isEmpty ? "Password can\'t be empty" : null,
      ),
    );
  }

  Widget btnLogin() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height * 0.05,
          child: RaisedButton(
            onPressed: () {
              _signIn(context);
            },
            color: Colors.red,
            splashColor: Colors.grey,
            child: Text("LOGIN",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ));
  }

  Widget btnRegister() {
    return new FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: new Text(
        "Create an account ?",
        style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      ),
    );
  }
}

//using statefull widget maintain state can change during the lifetime of the widget
