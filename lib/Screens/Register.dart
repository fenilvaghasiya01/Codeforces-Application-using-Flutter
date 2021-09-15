import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/buildSnackbar.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String _userName;
  TextEditingController _controller = new TextEditingController();

  _setUser(String userName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userName', userName);
  }

  _userExist(String userName) async {
    try {
      String _url = userInfo + userName;
      var response = await http.get(_url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        _setUser(userName);
        //do something
        Navigator.pop(context); // idk its right way or not but its working :)

        HomePage _homePage = new HomePage(userName);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _homePage),
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
    print('Built - Register');
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    Widget _inputField = TextField(
      cursorColor: Theme.of(context).cursorColor,
      controller: _controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 10.0),
          child: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
        ),
        //
        hintText: 'Codeforces Handle',
        //
      ),
      inputFormatters: [FilteringTextInputFormatter.deny(" ")],
    );

    // button
    Widget _button = RaisedButton(
      elevation: 5.0,
      color: Theme.of(context).primaryColor,
      child: Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          //fontSize: height * 0.025,
          fontSize: 18.0,
          //letterSpacing: 0.4,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width),
      ),
      onPressed: () {
        _userName = _controller.text;
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
        leading: Icon(
          Icons.account_box,
        ),
        title: Text('Register'),
      ),
      body: SafeArea(
        child: _isLoading == true
            ? circularIndicator()
            : Padding(
                padding:
                    EdgeInsets.only(left: width * 0.15, right: width * 0.15),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.20,
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
                      SizedBox(
                        height: 1000,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// we have to add circularIndicator after user presses submit
// if user found then go to homepage else render the same page and snackbar

// in username , emojis are being accepted as username ( from cf api even if there is no user )
