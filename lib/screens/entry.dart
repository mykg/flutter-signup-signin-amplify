import 'package:amplify_login/screens/home.dart';
import 'package:flutter/material.dart';
import 'welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Entry extends StatefulWidget {
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {

  var email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
         child:  email == null ? Welcome() : Home()
         //child: Welcome(),
       ),
    );
  }

  getemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('email'));
    email = prefs.getString('email');
  }
}
