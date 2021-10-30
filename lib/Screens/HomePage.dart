import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:codeforces/Common/solvedDetails.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Screens/problems/Problems.dart';
import 'package:codeforces/Screens/profile/Profile.dart';
import 'package:codeforces/Screens/settings.dart';
import 'package:codeforces/Screens/upcoming/UpcomingContests.dart';
import 'package:codeforces/Screens/upsolve/Upsolve.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'downloads/Downloads.dart';
import '../Common/solvedDetails.dart';

//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String globalUserName;

class HomePage extends StatefulWidget {
  final String userName;
  HomePage(this.userName);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Profile _profile;
  UpcomingContests _upcomingContests;
  Upsolve _upsolve;
  Problems _problems;
  Downloads _downloads;

  _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    print('Built - Home page INIT STATE');
    globalUserName = widget.userName;

    super.initState();

    getAllAccepted(usersAllSubmissions + widget.userName);
    _profile = new Profile(widget.userName, true);
    _upcomingContests = new UpcomingContests();
    _upsolve = new Upsolve(widget.userName);
    _problems = new Problems();
    _downloads = new Downloads();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    print("Build - HomePage(MAIN)");

    List<Widget> pages = [
      _profile,
      _upcomingContests,
      _upsolve,
      _problems,
      _downloads,
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
          return true;
        }
        setState(() {
          _selectedIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
        ),
        bottomNavigationBar: BubbledNavigationBar(
          defaultBubbleColor:Color(0xFF1c4a80),
          // onTap: (index) {
          //    index: _selectedIndex;
          // },
          onTap:_onTap,
          items: <BubbledNavigationBarItem>[
            BubbledNavigationBarItem(
              icon:       Icon(FontAwesomeIcons.user, size: 30, color: Colors.red),
              activeIcon: Icon(CupertinoIcons.profile_circled, size: 30, color: Colors.white),
              title: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 12),),
            ),
            BubbledNavigationBarItem(
              icon:       Icon(FontAwesomeIcons.caretSquareRight, size: 30, color: Colors.purple),
              activeIcon: Icon(FontAwesomeIcons.caretSquareRight, size: 30, color: Colors.white),
              title: Text('Upcoming', style: TextStyle(color: Colors.white, fontSize: 12),),
            ),
            BubbledNavigationBarItem(
              icon:       Icon(Icons.content_paste, size: 30, color: Colors.purple),
              activeIcon: Icon(Icons.content_paste, size: 30, color: Colors.white),
              title: Text('Upsolve', style: TextStyle(color: Colors.white, fontSize: 12),),
            ),
            BubbledNavigationBarItem(
              icon:       Icon(Icons.code, size: 30, color: Colors.teal),
              activeIcon: Icon(Icons.code_sharp, size: 30, color: Colors.white),
              title: Text('Problems', style: TextStyle(color: Colors.white, fontSize: 12),),
            ),
            BubbledNavigationBarItem(
              icon:       Icon( Icons.file_download,size: 30, color: Colors.cyan),
              activeIcon: Icon( Icons.file_download, size: 30, color: Colors.white),
              title: Text('Downloads', style: TextStyle(color: Colors.white, fontSize: 12),),
            ),
          ],


        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   elevation: 20,
        //   type: BottomNavigationBarType.fixed,
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.user,
        //         size: 20,
        //       ),
        //       label: 'Profile',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.caretSquareRight,
        //         size: 21,
        //       ),
        //       label: 'Upcoming',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.content_paste,
        //       ),
        //       label: 'Upsolve',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.code,
        //       ),
        //       label: 'Problems',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.file_download,
        //       ),
        //       label: 'Downloads',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor:
        //       isDarkMode ? Colors.white : Theme.of(context).primaryColor,
        //   unselectedItemColor: Colors.grey,
        //   onTap: _onTap,
        // ),
      ),
    );
  }
}

