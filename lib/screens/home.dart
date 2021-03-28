import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_login/screens/entry.dart';
import 'package:flutter/material.dart';
import 'package:amplify_login/widgets/rounded_button.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AfterPlay'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text('Home Page'),
            ),
            RoundedButton(
              color: Colors.redAccent,
              text: 'Logout/Signout',
              press: () {
                _signout(context);
              },
            ),
          ],
        ),
      ),
      //backgroundColor: Colors.black12,
    );
  }

  Future<void> _signout(BuildContext context) async {
    try {
      Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return Entry();
      },
    )
    );
  }
}
