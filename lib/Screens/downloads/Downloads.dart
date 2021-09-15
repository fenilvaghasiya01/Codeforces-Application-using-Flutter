import 'dart:io';

import 'package:codeforces/Common/MyDrawer.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:flutter/material.dart';

import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'ViewPdf.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  var files;

  // getting all files ( list of files )
  Future<Null> _getFiles() async {
    files = null;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var root = appDocDir.path;
    var fileManager = FileManager(root: Directory(root));
    files = await fileManager.filesTree(
      extensions: ["pdf"],
    );
    setState(() {});
    return null;
  }

  // on refresh
  Future<Null> _refreshList() async {
    _getFiles();
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
    return null;
  }

  // deleting particular file
  Future<Null> _deletePDF(File file) async {
    try {
      await file.delete();
    } catch (e) {
      print("Error in deleting file");
    }
    return null;
  }

  @override
  void initState() {
    _getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<Settings>(context).isDarkMode;
    print('Built - Downloads');
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      drawer: MyDrawer(),
      body: files == null
          ? Text('Fetching data')
          : RefreshIndicator(
              onRefresh: _refreshList,
              strokeWidth: 2.5,
              color:
                  isDarkMode ? Colors.white54 : Theme.of(context).primaryColor,
              child: files.length == 0
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return Center(
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Download some problems !',
                              style: TextStyle(fontSize: 18, height: 5),
                            ),
                          ),
                        );
                      },
                      itemCount: 1,
                    )
                  : ListView.builder(
                      itemCount: files?.length ?? 0,
                      itemBuilder: (context, index) {
                        String fileName = files[index].path.split('/').last;
                        int dotIndex = fileName.indexOf('.');
                        fileName = fileName.substring(0, dotIndex);
                        // print(fileName);
                        return Container(
                          margin: marginGlobal,
                          padding: paddingGlobal,
                          decoration: decoration.copyWith(
                            color: isDarkMode
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.picture_as_pdf),
                            title: Text(fileName),
                            trailing: GestureDetector(
                              onTap: () {
                                _deletePDF(File(files[index].path.toString()));
                                _getFiles();
                              },
                              child: Icon(
                                Icons.delete,
                                // color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPDF(
                                    files[index].path.toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
