import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Screens/Authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'Screens/settings.dart';
import 'Screens/themes.dart';

void main() {
  runApp(MyApp());
}

bool isDarkMode;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return circularIndicator();
        }
        return (ChangeNotifierProvider<Settings>.value(
          value: Settings(snapshot.data),
          child: StartApp(),
        ));
      },
    );
  }
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    isDarkMode = Provider.of<Settings>(context).isDarkMode ? true : false;
    FlutterStatusbarcolor.setStatusBarColor(
        Provider.of<Settings>(context).isDarkMode
            ? Colors.black
            : Color(0xFF1c4a80));

    FlutterStatusbarcolor.setNavigationBarColor(Colors.black);

    return MaterialApp(
      title: 'Codeforces app',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? setDarkTheme : setLightTheme,
      home: Authenticate(),
    );
  }
}

// set top most bar color
