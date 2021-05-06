import 'package:amplify_login/constants.dart';
import 'package:amplify_login/screens/Signin.dart';
import 'package:amplify_login/screens/emailconfirmscreen.dart';
import 'package:amplify_login/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:amplify_login/widgets/rounded_button.dart';
import 'package:amplify_login/widgets/already_have_acc_check.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isloading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget signupButton;
    if (isloading) {
      signupButton = Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFfbad20)),
        ),
      );
    } else {
      signupButton = RoundedButton(
        text: "SIGN UP",
        press: () { _createAccountOnPressed(context); },
      );
    }
    return Scaffold(
      key: _scaffoldKey,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Material(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SIGNUP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.03),
                    new TextFieldContainer(
                      child: new TextFormField(
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
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        cursorColor: kPrimaryColor,
                        decoration: new InputDecoration(
                          icon: Icon(
                            Icons.mail,
                            color: kPrimaryColor,
                          ),
                          hintText: 'Enter your E-mail',
                          labelText: 'E-mail (Required)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    new TextFieldContainer(
                      child: new TextFormField(
                        controller: _nameController,
                        decoration: new InputDecoration(
                          /*icon: Icon(
                            Icons.mail,
                            color: kPrimaryColor,
                          ),*/
                          hintText: 'Enter your Name',
                          labelText: 'Full Name (Required)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    new TextFieldContainer(
                      child: new TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        controller: _passwordController,
                        validator: (value) => value.isEmpty
                            ? "Password is invalid"
                            : value.length < 9
                            ? "Password must contain at least 8 characters"
                            : null,
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
                          hintText: 'Enter a Password',
                          labelText: 'Password (Required)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    signupButton,
                    SizedBox(
                      height: 20,
                    ),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SigninScreen();
                            },
                          ),
                        );
                      },
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocalIcon(
                          iconSrc: "assets/icons/facebook.svg",
                          press: () {},
                        ),
                        SocalIcon(
                          iconSrc: "assets/icons/twitter.svg",
                          press: () {},
                        ),
                        SocalIcon(
                          iconSrc: "assets/icons/google-plus.svg",
                          press: () {},
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createAccountOnPressed(BuildContext context) async {
    if (_formKey.currentState.validate()) {
    setState(() {
      isloading = true;
    });
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String name = _nameController.text;

    /// In this user attribute, you can define the custom fields associated with the user.
    /// For example birthday, telephone number, etc
    Map<String, String> userAttributes = {
      "email": email,
      "name": name,
    };

    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      if (result.isSignUpComplete) {
        setState(() {
          isloading = false;
        });
        _gotToEmailConfirmationScreen(context, email);
      }
    }
    on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(e.message),
          )
      );
      print(e);
      setState(() {
        isloading = false;
      });
    }
  }
    }

    void _gotToEmailConfirmationScreen(BuildContext context, String email) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              EmailConfirmationScreen(
                email: email,
                name: _nameController.text ?? 'null',
              ),
        ),
      );
    }

}
