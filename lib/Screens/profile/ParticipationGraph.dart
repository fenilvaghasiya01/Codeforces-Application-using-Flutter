import 'dart:convert';
import 'dart:math';

import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/UserContest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ParticipationGraph extends StatefulWidget {
  final Color containerColor;
  final String userName;
  ParticipationGraph(this.containerColor, this.userName);

  @override
  _ParticipationGraphState createState() => _ParticipationGraphState();
}

class _ParticipationGraphState extends State<ParticipationGraph> {
  Future<List<PastContests>> _graphData;
  bool error = false;
  int minRating = 5000, maxRating = 0;

  @override
  void initState() {
    _graphData = _getUserContestInfo();
    super.initState();
  }

  Future<List<PastContests>> _getUserContestInfo() async {
    try {
      String _url = userContests + widget.userName;
      http.Response response = await http.get(_url);

      var jsonData = jsonDecode(response.body);

      List<PastContests> _tempList = new List<PastContests>();

      for (var contest in jsonData['result']) {
        minRating = min(contest['newRating'], minRating);
        maxRating = max(contest['newRating'], maxRating);
        PastContests _temp = PastContests(
            contest['contestId'],
            contest['contestName'],
            contest['rank'],
            contest['oldRating'],
            contest['newRating'],
            startTime(contest['ratingUpdateTimeSeconds']));
        _tempList.add(_temp);
      }
      return _tempList;
    } catch (e) {
      error = true;
      return null;
    }
  }

  DateTime startTime(timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date;
  }

  List<LineSeries<PastContests, DateTime>> _generateLineSeries(
      List<PastContests> graphData) {
    return [
      LineSeries<PastContests, DateTime>(
        dataSource: graphData,
        xValueMapper: (PastContests contest, _) => contest.date,
        yValueMapper: (PastContests contest, _) => contest.newRating,
        dataLabelSettings: DataLabelSettings(isVisible: false),
        // pointColorMapper: (data, _) => isDarkMode ? Colors.pinkAccent : Colors.blueAccent,
        markerSettings: MarkerSettings(
          height: 4,
          width: 4,
          // color: Colors.red,
          isVisible: true,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: decoration.copyWith(color: widget.containerColor),
      margin: marginProfile,
      padding: EdgeInsets.fromLTRB(7, 15, 10, 5),
      child: FutureBuilder(
        future: _graphData,
        builder: (context, snapshot) {
          if (error) {
            return profileErrorText;
          }
          if (snapshot.data == null) {
            return circularIndicator();
          }
          List<PastContests> graphData = snapshot.data;
          List<ChartSeries<PastContests, DateTime>> lineSeries =
              _generateLineSeries(graphData);
          double yStart = ((minRating - 100) / 100).floorToDouble() * 100;
          double yEnd = (maxRating / 100).ceilToDouble() * 100;
          return SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enableDoubleTapZooming: true,
              enablePinching: true,
              enablePanning: true,
            ),
            primaryXAxis: DateTimeAxis(
              desiredIntervals: 3,
              dateFormat: DateFormat.yMMM(),
              intervalType: DateTimeIntervalType.months,
            ),
            primaryYAxis: CategoryAxis(
              minimum: yStart,
              maximum: yEnd,
              interval: 100,
            ),
            // title: ChartTitle(
            //   alignment: ChartAlignment.far,
            //   text: 'Rating changes',
            //   textStyle: TextStyle(
            //     fontSize: 13.2,
            //   ),
            // ),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  PastContests _temp = graphData[pointIndex];
                  int delta = _temp.newRating - _temp.oldRating;
                  String deltaText = delta >= 0 ? "+" : "";
                  deltaText += delta.toString();
                  return Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _temp.newRating.toString() + " ($deltaText)",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Rank : " + _temp.rank.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              _temp.contestName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            // zoomPanBehavior: ZoomPanBehavior(
            //     enableDoubleTapZooming: true, enablePinching: true),
            series: lineSeries,
          );
        },
      ),
    );
  }
}
