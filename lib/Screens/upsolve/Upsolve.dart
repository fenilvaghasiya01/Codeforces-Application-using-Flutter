import 'dart:convert';
import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/MyDrawer.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/UserContest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'ViewContest.dart';

// ignore: must_be_immutable

class Upsolve extends StatefulWidget {
  final String userName;
  Upsolve(this.userName);

  @override
  _UpsolveState createState() => _UpsolveState();
}

class _UpsolveState extends State<Upsolve> {
  Future<List<PastContests>> _data;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _data = _contestInfo(true);
  }

  Future<List<PastContests>> _contestInfo(bool doDelay) async {
    if (doDelay) await Future.delayed(Duration(seconds: 10));
    error = false;
    try {
      String _url = userContests + widget.userName;
      http.Response data = await http.get(_url);

      List<PastContests> _temp = List<PastContests>();
      var jsonData = json.decode(data.body);

      for (var contest in jsonData['result']) {
        PastContests _currContest = PastContests(
            contest['contestId'],
            contest['contestName'],
            contest['rank'],
            contest['oldRating'],
            contest['newRating'],
            startTime(contest['ratingUpdateTimeSeconds']));
        _temp.add(_currContest);
      }
      List<PastContests> _newTemp = _temp.reversed.toList();
      return _newTemp;
    } catch (e) {
      error = true;
      return null;
    }
  }

  DateTime startTime(timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date;
  }

  Future<Null> _refreshList() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _data = _contestInfo(false);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    print('Built - upsolve ');
    return Scaffold(
      appBar: AppBar(
        title: Text('Upsolve'),
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
          } else if (snapshot.data.length == 0) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return notParticipatedText;
              },
            );
          } else {
            return RefreshIndicator(
              strokeWidth: 2.5,
              color:
                  isDarkMode ? Colors.white54 : Theme.of(context).primaryColor,
              onRefresh: _refreshList,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  PastContests currContest = snapshot.data[index];
                  String _rankText = "Rank : " + currContest.rank.toString();
                  return Container(
                    margin: marginGlobal,
                    padding: paddingGlobal,
                    decoration: decoration.copyWith(
                      color: isDarkMode
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewContest(
                                currContest.contestId,
                                currContest.contestName,
                                isDarkMode),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                      title: Container(
                        child: Text(
                          currContest.contestName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      subtitle: Wrap(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              _rankText,
                            ),
                          ),
                          Container(
                            child: Text(
                              "Rating Changes : " +
                                  currContest.oldRating.toString() +
                                  " - " +
                                  currContest.newRating.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
//                    trailing
                    ),
                  );
                },
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              ),
            );
          }
        },
      ),
    );
  }
}

// old contests should appear last
// new at top
