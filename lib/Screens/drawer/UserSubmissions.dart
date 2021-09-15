import 'dart:convert';

import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/SubmittedProblem.dart';
import 'package:codeforces/Screens/upcoming/UpcomingContests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ViewSubmission.dart';

class UserSubmissions extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  UserSubmissions(this.username, this.isDarkMode);

  @override
  _UserSubmissionsState createState() => _UserSubmissionsState();
}

class _UserSubmissionsState extends State<UserSubmissions> {
  Future<List<SubmittedProblem>> _data;
  bool error = false;

  @override
  void initState() {
    _data = _getUserSubmissions();
    super.initState();
  }

  Future<List<SubmittedProblem>> _getUserSubmissions() async {
    try {
      int noOfSubmissions = 50;
      String _url =
          userSubmissions + widget.username + "&from=1&count=$noOfSubmissions";
      print(_url);
      http.Response data = await http.get(_url);
      var jsonData = jsonDecode(data.body);

      List<SubmittedProblem> problemsAll = new List<SubmittedProblem>();

      for (var result in jsonData['result']) {
        SubmittedProblem _temp = new SubmittedProblem(
            result['problem']['index'],
            result['problem']['name'],
            result['problem']['contestId'],
            result['problem']['rating'],
            result['id']);
        problemsAll.add(_temp);
      }
      return problemsAll;
    } catch (e) {
      error = true;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Submissions'),
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (error) {
            return profileErrorText;
          }
          if (snapshot.data == null) {
            return circularIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              SubmittedProblem currProblem = snapshot.data[index];
              return Container(
                margin: marginGlobal,
                padding: paddingGlobal,
                decoration: decoration.copyWith(
                    color: widget.isDarkMode
                        ? Theme.of(context).primaryColor
                        : Colors.white),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewSubmission(
                                currProblem.name,
                                currProblem.contestId,
                                currProblem.submissionId)));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Text(currProblem.index + ". " + currProblem.name),
                  subtitle: Container(
                    child: Text(
                      idToContestName[currProblem.contestId] ?? "NULL",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
