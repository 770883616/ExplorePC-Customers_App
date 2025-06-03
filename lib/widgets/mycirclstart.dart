import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class MyCirclstart extends StatelessWidget {
  MyCirclstart({super.key, this.mywidth, this.numbercolor});
  Color? color;
  double? mywidth;
  int? numbercolor;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: mywidth, //== index ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: // Colors.red,
            numbercolor == 1 ? Mycolors().myColor : Mycolors().myColoronbording,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
