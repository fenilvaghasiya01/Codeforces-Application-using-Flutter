import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Register.dart';
import 'HomePage.dart';

// authentication class
// if 1st time then ask username (register)
// else redirect to home page directly

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String _userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  _getUserName() async {
    print('---------------------getting user name');
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _userName = pref.getString('userName') ?? "";
    });
    print('-----------------------got user name');
  }

//  int count = 0;
  Widget build(BuildContext context) {
    print('------------------------------------AUTHENTICATE BUILD');
    if (_userName == null) {
      return Scaffold(
        appBar: AppBar(),
        body: circularIndicator(),
      );
    }
    return _userName == "" ? Register() : HomePage(_userName);
  }
}

// in some cases it is showing "new user" twice because // mainly while restarting app
