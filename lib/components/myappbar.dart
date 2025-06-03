import 'package:flutter/material.dart';

class Myappbar extends StatelessWidget {
  Myappbar({super.key, this.actions, this.mycolor, this.titel});
  List<Widget>? actions;
  // Widget? image;
  Widget? titel;
  Color? mycolor;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      title: titel,
      backgroundColor: mycolor,
    );
  }
}
