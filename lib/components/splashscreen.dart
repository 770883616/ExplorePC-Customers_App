import 'package:explore_pc/components/bottomNigation_home.dart';
import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: Expanded(child: Image.asset("images/Explore PC.gif")),
          )
        ],
      ),
      nextScreen: Myscaffold(
        mywidget: MyHomePage(
          iscart: 2,
        ),
      ),
      splashIconSize: 400,
      backgroundColor: Mycolors().myColorbackgrond,
    );
  }
}
