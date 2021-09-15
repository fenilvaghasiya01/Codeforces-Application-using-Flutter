import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/MyDrawer.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/Contest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../settings.dart';

Map<int, String> idToContestName;

class UpcomingContests extends StatefulWidget {
  @override
  _UpcomingContestsState createState() => _UpcomingContestsState();
}

class _UpcomingContestsState extends State<UpcomingContests> {
  Future<List<Contest>> _data;
  int count = 0;
  bool error = false;

  @override
  void initState() {
    super.initState();
    idToContestName = new Map<int, String>();
    _data = _contestInfo(true);
  }

  Future<List<Contest>> _contestInfo(bool doDelay) async {
    error = false;

    if (doDelay) await Future.delayed(Duration(seconds: 5));
    try {
      String _url = allContests;
      List<Contest> _temp = new List<Contest>();
      http.Response data = await http.get(_url);

      var jsonData = json.decode(data.body);

      for (var contest in jsonData['result']) {
        Contest currContest = Contest(
            contest['id'],
            contest['name'],
            contest['type'],
            contest['phase'],
            contest['durationSeconds'],
            contest['startTimeSeconds']);
        if (currContest.phase == 'BEFORE') {
          _temp.add(currContest);
        }
        idToContestName[currContest.id] = currContest.name;
      }
      List<Contest> _newTemp = _temp.reversed.toList();
      return _newTemp;
    } catch (e) {
      error = true;
      return null;
    }
  }

  String startTime(timestamp) {
    //print(timestamp);
    var _format = new DateFormat('EEE d-MM-y hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var time = _format.format(date);
    return time;
  }

  void _launchURL(int contestId) async {
    final String url = upcomingContestPage + contestId.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Error occured in launching " + url);
    }
  }

  Future<Null> _refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _data = _contestInfo(false);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    print('Built - Upcoming contests');
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Contests'),
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (error) {
            return RefreshIndicator(
              strokeWidth: 2.5,
              color:
                  isDarkMode ? Colors.white54 : Theme.of(context).primaryColor,
              onRefresh: _refreshList,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return errorText;
                },
                itemCount: 1,
              ),
            );
          }
          if (snapshot.data == null) {
            return circularIndicator();
          }
          return RefreshIndicator(
            strokeWidth: 2.5,
            color: isDarkMode ? Colors.white54 : Theme.of(context).primaryColor,
            onRefresh: _refreshList,
            child: ListView.builder(
              itemBuilder: (context, index) {
                Contest currContest = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _launchURL(currContest.id);
                    });
                  },
                  child: Container(
                      decoration: decoration.copyWith(
                        color: isDarkMode
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      margin: marginGlobal,
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Name',
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Type',
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Duration',
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Start',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                child: Text(':'),
                              ),
                              Container(
                                child: Text(':'),
                              ),
                              Container(
                                child: Text(':'),
                              ),
                              Container(
                                child: Text(':'),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    currContest.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    currContest.type,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    (currContest.durationSeconds / 3600)
                                            .toString() +
                                        ' Hours',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    startTime(currContest.startTimeSeconds),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              },
//            separatorBuilder: (_, __) => Divider(height: 0.0),
              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            ),
          );
        },
      ),
    );
  }
}
