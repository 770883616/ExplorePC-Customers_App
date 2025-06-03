import 'package:flutter/material.dart';

class Mycolors {
  Color myColor = hexToColor("#09B0EA");
  Color myColorButton = hexToColor("#F9F8FE");
  Color myColorbackgrondNew = hexToColor("#61CAED");
  Color myColorbackgrond = hexToColor("#FFFFFF");
  Color myColorbackgrondprodect = hexToColor("#F9F8FE");
  Color myColorBorder = hexToColor("#F9F8FE");
  Color myColoronbording = Colors.grey;
}

Color hexToColor(String hexColor) {
  return Color(int.parse("0xFF" + hexColor.substring(1, 7)));
}
