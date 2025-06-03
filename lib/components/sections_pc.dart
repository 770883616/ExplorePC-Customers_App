import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/sections/categories_page.dart';
import 'package:flutter/material.dart';

class SectionsPc extends StatelessWidget {
  const SectionsPc({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("الاقسام"),
        CategoriesPage(),
      ],
    );
  }
}
