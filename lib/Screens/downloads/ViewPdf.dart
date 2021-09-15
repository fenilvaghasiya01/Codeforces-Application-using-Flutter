import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class ViewPDF extends StatelessWidget {
  final String pathPDF;
  ViewPDF(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        //view PDF
        appBar: AppBar(
          title: Text("Problem Statement"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        path: pathPDF);
  }
}
