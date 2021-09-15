import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var decoration = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  boxShadow: [
    BoxShadow(
      blurRadius: 2,
      spreadRadius: 3,
      color: Colors.black.withOpacity(0.1),
    ),
  ],
);

var marginProfile = EdgeInsets.symmetric(vertical: 5, horizontal: 10);
var paddingProfile = EdgeInsets.symmetric(vertical: 10, horizontal: 10);

var marginGlobal = EdgeInsets.fromLTRB(10, 5, 10, 5);
var paddingGlobal = EdgeInsets.fromLTRB(20, 0, 20, 0);
