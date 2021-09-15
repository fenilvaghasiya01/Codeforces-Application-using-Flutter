import 'package:flutter/material.dart';

Widget errorText = Center(
  child: Opacity(
    opacity: 0.7,
    child: Text(
      'Something went wrong!',
      style: TextStyle(
        fontSize: 18,
        height: 5,
      ),
    ),
  ),
);

Widget profileErrorText = Center(
  child: Opacity(
    opacity: 0.7,
    child: Padding(
      padding: EdgeInsets.all(15),
      child: Text(
        'Something went wrong!',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    ),
  ),
);

Widget bookmarkText = Center(
  child: Opacity(
    opacity: 0.7,
    child: Text(
      'Bookmark some problems !',
      style: TextStyle(
        fontSize: 18,
        height: 5,
      ),
    ),
  ),
);

Widget downloadText = Center(
  child: Opacity(
    opacity: 0.7,
    child: Text(
      'No Problem found !',
      style: TextStyle(
        fontSize: 18,
        height: 5,
      ),
    ),
  ),
);

Widget notParticipatedText = Center(
  child: Opacity(
    opacity: 0.7,
    child: Text(
      'Participate in some Contests !',
      style: TextStyle(
        fontSize: 18,
        height: 5,
      ),
    ),
  ),
);

Widget zeroUnsolvedText = Center(
  child: Opacity(
    opacity: 0.7,
    child: Text(
      'Zero unsolved , Great !',
      style: TextStyle(
        fontSize: 18,
        height: 5,
      ),
    ),
  ),
);
