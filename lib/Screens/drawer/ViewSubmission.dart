import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ViewSubmission extends StatefulWidget {
  final int submissionId;
  final int contestId;
  final String name;
  ViewSubmission(this.name, this.contestId, this.submissionId);

  @override
  _ViewSubmissionState createState() => _ViewSubmissionState();
}

class _ViewSubmissionState extends State<ViewSubmission> {
  double progress = 0;
  InAppWebViewController webView;
  String url = "";

  @override
  Widget build(BuildContext context) {
    final finalUrl = "https://codeforces.com/contest/" +
        widget.contestId.toString() +
        "/submission/" +
        widget.submissionId.toString();
    // print(finalUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin:
              progress < 1.0 ? EdgeInsets.only(top: 3) : EdgeInsets.zero,
              child: progress < 1.0
                  ? LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor:
                AlwaysStoppedAnimation<Color>(Color(0xFF2867B2)),
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
                onLoadStart: (InAppWebViewController controller, String url) {
                  setState(() {
                    this.url = url;
                  });
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
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