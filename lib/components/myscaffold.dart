import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class Myscaffold extends StatelessWidget {
  Myscaffold({super.key, this.mywidget, this.myappbar});
  Widget? mywidget;
  AppBar? myappbar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors().myColorbackgrond,
      body: mywidget,
      appBar: myappbar,
    );
  }
}
