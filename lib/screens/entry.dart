import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_login/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_login/amplifyconfiguration.dart';
import 'welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Entry extends StatefulWidget {
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {

  //final amplify = Amplify();
  bool _amplifyConfigured = false;

  @override
  void initState(){
    super.initState();
    _configureAmplify();
    _getemail();
  }

  var email;
  void _configureAmplify() async {

    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();

    try {
      Amplify.addPlugins([auth, analytics]);
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
         child:  _amplifyConfigured ? (email == null ? Welcome() : Home()) : Welcome(),
       ),
    );
  }

  _getemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('email'));
    email = prefs.getString('email');
  }
}
