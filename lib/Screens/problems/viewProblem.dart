import 'dart:developer';
import 'dart:io';

import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// set delays accordingly so that downloaded pdf is perfect
class ViewProblem extends StatefulWidget {
  final String url, problemName;
  ViewProblem(this.url, this.problemName);

  @override
  _ViewProblemState createState() => _ViewProblemState();
}

class _ViewProblemState extends State<ViewProblem> {
  String htmlToData;
  bool isLoading = false;
  double progress = 0;
  InAppWebViewController webView;
  String url = "";

  void _makeRequest(String finalUrl) async {
    var response = await http.get(finalUrl);

    if (response.statusCode == 200) {
      var htmlToParse = parse(response.body);
      // print('------------------------1');
      // await Future.delayed(Duration(seconds: 2));

      htmlToData = htmlToParse.outerHtml;
      // print('------------------------2');
      // await Future.delayed(Duration(seconds: 2));

      htmlToData = htmlToData.replaceAll('//sta', 'https://sta');
      // print('------------------------3');
      // await Future.delayed(Duration(seconds: 2));

      var nkamo = log(htmlToData);
      // print('------------------------4');
      // await Future.delayed(Duration(seconds: 2));
      _generatePDF();
    }
  }

  Future<void> _generatePDF() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var targetPath = appDocDir.path;
    var targetFileName = widget.problemName;
    await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlToData, targetPath, targetFileName);

    setState(() {
      isLoading = false;
      progress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final finalUrl = "https://codeforces.com/contest/" + widget.url;

    return isLoading == true
        ? Scaffold(
      appBar: AppBar(
        title: Text('Downloading...'),
      ),
      body: circularIndicator(),
    )
        : Scaffold(
      appBar: AppBar(
        title: Text('Problem Statement'),
        actions: [
          ClipOval(
            child: Material(
              color: Theme.of(context).primaryColor, // button color
              child: InkWell(
                splashColor: Colors.white70, // inkwell color
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(
                    Icons.download_sharp,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  _makeRequest(finalUrl);
                  setState(() {
                    isLoading = true;
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: progress < 1.0
                  ? EdgeInsets.only(top: 3)
                  : EdgeInsets.zero,
              child: progress < 1.0
                  ? LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color> (Color(0xFF2867B2)),
                minHeight: 5,
              )
                  : Container(),
            ),
            Expanded(
              child: InAppWebView(
                initialUrl: finalUrl,
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                    )),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart:
                    (InAppWebViewController controller, String url) {
                  setState(() {
                    this.url = url;
                  });
                },
                onLoadStop: (InAppWebViewController controller,
                    String url) async {
                  setState(() {
                    this.url = url;
                  });
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
