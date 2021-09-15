import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/colorHelper.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/Problem.dart';
import 'package:codeforces/Screens/problems/viewProblem.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewContest extends StatefulWidget {
  int contestId;
  String contestName;
  bool isDarkMode;
  ViewContest(this.contestId, this.contestName, this.isDarkMode);

  @override
  _ViewContestState createState() => _ViewContestState();
}

// ignore: must_be_immutable
class _ViewContestState extends State<ViewContest> {
  Future<List<Problem>> _data;

  @override
  void initState() {
    super.initState();
    _data = _contestInfo();
  }

  Future<List<Problem>> _contestInfo() async {
    String _url = viewContest + "contestId=${widget.contestId}&from=1&count=1";
    http.Response data = await http.get(_url);
    var jsonData = json.decode(data.body);

    List<Problem> _temp = new List<Problem>();
    for (var problem in jsonData['result']['problems']) {
      Problem _tempProblem = Problem(problem['index'], problem['name'],
          problem['contestId'], problem['rating']);
      _temp.add(_tempProblem);
    }

    return _temp;
  }

  @override
  Widget build(BuildContext context) {
    print('Built - particular contest');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contestName.toString()),
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return circularIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Problem currProblem = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProblem(
                            widget.contestId.toString() +
                                "/problem/" +
                                currProblem.index,
                            currProblem.name),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                      color: fillColor(currProblem, widget.isDarkMode),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          spreadRadius: 3,
                          color: shadowColor(currProblem, widget.isDarkMode),
                        ),
                      ],
                    ),
                    child: ListTile(
                      //no use of top-bottom in contentPadding
                      contentPadding: EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                      title: Text(
                        currProblem.index + '. ' + currProblem.name,
                      ),
                      subtitle: Text(
                        "Rating : " + currProblem.rating.toString(),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
