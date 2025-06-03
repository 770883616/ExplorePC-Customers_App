import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/onboardingscreens/towpage.dart';
import 'package:explore_pc/widgets/mycirclstart.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding(
      {super.key,
      this.imageon,
      this.numberpage,
      this.onpress,
      this.textone,
      this.texttow});
  String? imageon;
  //double? mywidthon;
  //int? numbercoloron;
  int? numberpage;
  VoidCallback? onpress;
  String? textone;
  String? texttow;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(imageon!),
        ),
        Container(
          child: Text(
            textone.toString(),
            style: TextStyle(fontSize: 25),
          ),
        ),
        Container(
            child: Text(
          texttow.toString(),
          style: TextStyle(fontSize: 25.0),
        )),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCirclstart(
              mywidth: numberpage == 1 ? 18 : 6,
              numbercolor: numberpage == 1 ? 1 : 0,
            ),
            MyCirclstart(
              mywidth: numberpage == 2 ? 18 : 6,
              numbercolor: numberpage == 2 ? 1 : 0,
            ),
            MyCirclstart(
              mywidth: numberpage == 3 ? 18 : 6,
              numbercolor: numberpage == 3 ? 1 : 0,
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: 10),
          child: FloatingActionButton(
            onPressed: onpress,
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => TowPage()));

            backgroundColor: Mycolors().myColor,
            child: Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ],
    ));
  }
}
