import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/solvedDetails.dart';
import 'package:codeforces/Screens/upcoming/UpcomingContests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../problems/viewProblem.dart';

class MyUnsolved extends StatelessWidget {
  final bool isDarkMode;
  MyUnsolved(this.isDarkMode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unsolved Problems'),
      ),
      body: SafeArea(
        child: allRejected.length == 0
            ? ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return zeroUnsolvedText;
                },
              )
            : ListView.builder(
                itemCount: allRejected.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: marginGlobal,
                    padding: paddingGlobal,
                    decoration: decoration.copyWith(
                      color: isDarkMode
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      title: Container(
                        child: Text(
                          allRejected[index],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      subtitle: Container(
                        child: Text(
                          idToContestName[correspondingContestId[index]],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onTap: () {
                        String problemName = allRejected[index];
                        int end = 0;
                        while (problemName[end] != ".") {
                          end++;
                        }
                        var probIndex = problemName.substring(0, end);
                        var probName = problemName.substring(end + 2);
                        print(probName);
                        String _url = correspondingContestId[index].toString() +
                            "/problem/" +
                            probIndex;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewProblem(_url, probName)));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
