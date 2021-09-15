import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/colorHelper.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/Language.dart';
import 'package:codeforces/Models/RatingToCount.dart';
import 'package:codeforces/Models/Submission.dart';
import 'package:codeforces/Models/Verdict.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class IndexWiseSubmissions extends StatefulWidget {
  final Color containerColor;
  final String username;
  IndexWiseSubmissions(this.containerColor, this.username);
  @override
  _IndexWiseSubmissionsState createState() => _IndexWiseSubmissionsState();
}

class _IndexWiseSubmissionsState extends State<IndexWiseSubmissions> {
  List<charts.Series> seriesList;
  Future<List<Submission>> data;
  bool error = false;

  List<charts.Series> seriesListRating;
  List<PieSeries<Verdict, String>> seriesVerdictRating;
  List<CircularSeries<Language, dynamic>> seriesLanguageRating;

  List<RatingToCount> dataRating;
  List<Verdict> dataVerdict = new List<Verdict>();
  List<Language> dataLanguage = new List<Language>();
  List<Color> colors;

  List<charts.Series<Submission, String>> _generateData(List<Submission> data) {
    return [
      new charts.Series<Submission, String>(
        id: 'indexWise statistics',
        data: data,
        domainFn: (Submission submission, _) => submission.index,
        measureFn: (Submission submission, _) => submission.count,
        labelAccessorFn: (Submission submission, _) => '${submission.count}',
        // colorFn: (, _) => charts.MaterialPalette.blue.shadeDefault,
        outsideLabelStyleAccessorFn: (Submission submission, _) {
          final color = widget.containerColor == Colors.white
              ? charts.MaterialPalette.black
              : charts.MaterialPalette.white;

          return new charts.TextStyleSpec(color: color);
        },
      )
    ];
  }

  List<charts.Series<RatingToCount, String>> _generateDataRating() {
    return [
      new charts.Series<RatingToCount, String>(
        id: 'ratingWise statistics',
        data: dataRating,
        domainFn: (RatingToCount x, _) => x.rating,
        measureFn: (RatingToCount x, _) => x.count,
        labelAccessorFn: (RatingToCount x, _) => '${x.count}',
        outsideLabelStyleAccessorFn: (RatingToCount x, _) {
          final color = widget.containerColor == Colors.white
              ? charts.MaterialPalette.black
              : charts.MaterialPalette.white;
          return new charts.TextStyleSpec(color: color);
        },
      )
    ];
  }

  void _generateDataVerdict(Map<String, int> verdictToCount) {
    int _index = 0;
    verdictToCount.forEach((k, v) {
      Verdict verdict = Verdict(k, v, colors[_index % colors.length]);
      dataVerdict.add(verdict);
      _index++;
    });
    seriesVerdictRating = [
      PieSeries<Verdict, String>(
        dataSource: dataVerdict,
        dataLabelSettings: DataLabelSettings(isVisible: true),
        pointColorMapper: (Verdict data, _) => data.color,
        xValueMapper: (Verdict data, _) => data.x,
        yValueMapper: (Verdict data, _) => data.y,
        animationDuration: 1000,
      )
    ];
  }

  void _generateDataLanguage(Map<String, int> languageToCount) {
    int _index = 0;
    languageToCount.forEach((k, v) {
      Language language = Language(k, v, colors[_index % colors.length]);
      dataLanguage.add(language);
      _index++;
    });
    seriesLanguageRating = <CircularSeries<Language, dynamic>>[
      PieSeries<Language, String>(
        dataSource: dataLanguage,
        dataLabelSettings: DataLabelSettings(isVisible: true),
        pointColorMapper: (Language data, _) => data.color,
        xValueMapper: (Language data, _) => data.x,
        yValueMapper: (Language data, _) => data.y,
        animationDuration: 1000,
      )
    ];
  }

  String _getProblemName(dynamic temp) {
    return temp['problem']['index'] + "." + temp['contestId'].toString();
  }

  int _getRating(dynamic temp) {
    return temp['problem']['rating'];
  }

  String _getLanguageName(dynamic temp) {
    return temp['programmingLanguage'];
  }

  String _getVerdictName(dynamic temp) {
    String _tempVerdict = temp['verdict'];
    if (_tempVerdict == 'OK') return 'AC';
    if (_tempVerdict == 'WRONG_ANSWER') return 'WA';
    if (_tempVerdict == 'TIME_LIMIT_EXCEEDED') return 'TLE';
    if (_tempVerdict == 'COMPILATION_ERROR') return 'CE';
    if (_tempVerdict == 'RUNTIME_ERROR') return 'RTE';
    if (_tempVerdict == 'MEMORY_LIMIT_EXCEEDED') return 'MLE';
    return _tempVerdict;
  }

