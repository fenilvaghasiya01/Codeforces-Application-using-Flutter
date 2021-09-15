import 'dart:ui';

import 'package:codeforces/Common/solvedDetails.dart';
import 'package:codeforces/Models/Problem.dart';
import 'package:flutter/material.dart';

Color shadowColor(Problem problem, bool isdarkMode) {
  if (isdarkMode) {
    return Colors.black.withOpacity(0.5);
  }

  bool solved = allAccepted[problem.index + "." + problem.contestId.toString()];
  if (solved == true) {
    return Colors.green.withOpacity(0.5);
  }

  int unSolved = allRejected.indexOf(problem.index + ". " + problem.name);
  if (unSolved != -1) {
    return Colors.red.withOpacity(0.4);
  }
  return Colors.black.withOpacity(0.1);
}

Color fillColor(Problem problem, bool isDarkMode) {
  bool solved = allAccepted[problem.index + "." + problem.contestId.toString()];
  if (solved == true) {
    return (isDarkMode ? Colors.green[900] : Colors.green[100]);
  }

  int unSolved = allRejected.indexOf(problem.index + ". " + problem.name);
  if (unSolved != -1) {
    return (isDarkMode ? Colors.red[900] : Colors.red[100]);
  }
  return (isDarkMode ? Color(0xFF272727) : Colors.white);
}

List<Color> color = [
  Color(0xFF5DA5DA),
  Color(0xFFFAA43A),
  Color(0xFF60BD68),
  Color(0xFF4D4D4D),
  Color(0xFFF17CB0),
  Color(0xFFB2912F),
  Color(0xFFB276B2),
  Color(0xFFDECF3F),
  Color(0xFFF15854),
];
