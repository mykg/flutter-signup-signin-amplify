import 'package:amplify_login/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class EmailConfirmationScreen extends StatefulWidget {

  final String email;
  final String name;

  EmailConfirmationScreen({Key key, @required this.email, this.name})
      : super(key: key);

  @override
  _EmailConfirmationScreenState createState() => _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {

  bool isloading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _confirmationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Widget ConfirmButton;
    if (isloading) {
      ConfirmButton = Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFfbad20)),
        ),
      );
    } else {
      ConfirmButton = RaisedButton(
        onPressed: () {
          _submitCode(context);
        },
        child: Text("CONFIRM"),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confirm your email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "An email confirmation code is sent to ${widget.email}. Please type the code to confirm your email.",
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _confirmationCodeController,
                decoration: InputDecoration(labelText: "Confirmation Code"),
                validator: (value) => value.length != 6
                    ? "The confirmation code is invalid"
                    : null,
              ),
              ConfirmButton
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitCode(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      final confirmationCode = _confirmationCodeController.text;
      try {
        final SignUpResult response = await Amplify.Auth.confirmSignUp(
          username: widget.email,
          confirmationCode: confirmationCode,
        );
        if (response.isSignUpComplete) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('name', widget.name);
          prefs.setString('email', widget.email);
          _gotoMainScreen(context);
          setState(() {
            isloading = false;
          });
        }
      }

      // on AuthError
      catch (e) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(e.cause),
          ),
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  void _gotoMainScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
  }

}
