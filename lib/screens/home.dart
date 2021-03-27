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
              press: () {},
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black12,
    );
  }
}
