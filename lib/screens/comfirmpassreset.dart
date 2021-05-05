import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_login/screens/signin.dart';
import 'package:amplify_login/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ConfirmPassReset extends StatefulWidget {

  final String email;
  final String pass;
  const ConfirmPassReset({Key key, @required this.email, this.pass}) : super(key: key);

  @override
  _ConfirmPassResetState createState() => _ConfirmPassResetState();
}

class _ConfirmPassResetState extends State<ConfirmPassReset> {

  bool isloading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _confirmationCodeController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEnabled = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _confirmationCodeController.addListener(() {
      setState(() {
        _isEnabled = _confirmationCodeController.text.isNotEmpty;
      });
    });
    _passController..addListener(() {
      setState(() {
        _isEnabled = _passController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget ConfirmButton;
    if (isloading) {
      ConfirmButton = Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFfbad20)),
        ),
      );
    } else {
      ConfirmButton = MaterialButton(
        color: kPrimaryColor,
        disabledColor: Colors.deepPurple.shade200,
        onPressed: _isEnabled ? () { String email2; var code2=_confirmationCodeController.text; final String pass2 = _passController.text; _submitPassreset(context, code2, pass2, email2); } : null,
        //onPressed: (String email) => _submitMail(context, email),
        child: Text("RESET"),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confrim Password Reset"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Type your new password and confirmation code sent on ${widget.email} below",
                style: Theme.of(context).textTheme.headline6,
              ),
              new TextFieldContainer(
                child: new TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: _passController,
                  validator: (value) =>
                  value.isEmpty ? "Password is invalid" : null,
                  decoration: new InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: kPrimaryColor,
                      ),
                    ),
                    hintText: 'Enter New Password',
                    labelText: 'New Password (Required)',
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _confirmationCodeController,
                decoration: InputDecoration(labelText: "Confirmation Code"),
                validator: (value) => value.length != 6
                    ? "The confirmation code is invalid"
                    : null,
              ),
              ConfirmButton,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitPassreset(BuildContext context, String code, String password, String email) async {

    //final String password = _passController.text;

    if (_formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        final response = await Amplify.Auth.confirmPassword(username: widget.email, newPassword: password, confirmationCode: code);
        print(response);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', widget.email);
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                'Password Changed Successfully. Try Loggin In'
              )
          )
        );
        _gotoSigninScreen(context);
      }
      on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(e.message),
            )
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  void _gotoSigninScreen(BuildContext context) {
    setState(() {
      isloading = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SigninScreen()));
  }

}
