import 'package:flutter/material.dart';

// function to build snackbar ( bottom pop-up ) of particular message.

Widget buildSnackBar(String message) {
  return SnackBar(
    content: Text(message),
  );
}
