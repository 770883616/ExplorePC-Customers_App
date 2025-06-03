import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/components/onboardingscreens.dart';
import 'package:explore_pc/onboardingscreens/towpage.dart';
import 'package:flutter/material.dart';

class OnePage extends StatelessWidget {
  const OnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoarding(
      imageon: "images/a.png",
      numberpage: 1,
      onpress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Myscaffold(
                mywidget: TowPage(),
              ),
            ));
      },
      textone: "أبحث عن منتجك عند جميع ",
      texttow: " التجار بسهولة",
    );
  }
}
