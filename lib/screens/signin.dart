import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_login/screens/home.dart';
import 'package:amplify_login/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:amplify_login/widgets/rounded_pass.dart';
import 'package:amplify_login/widgets/rounded_input.dart';
import 'package:amplify_login/widgets/rounded_button.dart';
import 'package:amplify_login/widgets/already_have_acc_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key key}) : super(key: key);
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool isloading = false;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Material(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SizedBox(height: size.height * 0.03),
                  new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);

                      if (!regExp.hasMatch(value)) {
                        return 'Enter a valid mail';
                      } else {
                        return null;
                      }
                    },
                    decoration: new InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF2821B5),
                        ),
                      ),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      labelText: 'Enter E-mail or Phone',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) =>
                    value.isEmpty ? "Password is invalid" : null,
                    decoration: new InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF2821B5),
                        ),
                      ),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      labelText: 'Enter Password',
                    ),
                  ),
                  RoundedButton(
                    text: "LOGIN",
                    press: () {
                      _loginButtonOnPressed(context);
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignupScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
    setState(() {
      isloading = true;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final response = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (response.isSignedIn) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        setState(() {
          isloading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Home(),
          ),
        );
      }
    }
    //  on AuthError
    catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: //Text(e.cause),
            Text("Problem logging in. Please try again.")),
      );
      setState(() {
        isloading = false;
      });
    }
    }
  }

}
