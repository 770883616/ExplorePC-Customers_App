import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/sections.dart';

//كلاس الفئات الفرعية
class subcategoreis {
  final String name;
  final String image;
  final List<Computer> sections;

  subcategoreis({
    required this.name,
    required this.image,
    required this.sections,
  });
}

class SubCategory<T> {
  final String name;
  final String image;
  final List<T> items;

  SubCategory({
    required this.name,
    required this.image,
    required this.items,
  });
}
