import 'package:flutter/material.dart';

class Mylisttile extends StatelessWidget {
  Mylisttile({super.key, this.trailing, this.title, this.leading, this.onTap});

  String? title;
  Icon? leading, trailing;
  void Function()? onTap;
  Padding? padding;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue)),
      child: ListTile(
          onTap: onTap,
          title: Text(
            "${title}",
            textAlign: TextAlign.right,
          ),
          //subtitle: Text("data"),
          leading: leading,
          trailing: trailing),
    );
  }
}
