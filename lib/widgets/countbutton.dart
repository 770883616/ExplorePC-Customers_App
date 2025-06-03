import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:count_button/count_button.dart';

class Buttoncount extends StatefulWidget {
  const Buttoncount({
    super.key,
    this.countValue,
  });

  @override
  State<Buttoncount> createState() => _ButtoncountState();
  final int? countValue;
}

class _ButtoncountState extends State<Buttoncount> {
  int countValue = 1;

  @override
  Widget build(BuildContext context) {
    return CountButton(
      selectedValue: countValue,
      minValue: 0,
      maxValue: 99,
      foregroundColor: Mycolors().myColorbackgrond,
      backgroundColor: Mycolors().myColor,
      buttonSize: Size(30, 30),
      onChanged: (value) {
        setState(() {
          countValue = value;
          // print(countValue);
        });
      },
      valueBuilder: (value) {
        print(value.toString());
        return Text(
          value.toString(),
          style: const TextStyle(fontSize: 20.0),
        );
      },
    );
  }
}
