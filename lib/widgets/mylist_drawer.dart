import 'package:flutter/material.dart';

class MyListDrawer extends StatelessWidget {
  MyListDrawer({super.key, this.trailing, this.title, this.leading, this.pree});

  String? title;
  Icon? leading, trailing;
  VoidCallback? pree;
  @override
  Widget build(BuildContext context) {
    // return Card(
    //   color: Colors.white,
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20),
    //       side: BorderSide(color: Colors.blue)),
    // child:
    return ListTile(
        onTap: pree,
        title: Text(
          "${title}",
          textAlign: TextAlign.right,
        ),
        //subtitle: Text("data"),
        leading: leading,
        trailing: trailing);
    // );
  }
}
