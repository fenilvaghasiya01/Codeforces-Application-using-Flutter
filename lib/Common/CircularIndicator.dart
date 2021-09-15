import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget circularIndicator() => Center(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xFF2867B2),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );

// both colors are temp
