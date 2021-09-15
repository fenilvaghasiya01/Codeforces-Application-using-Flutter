// IT IS A COPY OF REGISTER.DART

import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/buildSnackbar.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Screens/profile/Profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../settings.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  TextEditingController _controller = new TextEditingController();

  _userExist(String userName) async {
    try {
      String _url = userInfo + userName;
      var response = await http.get(_url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        Navigator.of(context)
            .pop(); // idk its right way or not but its working :)

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(userName, false),
          ),
        );
      } else {
        throw new Exception("error occured");
      }
    } catch (e) {
      print('----------------------------------User not found');
      setState(() {
        _isLoading = false;
        _scaffoldkey.currentState.hideCurrentSnackBar();
        _scaffoldkey.currentState
            .showSnackBar(buildSnackBar("User " + userName + " not found"));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    Widget _inputField = TextField(
      controller: _controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 10.0),
          child: Icon(
            Icons.person,
            color: isDarkMode ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
        hintText: 'Codeforces Handle',
      ),
      inputFormatters: [FilteringTextInputFormatter.deny(" ")],
    );

    // button
    Widget _button = RaisedButton(
      elevation: 5.0,
      color: Theme.of(context).primaryColor,
      child: Text(
        'Confirm',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width),
      ),
      onPressed: () {
        String _userName = _controller.text;
        FocusManager.instance.primaryFocus.unfocus();
        _controller.clear();
        setState(() {
          _isLoading = true;
          _userExist(_userName);
        });
      },
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: _isLoading
          ? circularIndicator()
          : Padding(
              padding: EdgeInsets.only(left: width * 0.15, right: width * 0.15),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.2,
                    ),
                    _inputField,
                    SizedBox(
                      height: 35.0,
                    ),
                    Container(
                      //height: height * 0.08,
                      height: 50.0,
                      width: double.infinity,
                      //color: Theme.of(context).primaryColor,
                      child: _button,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// in username , emojis are being accepted as username ( from cf api even if there is no user )
