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
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color(0xFF2867B2),
          selectedItemColor: Colors.blue[900],
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              activeIcon: Container(
                child: const Icon(Icons.person_outlined),
                decoration: selectedTopBorder(),
              ),
              icon: const Icon(FontAwesomeIcons.user),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                child: const Icon(FontAwesomeIcons.caretSquareRight),
                decoration: selectedTopBorder(),
              ),
              icon: const Icon(FontAwesomeIcons.caretSquareRight),
              label: 'Upcoming',
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                child: const  Icon(Icons.content_paste),
                decoration: selectedTopBorder(),
              ),
              icon: const Icon(Icons.content_paste),
              label: 'Upsolve',
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                child: const  Icon(Icons.code),
                decoration: selectedTopBorder(),
              ),
              icon: const  Icon(Icons.code),
              label: 'Problems',
            ),
            // BottomNavigationBarItem(
            //   activeIcon: Container(
            //     child: const  Icon(Icons.file_download),
            //     decoration: selectedTopBorder(),
            //   ),
            //   icon: const   Icon(Icons.file_download),
            //   label: 'Downloads',
            // ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTap,
        ),
        // bottomNavigationBar:  BottomNavigationBar(
        //   showSelectedLabels: false,
        //   showUnselectedLabels: false,
        //   unselectedItemColor: Colors.deepPurple[200],
        //   selectedItemColor: Colors.deepPurple,
        //   type: BottomNavigationBarType.fixed,
        //   items: [
        //     BottomNavigationBarItem(
        //       activeIcon: Container(
        //         width: 80.0,
        //         height: 40.0,
        //         decoration: BoxDecoration(
        //             color: Colors.deepPurple[50],
        //             borderRadius: BorderRadius.circular(10.0)),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             Icon(CupertinoIcons.profile_circled),
        //             Text(
        //               'Profile',
        //               style: TextStyle(color: Colors.deepPurple),
        //             )
        //           ],
        //         ),
        //       ),
        //       icon: const Icon(FontAwesomeIcons.user),
        //       label: 'Profile',
        //     ),
        //     BottomNavigationBarItem(
        //       activeIcon: Container(
        //         width: 100.0,
        //         height: 40.0,
        //         decoration: BoxDecoration(
        //             color: Colors.deepPurple[50],
        //             borderRadius: BorderRadius.circular(10.0)),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             Icon(FontAwesomeIcons.caretSquareRight),
        //             Text(
        //               'Upcoming',
        //               style: TextStyle(color: Colors.deepPurple),
        //             )
        //           ],
        //         ),
        //       ),
        //       icon: const Icon(FontAwesomeIcons.caretSquareRight),
        //       label: 'Upcoming',
        //     ),
        //     BottomNavigationBarItem(
        //       activeIcon: Container(
        //         width: 90.0,
        //         height: 40.0,
        //         decoration: BoxDecoration(
        //             color: Colors.deepPurple[50],
        //             borderRadius: BorderRadius.circular(10.0)),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             Icon(Icons.content_paste),
        //             Text(
        //               'Upsolve',
        //               style: TextStyle(color: Colors.deepPurple),
        //             )
        //           ],
        //         ),
        //       ),
        //       icon: const Icon(Icons.content_paste),
        //       label: 'Upsolve',
        //     ),
        //     BottomNavigationBarItem(
        //       activeIcon: Container(
        //         width: 100.0,
        //         height: 40.0,
        //         decoration: BoxDecoration(
        //             color: Colors.deepPurple[50],
        //             borderRadius: BorderRadius.circular(10.0)),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             Icon(Icons.code),
        //             Text(
        //               'Problems',
        //               style: TextStyle(color: Colors.deepPurple),
        //             ),
        //           ],
        //         ),
        //       ),
        //       icon: const Icon(Icons.code),
        //       label: 'Problems',
        //     ),
        //     BottomNavigationBarItem(
        //       activeIcon: Container(
        //         width: 130.0,
        //         height: 40.0,
        //         decoration: BoxDecoration(
        //             color: Colors.deepPurple[50],
        //             borderRadius: BorderRadius.circular(10.0)),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             Icon(Icons.file_download),
        //             Text(
        //               'Downloads',
        //               style: TextStyle(color: Colors.deepPurple),
        //             )
        //           ],
        //         ),
        //       ),
        //       icon: const Icon(Icons.file_download),
        //       label: 'Downloads',
        //     )
        //   ],
        //   currentIndex: _selectedIndex,
        //   // selectedItemColor:
        //   //       isDarkMode ? Colors.white : Theme.of(context).primaryColor,
        //   //   unselectedItemColor: Colors.grey,
        //   onTap: _onTap,
        // ),
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
  BoxDecoration selectedTopBorder() {
    return const BoxDecoration(
        border: Border(top: BorderSide(width: 2.0,color: Color(0xFF0D47A1)))
    );
  }
}

// willpopscope -- ask user to again press back to exit from app
// use instances or direct call ?? (in screens)

// Take a fresh user and test all screens.
// icons size is hard coded , look for diff screen sizes
