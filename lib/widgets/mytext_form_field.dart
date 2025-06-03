import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.textAlign,
    required this.mycontroller,
    required this.valid,
    this.focusNode,
    this.keyboardType,
  });

  final String label;
  final Icon icon;
  final TextAlign textAlign;
  final TextEditingController mycontroller;
  final String? Function(String?)? valid;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  // final bool? obscureText;
  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        // obscureText: widget.obscureText!,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        textAlign: widget.textAlign,
        controller: widget.mycontroller,
        validator: widget.valid,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          label: Text(widget.label),
          suffixIcon: widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Mycolors().myColor),
          ),
        ),
      ),
    );
  }
}
