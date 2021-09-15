import 'dart:convert';
import 'package:codeforces/Common/CircularIndicator.dart';
import 'package:codeforces/Common/decoartion.dart';
import 'package:codeforces/Common/errorText.dart';
import 'package:codeforces/Common/urls.dart';
import 'package:codeforces/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInfo extends StatefulWidget {
  final Color containerColor;
  final String userName;
  UserInfo(this.containerColor, this.userName);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<User> _data;
  bool error = false;

  Future<User> _getUserInfo() async {
    try {
      final String _url = userInfo + widget.userName;
      print(_url);
      http.Response response = await http.get(_url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body)['result'];

        User ansUser;
        for (var user in jsonData) {
          ansUser = new User(
              user['handle'],
              user['firstName'],
              user['lastName'],
              user['rating'],
              user['maxRating'],
              user['rank'],
              user['maxRank'],
              user['country'],
              user['city'],
              user['friendOfCount'],
              user['titlePhoto'],
              user['contribution'],
              user['organization']);
        }

        return ansUser;
      } else {
        throw new Exception("Error occured");
      }
    } catch (e) {
      print("error occured");
      error = true;
      return null;
    }
  }

  @override
  void initState() {
    _data = _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: decoration.copyWith(color: widget.containerColor),
      margin: marginProfile,
      padding: paddingProfile,
      child: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (error) {
              return profileErrorText;
            }
            if (snapshot.data == null) {
              return Center(
                child: circularIndicator(),
              );
            }
            User currUser = snapshot.data;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 53.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage("https:" + currUser.avatar),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        currUser.handle,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('First Name'),
                          Text('Last Name'),
                          Text('Country'),
                          Text('City'),
                          Text('organization'),
                          Text('Rating'),
                          Text('Max Rating'),
                          Text('Rank '),
                          Text('Max Rank'),
                          Text('Friends of '),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: [
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              currUser.firstName ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.lastName ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.country ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.city ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.organization ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.rating.toString() ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.maxRating.toString() ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.rank ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.maxRank ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              currUser.friendOfCount.toString() ?? "NA",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
