import 'package:flutter/material.dart';

var primaryColor = Color.fromARGB(255, 49, 173, 182);
var warningColor = const Color(0xFFE9C46A);
var dangerColor = const Color(0xFFE76F51);
var successColor = const Color(0xFF2A9D8F);
var greyColor = const Color(0xFFAFAFAF);

TextStyle headerStyle({int level = 1, Color color = Colors.black}) {
  List<double> levelSize = [30, 24, 20, 16, 14];
  return TextStyle(
      fontSize: levelSize[level - 1],
      fontWeight: FontWeight.bold,
      color: color);
}

var buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 15),
    backgroundColor: primaryColor);
