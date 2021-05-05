import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_login/constants.dart';
import 'package:amplify_login/screens/comfirmpassreset.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordScreen extends StatefulWidget {

  final String email;
  const ForgotPasswordScreen({Key key, this.email}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  bool isloading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEnabled = false;


  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isEnabled = _emailController.text.isNotEmpty;
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
        onPressed: _isEnabled ? () { String email2; _submitMail(context, email2); } : null,
        //onPressed: (String email) => _submitMail(context, email),
        child: Text("Recover"),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Recover Passowrd"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Type your registered email below",
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                  final regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Enter a valid email';
                  } else {
                    return null;
                  }
                },
              ),
              ConfirmButton,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitMail(BuildContext context, String email) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        final email = _emailController.text.trim();

        final response = await Amplify.Auth.resetPassword(username: email,);
        print(response);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email);
          _gotoValScreen(context,);
          setState(() {
            isloading = false;
          });
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

  void _gotoValScreen(BuildContext context) {
    final email = _emailController.text.trim();
    setState(() {
      isloading = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConfirmPassReset(email: email, pass: '',)));
  }
}
