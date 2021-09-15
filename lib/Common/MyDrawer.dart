import 'package:codeforces/Screens/HomePage.dart';
import 'package:codeforces/Screens/drawer/MyUnsolved.dart';
import 'package:codeforces/Screens/drawer/Statistics.dart';
import 'package:codeforces/Screens/drawer/UserSubmissions.dart';
import 'package:codeforces/Screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:codeforces/Screens/drawer/ResetHandle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName;

  @override
  void initState() {
    userName = globalUserName;
    super.initState();
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }

  @override
  Widget build(BuildContext context) {
    print("Build - Drawer");
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    return Drawer(
      elevation: 20.0,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 22.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    // alignment: Alignment.centerLeft,
                    child: Text(
                      "Hello , " + userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    // alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Icon(
                        isDarkMode
                            ? Icons.wb_sunny_rounded
                            : Icons.nights_stay_rounded,
                        color: Colors.white,
                      ),
                      onTap: () {
                        changeTheme(
                            Provider.of<Settings>(context, listen: false)
                                    .isDarkMode
                                ? false
                                : true,
                            context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.fileCode,
              ),
              title: Text('My Submissions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserSubmissions(this.userName, isDarkMode)),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.stickyNote,
                size: 20,
              ),
              title: Text('My Unsolved'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyUnsolved(isDarkMode)),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.userPlus,
                size: 20,
              ),
              title: Text('Statistics'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Statistics()),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.userEdit,
                size: 20,
              ),
              title: Text('Reset Handle'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetHandle()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
