import 'package:flutter/material.dart';
import 'package:hello_word/screens/HomeScreen.dart';
import 'package:hello_word/screens/RegisterScreen.dart';
import 'package:hello_word/widgets/auth.dart';

//Statefull  requires at least two class:
//StatefullWidget   create State class
class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  String _email, _password, _errorMessage;
  bool _isLoginForm, _isLoading;

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

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = false;
  }

  void _signIn(BuildContext context) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    print("object");
    if (_validate()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          print('tryecatch');
          //userId = await widget.auth.signIn(email: _email, password: _password);
          await widget.auth
              .signIn(email: _email, password: _password)
              .then((value) => {
                    userId = value.uid,
                    print('Signed in: $userId'),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()))
                  })
              .catchError((err) {
            {
              print("LOGIN ERROR $err");
            }
          });
          print('Signed in: $userId');
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _key.currentState.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:
            ThemeData(brightness: Brightness.dark, accentColor: Colors.white),
        home: Scaffold(
          body: Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
              child: SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[showLogo(), showForm(), isLoadingForm()],
                ),
              )),
        ));
  }

  Widget isLoadingForm() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 70.0),
      child: Image(
        image: AssetImage("assets/logo.png"),
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
          btnRegister(),
          showErrorMessage()
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
