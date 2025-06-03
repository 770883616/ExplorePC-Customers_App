import 'package:explore_pc/components/onboardingscreens.dart';
import 'package:explore_pc/onboardingscreens/startpage.dart';
import 'package:flutter/material.dart';

class ThreePage extends StatelessWidget {
  const ThreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoarding(
      imageon: "images/c.png",
      numberpage: 3,
      onpress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Startpage(),
            ));
      },
      textone: " سهولة التصفح وسهولة ",
      texttow: " من هاتفك المحمول",
    );
  }
}
