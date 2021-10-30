import 'package:codeforces/Common/MyDrawer.dart';
import 'package:codeforces/Screens/profile/IndexWiseSubmissions.dart';
import 'package:codeforces/Screens/profile/ParticipationGraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'UserInfo.dart';

class Profile extends StatefulWidget {
  final String userName;
  final bool isMainScreen;
  Profile(this.userName, this.isMainScreen);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    Color containerColor =
        isDarkMode ? Theme.of(context).primaryColor : Colors.white;
    print('Built - Profile');
    return Scaffold(
      appBar: AppBar(
        title: widget.isMainScreen ? Text('My Profile') : Text('Statistics'),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            UserInfo(containerColor, widget.userName),
            // RatingGraph(widget.userName, containerColor),
            ParticipationGraph(containerColor, widget.userName),
            IndexWiseSubmissions(containerColor, widget.userName),
          ],
        ),
      ),
    );
  }
}
