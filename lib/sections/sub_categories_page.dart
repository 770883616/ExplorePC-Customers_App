import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/sections/category_gridItem.dart';
import 'package:explore_pc/sections/class_subcategoreis.dart';
import 'package:explore_pc/sections/products_page.dart';
import 'package:flutter/material.dart';

//صفحة الفئات الفرعية
class SubCategoriesPage extends StatelessWidget {
  final String title;
  final List<subcategoreis> subCategories;

  SubCategoriesPage({required this.title, required this.subCategories});

  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      // backgroundColor: Colors.white,
      myappbar: AppBar(
        title: Text(title),
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
        children: subCategories.map((subCategory) {
          return CategoryGridItem(
            image: subCategory.image,
            title: subCategory.name,
            icon: Icons.category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsPage(
                    category: subCategory.name,
                    products: subCategory.sections, // تمرير القائمة المناسبة
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
