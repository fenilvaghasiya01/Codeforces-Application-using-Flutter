import 'dart:convert';

import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/colorHelper.dart';
import 'package:codeforces/Common/MyDrawer.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/Problem.dart';
import 'package:codeforces/Screens/problems/viewProblem.dart';
import 'package:codeforces/Screens/upcoming/UpcomingContests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings.dart';

class Problems extends StatefulWidget {
  @override
  _ProblemsState createState() => _ProblemsState();
}

class _ProblemsState extends State<Problems> {
  final List<String> difficulty = ["All"];

  Future<List<Problem>> _data;
  List<Problem> problemsAll = new List<Problem>();
  List<Problem> mainData = new List<Problem>();
  String search = "";
  TextEditingController _controller = new TextEditingController();
  String _dropDownValue;
  String askedRating;
  bool error;
  bool isBookmark = false;
  List<String> myBookmarks = [];
  List<String> tempBookmarks = [];
  Map<String, bool> bookmark = new Map<String, bool>();

  @override
  void initState() {
    _createDifficultyList();
    _dropDownValue = difficulty[0];
    _data = _getAllProblems(true, true);
    _getBooksmarks();
    super.initState();
  }

  void _getBooksmarks() async {
    var prefs = await SharedPreferences.getInstance();
    myBookmarks = prefs.getStringList("myBookmarks") ?? [];
    for (int i = 0; i < myBookmarks.length; i++) {
      bookmark[myBookmarks[i]] = true;
      tempBookmarks.add(myBookmarks[i]);
    }
  }

  String _getProblemName(Problem problem) {
    return problem.index + "." + problem.name;
  }

  Future<List<Problem>> _getAllProblems(bool doDelay, bool loadData) async {
    error = false;

    if (doDelay) await Future.delayed(Duration(seconds: 10));
    try {
      String _url = allProblems;
      if (loadData) {
        mainData.clear();
        http.Response data = await http.get(_url);
        var jsonData = jsonDecode(data.body);
        for (var p in jsonData['result']['problems']) {
          Problem problem =
              Problem(p['index'], p['name'], p['contestId'], p['rating']);
          mainData.add(problem);
        }
      }
      problemsAll.clear();
      for (var p in mainData) {
        if (isBookmark) {
          if (bookmark[_getProblemName(p)] == true) {
            problemsAll.add(p);
          }
        } else {
          problemsAll.add(p);
        }
      }
      return problemsAll;
    } catch (e) {
      error = true;
      return null;
    }
  }

  Future<Null> _refreshList() async {
    _dropDownValue = difficulty[0];
    _controller.clear();
    FocusManager.instance.primaryFocus.unfocus();
    Future<List<Problem>> _temp = _getAllProblems(false, true);
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _data = _temp;
    });
    return null;
  }

  _createDifficultyList() {
    for (int i = 0; i <= 27; i++) {
      difficulty.add((i * 100 + 800).toString());
    }
  }

  String _getProblemUrl(Problem problem) {
    String ans = "";
    ans += problem.contestId.toString();
    ans += "/problem/";
    ans += problem.index;
    return ans;
  }

  Future<Null> _searchProblems(String query, bool nameVise) async {
    search = query;
    if (search == "All") {
      nameVise = true;
      search = "DISPLAY_ALL";
    }
    setState(() {
      _data = _foundProblems(nameVise);
    });
    return null;
  }

  Future<List<Problem>> _foundProblems(bool nameVise) async {
    List<Problem> temp = new List<Problem>();
    if (nameVise) {
      for (var problem in problemsAll) {
        if (search == "DISPLAY_ALL" ||
            problem.name.toLowerCase().contains(search.toLowerCase())) {
          temp.add(problem);
        }
      }
    } else {
      for (var problem in problemsAll) {
        if (problem.rating.toString() == search) {
          temp.add(problem);
        }
      }
    }
    return temp;
  }

  void changeBookmark(Problem currProblem) async {
    String problemName = _getProblemName(currProblem);
    var prefs = await SharedPreferences.getInstance();
    if (bookmark[problemName] == null || bookmark[problemName] == false) {
      bookmark[problemName] = true;
      tempBookmarks.add(problemName);
    } else {
      bookmark[problemName] = false;
      tempBookmarks.remove(problemName);
    }
    await prefs.setStringList("myBookmarks", tempBookmarks);
    if (isBookmark) _data = _getAllProblems(false, false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    print('Built - Problems');

    return Scaffold(
      appBar: AppBar(
        title: Text('Problems'),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          error == false && !isBookmark
              ? SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 7, 10, 5),
                    child: TextField(
                      onChanged: (value) {
                        _searchProblems(value, true);
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _controller.clear();
                            FocusManager.instance.primaryFocus.unfocus();
                            _searchProblems("DISPLAY_ALL", true);
                          },
                          child: Icon(Icons.close_rounded),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (error) {
                  return RefreshIndicator(
                    strokeWidth: 2.5,
                    color: isDarkMode
                        ? Colors.white54
                        : Theme.of(context).primaryColor,
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
                      return isBookmark ? bookmarkText : downloadText;
                    },
                  );
                } else {
                  return RefreshIndicator(
                    strokeWidth: 2.5,
                    color: isDarkMode
                        ? Colors.white54
                        : Theme.of(context).primaryColor,
                    onRefresh: _refreshList,
                    child: ListView.builder(
                      itemCount:
                          snapshot.data.length, //snapshot.data == null ? 0
                      itemBuilder: (context, index) {
                        Problem currProblem = snapshot.data[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewProblem(
                                    _getProblemUrl(currProblem),
                                    currProblem.name),
                              ),
                            );
                          },
                          child: Container(
                            margin: marginGlobal,
                            padding: paddingGlobal,
                            decoration: BoxDecoration(
                              color: fillColor(currProblem, isDarkMode),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 3,
                                  color: shadowColor(currProblem, isDarkMode),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                              title: Text(
                                  currProblem.index + ". " + currProblem.name),
                              subtitle: Container(
                                child: Text(
                                  idToContestName[currProblem.contestId] ??
                                      "NULL",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: GestureDetector(
                                child: Icon(
                                  Icons.star,
                                  color:
                                      bookmark[_getProblemName(currProblem)] ==
                                                  null ||
                                              bookmark[_getProblemName(
                                                      currProblem)] ==
                                                  false
                                          ? Colors.grey
                                          : Colors.yellow[600],
                                ),
                                onTap: () async {
                                  changeBookmark(currProblem);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//manage top right icon
// avoid overflow in search while phone is in rotate mode
