import 'package:explore_pc/components/myappbar.dart';
import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/models/sections.dart';
import 'package:explore_pc/sections/product_gridItem.dart';
import 'package:flutter/material.dart';

//صفحة المنتجات
class ProductsPage extends StatelessWidget {
  final String category;
  final List<Computer> products;

  ProductsPage({required this.category, required this.products});

  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      myappbar: AppBar(
        title: Text(category),
        backgroundColor: Mycolors().myColorbackgrond,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset("images/Explore.jpg"),
          )
        ],
      ),
      mywidget: GridView.count(
        crossAxisCount: 2, // عدد الأعمدة في الشبكة
        children: products.map((product) {
          return ProductGridItem(pc: product);
        }).toList(),
      ),
    );
  }
}
