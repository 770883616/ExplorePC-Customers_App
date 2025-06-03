import '../auth/sign_up.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/auth/sign_in.dart';
import 'package:flutter/material.dart';

class Startpage extends StatelessWidget {
  const Startpage({super.key});

  @override
  Widget build(BuildContext context) {
    double screnwidth = MediaQuery.of(context).size.width;
    double screnhidth = MediaQuery.of(context).size.height;
    Color myColor = Mycolors().myColor;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              // Text("data")
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "images/start.png",
                    fit: BoxFit.cover,
                    width: screnwidth,
                    height: screnhidth / 1.5,
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Container(
                          child: Image(image: AssetImage('images/Explore.jpg')),
                          //margin: EdgeInsets.only(left: screnwidth / 4, top: 20.0),
                          // color: Colors.red,
                          height: screnhidth / 6,
                          width: screnwidth / 6,
                          // margin: EdgeInsets.only(left: 140.0),
                        ),
                        Container(
                          child: Text(
                            "Explore PC",
                            style: TextStyle(
                                fontSize: screnwidth / 15,
                                fontWeight: FontWeight.bold,
                                color: myColor),
                          ),
                          //margin: EdgeInsets.only(left: screnwidth / 4),
                        ),
                      ]),
                  Container(
                    child: Text(
                      "تسوق الحواسيب",
                      style: TextStyle(
                          fontSize: screnwidth / 15,
                          fontWeight: FontWeight.bold,
                          color: myColor),
                    ),
                  ),
                  Container(
                    child: Text(
                      "ومستلزماتها",
                      style: TextStyle(
                          fontSize: screnwidth / 15,
                          fontWeight: FontWeight.bold,
                          color: myColor),
                    ),
                  )
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          //     top: screnhidth / 1.5,
                          left: screnwidth / 12,
                          right: screnwidth / 12,
                          //bottom: screnhidth / 8
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
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
                                "تسجيل دخول",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            //     top: screnhidth / 1.5,
                            left: screnwidth / 12,
                            right: screnwidth / 12,
                            bottom: screnhidth / 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
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
                                Icons.login_sharp,
                                size: 40,
                                color: Colors.white,
                              ),
                              // SizedBox(
                              //   width: 10,
                              //   height: 35,
                              // ),
                              Text(
                                "إنشاء حساب",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ])));
  }
}
