import 'dart:convert';
import 'package:http/http.dart' as http;

Map<String, bool> allAccepted;
List<String> allRejected;
List<int> correspondingContestId;
Map<String, int> indexToCount;

String _getProblemName(dynamic temp) {
  return temp['problem']['index'] + "." + temp['contestId'].toString();
}

String _getFullProbName(dynamic temp) {
  return temp['problem']['index'] + ". " + temp['problem']['name'];
}

Future<void> getAllAccepted(String url) async {
  allAccepted = new Map<String, bool>();
  allRejected = new List<String>();
  indexToCount = new Map<String, int>();
  correspondingContestId = new List<int>();

  print("Fetching ACs...");
  // var stopWatch = new Stopwatch();
  // stopWatch.start();
  http.Response response = await http.get(url);
  // stopWatch.stop();
  var data = jsonDecode(response.body);

  // fetching ACs
  for (dynamic temp in data['result']) {
    String _temp = _getProblemName(temp);
    if (temp['verdict'] == "OK" && allAccepted[_temp] == null) {
      allAccepted[_getProblemName(temp)] = true;
      String _index = _temp.substring(0, 1);
      if (indexToCount[_index] == null) {
        indexToCount[_index] = 0;
      }
      indexToCount[_index]++;
    }
  }

  //Fetching unsolved
  for (dynamic temp in data['result']) {
    if (temp['verdict'] != "OK" && allAccepted[_getProblemName(temp)] == null) {
      if (allRejected.indexOf(_getFullProbName(temp)) == -1) {
        allRejected.add(_getFullProbName(temp));
        correspondingContestId.add(temp['contestId']);
      }
    }
  }

  // print('======================== TIME');
  // print(stopWatch.elapsedMilliseconds);
}

// have to restart the app if want to see new ACs/WAs.
