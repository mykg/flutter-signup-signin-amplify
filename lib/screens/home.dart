import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_login/screens/entry.dart';
import 'package:flutter/material.dart';
import 'package:amplify_login/widgets/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AfterPlay'),
        automaticallyImplyLeading: false,
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
                delemail();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signout(BuildContext context) async {
    try {
      await Amplify.Auth.signOut().then((_)  {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Entry();
          },
          )
        );
      } );
    }
    on AuthException catch (e) {
      //ScaffoldMessenger.showSnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.message),
      )
      );
    }
  }

  delemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('email'));
    email = prefs.getString('null');
  }
}
