import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/components/onboardingscreens.dart';
import 'package:explore_pc/onboardingscreens/threepage.dart';
import 'package:flutter/material.dart';

class TowPage extends StatelessWidget {
  const TowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoarding(
      imageon: "images/b.png",
      numberpage: 2,
      onpress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Myscaffold(
                mywidget: ThreePage(),
              ),
            ));
      },
      textone: " تسوق الحواسيب ومستلزماتها ",
      texttow: " من هاتفك المحمول",
    );
  }
}
