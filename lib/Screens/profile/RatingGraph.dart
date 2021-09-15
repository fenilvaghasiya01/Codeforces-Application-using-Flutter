// TRYING TO IMPROVE RATING GRAPH OF USER

import 'dart:convert';

import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class History {
  final DateTime time;
  final int rating;
  History(this.time, this.rating);
}

class RatingGraph extends StatefulWidget {
  final String userName;
  final Color containerColor;
  RatingGraph(this.userName, this.containerColor);
  @override
  _RatingGraphState createState() => _RatingGraphState();
}

class _RatingGraphState extends State<RatingGraph> {
  Future<List<History>> _data;
  List<charts.Series<History, DateTime>> seriesList;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _data = _getUserContestInfo();
  }

  Future<List<History>> _getUserContestInfo() async {
    try {
      String _url = userContests + widget.userName;
      http.Response response = await http.get(_url);

      var jsonData = jsonDecode(response.body);

      List<History> temp = new List<History>();

      for (var g in jsonData['result']) {
        History _temp =
            History(startTime(g['ratingUpdateTimeSeconds']), g['newRating']);
        temp.add(_temp);
      }
      return temp;
    } catch (e) {
      error = true;
      return null;
    }
  }

  _generateList(List<History> data) {
    seriesList = [
      new charts.Series<History, DateTime>(
        id: 'rating graph',
        domainFn: (History contest, _) => contest.time,
        measureFn: (History contest, _) => contest.rating,
        labelAccessorFn: (History contest, _) => contest.rating.toString(),
        data: data,
      ),
    ];
  }

  DateTime startTime(timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    var textColor = widget.containerColor == Colors.white
        ? charts.MaterialPalette.black
        : charts.MaterialPalette.white;
    return Container(
      margin: marginProfile,
      padding: paddingProfile,
      height: 300,
      width: double.infinity,
      decoration: decoration.copyWith(color: widget.containerColor),
      child: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (error) {
            return errorText;
          }
          if (snapshot.data == null) {
            return circularIndicator();
          }
          _generateList(snapshot.data);
          return charts.TimeSeriesChart(
            seriesList,
            animate: true,
            animationDuration: Duration(seconds: 2),
            primaryMeasureAxis: new charts.NumericAxisSpec(
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(zeroBound: false),
              renderSpec: new charts.GridlineRendererSpec(
                minimumPaddingBetweenLabelsPx: 35,
                // Change the line colors to match text color.
              ),
            ),
            behaviors: [
              charts.PanAndZoomBehavior(),
              new charts.ChartTitle(
                'Rating changes',
                titleStyleSpec: charts.TextStyleSpec(
                  color: textColor,
                ),
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.end,
              ),
            ],
            // defaultRenderer: new charts.Time
            // dateTimeFactory: const charts.LocalDateTimeFactory(),
          );
        },
      ),
    );
  }
}
