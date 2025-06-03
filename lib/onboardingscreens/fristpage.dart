import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/onboardingscreens/onepage.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screnwidth = MediaQuery.of(context).size.width;
    double screnhidth = MediaQuery.of(context).size.width;
    Color myColor = hexToColor("#09B0EA");
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text("data")
            Image.asset(
              "images/image.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            Center(
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Container(
                      child: Image(image: AssetImage('images/Explore.jpg')),
                      //margin: EdgeInsets.only(left: screnwidth / 4, top: 20.0),
                      // color: Colors.red,
                      height: screnhidth / 2,
                      width: screnwidth / 2,
                      // margin: EdgeInsets.only(left: 140.0),
                    ),
                    Container(
                      child: Text(
                        "Explore PC",
                        style: TextStyle(
                            fontSize: screnwidth / 10,
                            fontWeight: FontWeight.normal),
                      ),
                      //margin: EdgeInsets.only(left: screnwidth / 4),
                    ),
                  ]),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(
                      //     top: screnhidth / 1.5,
                      left: screnwidth / 10,
                      right: screnhidth / 10,
                      bottom: screnhidth / 6),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Myscaffold(
                                    mywidget: OnePage(),
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: screnhidth / 4,
                        //     vertical: screnwidth / 50),
                        //disabledForegroundColor: Colors.white,
                        side: BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                        backgroundColor: myColor.withOpacity(0.5)),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.navigate_next_sharp,
                          size: 40,
                          color: Colors.white,
                        ),
                        // SizedBox(
                        //   width: 10,
                        //   height: 35,
                        // ),
                        Text(
                          "دخول",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),

        // SizedBox(
        //   height: 10.0,
        // ),
        // Container(
        //   child: Image(image: AssetImage('images/home2.png')),
        //   height: 450.0,
        //   width: 600.0,
        //   margin: EdgeInsets.all(0.0),

        // color: Colors.blue,
        // ),
        // Container(
        //   child: Text("contener2"),
        //   height: 100.0,
        //   width: 100.0,
        //   color: Colors.green,
        // ),
        // Container(
        //   width: double.infinity,
        // )
      ),
    );
  }
}