  Future<List<Submission>> _fetchData() async {
    Map<String, bool> isSolved = new Map<String, bool>();
    Map<String, int> indexToCount = new Map<String, int>();

    Map<int, int> ratingToCount = new Map<int, int>();
    Map<String, int> languageToCount = new Map<String, int>();
    Map<String, int> verdictToCount = new Map<String, int>();

    try {
      final url = usersAllSubmissions + widget.username;
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);

      // fetching ACs
      for (dynamic temp in data['result']) {
        String _temp = _getProblemName(temp);
        String _tempLanguage = _getLanguageName(temp);
        String _tempVerdict = _getVerdictName(temp);

        if (languageToCount[_tempLanguage] == null) {
          languageToCount[_tempLanguage] = 0;
        }
        languageToCount[_tempLanguage]++;

        if (verdictToCount[_tempVerdict] == null) {
          verdictToCount[_tempVerdict] = 0;
        }
        verdictToCount[_tempVerdict]++;

        if (temp['verdict'] == "OK" && isSolved[_temp] == null) {
          isSolved[_getProblemName(temp)] = true;
          String _index = _temp.substring(0, 1);
          if (indexToCount[_index] == null) {
            indexToCount[_index] = 0;
          }
          indexToCount[_index]++;

          int rating = _getRating(temp);
          if (ratingToCount[rating] == null) {
            ratingToCount[rating] = 0;
          }
          ratingToCount[rating]++;
        }
      }

      List<Submission> temp = new List<Submission>();
      for (int i = 65; i <= 90; i++) {
        String x = String.fromCharCode(i);
        if (indexToCount[x] == null) continue;
        temp.add(Submission(x, indexToCount[x]));
      }
      seriesList = _generateData(temp);

      dataRating = new List<RatingToCount>();
      for (int i = 400; i <= 4500; i += 100) {
        if (ratingToCount[i] == null) continue;
        dataRating.add(RatingToCount(i.toString(), ratingToCount[i]));
      }
      seriesListRating = _generateDataRating();

      _generateDataVerdict(verdictToCount);
      _generateDataLanguage(languageToCount);

      return temp;
    } catch (e) {
      error = true;
      return null;
    }
  }

  @override
  void initState() {
    colors = color;
    data = _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = widget.containerColor == Colors.white
        ? charts.MaterialPalette.black
        : charts.MaterialPalette.white;
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (error) {
          return Container(
            width: double.infinity,
            decoration: decoration.copyWith(color: widget.containerColor),
            padding: paddingProfile,
            margin: marginProfile,
            child: profileErrorText,
          );
        }
        if (snapshot.data == null) {
          return Container(
            margin: marginProfile,
            padding: paddingProfile,
            height: 300,
            decoration: decoration.copyWith(color: widget.containerColor),
            child: circularIndicator(),
          );
        }
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: decoration.copyWith(color: widget.containerColor),
              margin: marginProfile,
              padding: paddingProfile,
              child: charts.BarChart(
                seriesList,
                animate: true,
                vertical: false,
                barRendererDecorator: new charts.BarLabelDecorator<String>(
                    // labelPosition: charts.BarLabelPosition.inside,
                    ),
                animationDuration: Duration(seconds: 2),
                behaviors: [
                  new charts.ChartTitle(
                    'Index wise Solved',
                    titleStyleSpec: charts.TextStyleSpec(
                      color: textColor,
                      // fontSize: fontSize,
                    ),
                    behaviorPosition: charts.BehaviorPosition.top,
                    titleOutsideJustification: charts.OutsideJustification.end,
                    // layoutPreferredSize: 10,
                  ),
                ],
                domainAxis: new charts.OrdinalAxisSpec(
                  renderSpec: new charts.SmallTickRendererSpec(
                    // Tick and Label styling here.
                    labelStyle: new charts.TextStyleSpec(
                      color: textColor,
                    ),

                    // Change the line colors to match text color.
                    lineStyle: new charts.LineStyleSpec(
                      color: textColor,
                    ),
                  ),
                ),
                primaryMeasureAxis: new charts.NumericAxisSpec(
                  renderSpec: new charts.GridlineRendererSpec(
                    minimumPaddingBetweenLabelsPx: 35,
                    labelStyle: new charts.TextStyleSpec(
                      color: textColor,
                    ),
                    // Change the line colors to match text color.
                    lineStyle: new charts.LineStyleSpec(color: textColor),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 500,
              decoration: decoration.copyWith(color: widget.containerColor),
              margin: marginProfile,
              padding: paddingProfile,
              child: charts.BarChart(
                seriesListRating,
                animate: true,
                barRendererDecorator: new charts.BarLabelDecorator<String>(),
                animationDuration: Duration(seconds: 2),
                vertical: false,
                behaviors: [
                  new charts.ChartTitle(
                    'Difficulty wise Solved',
                    behaviorPosition: charts.BehaviorPosition.top,
                    titleOutsideJustification: charts.OutsideJustification.end,
                    titleStyleSpec: charts.TextStyleSpec(
                      color: textColor,
                      // fontSize: fontSize,
                    ),
                  ),
                ],
                domainAxis: new charts.OrdinalAxisSpec(
                  renderSpec: new charts.SmallTickRendererSpec(
                    // Tick and Label styling here.
                    labelStyle: new charts.TextStyleSpec(
                      color: textColor,
                    ),

                    // Change the line colors to match text color.
                    lineStyle: new charts.LineStyleSpec(
                      color: textColor,
                    ),
                  ),
                ),
                primaryMeasureAxis: new charts.NumericAxisSpec(
                  renderSpec: new charts.GridlineRendererSpec(
                    minimumPaddingBetweenLabelsPx: 35,
                    labelStyle: new charts.TextStyleSpec(
                      color: textColor,
                    ),
                    // Change the line colors to match text color.
                    lineStyle: new charts.LineStyleSpec(color: textColor),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 400,
              decoration: decoration.copyWith(color: widget.containerColor),
              margin: marginProfile,
              padding: paddingProfile,
              child: SfCircularChart(
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
                series: seriesVerdictRating,
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                ),
                title: ChartTitle(
                  text: 'Verdicts',
                  alignment: ChartAlignment.far,
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 400,
              decoration: decoration.copyWith(color: widget.containerColor),
              margin: marginProfile,
              padding: paddingProfile,
              child: SfCircularChart(
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
                series: seriesLanguageRating,
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                ),
                title: ChartTitle(
                  text: 'Languages',
                  alignment: ChartAlignment.far,
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
