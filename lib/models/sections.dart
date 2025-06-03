import 'dart:convert';

import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/cart.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// class Product {
//   final int productId;
//   final int merchantId;
//   final String name;
//   final String description;
//   final double price;
//   final String category;
//   final int stockQuantity;
//   final String image;
//   final double? ratings;

//   Product({
//     required this.productId,
//     required this.merchantId,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.category,
//     required this.stockQuantity,
//     required this.image,
//     this.ratings,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productId: json['productId'],
//       merchantId: json['MerchantId'],
//       name: json['name'],
//       description: json['description'],
//       price: json['price'].toDouble(),
//       category: json['category'],
//       stockQuantity: json['stockQuantity'],
//       image: json['image'],
//       ratings: json['ratings']?.toDouble(),
//     );
//   }
// }

class Sections {
  static Future<List<Computer>> fetchProductsByCategory(String category) async {
    // هنا ستقوم بتنفيذ طلب HTTP لجلب البيانات من API
    // مثال باستخدام package http (يجب إضافته إلى pubspec.yaml)
    try {
      final response = await http.get(
        Uri.parse(LinkProducts),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Computer> products = (data['data'] as List)
            .map((item) => Computer.fromJson(item))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
// يمكنك الاحتفاظ بالبيانات الثابتة كبديل إذا فشل الاتصال بالخادم
//   static List<Computer> getDefaultProductsByCategory(String category) {
//     switch (category) {
//       case 'الحواسيب':
//         return [
//           Computer(
//             productId: 1,
//             merchantId: 1,
//             name: "حاسوب شخصي 1",
//             description: "وصف الحاسوب الشخصي 1",
//             price: 100,
//             category: "الحواسيب",
//             stockQuantity: 10,
//             image: "images/computer.png",
//             ratings: 4.5,
//           ),
//           Computer(
//             productId: 2,
//             merchantId: 1,
//             name: "حاسوب شخصي 2",
//             description: "وصف الحاسوب الشخصي 2",
//             price: 200,
//             category: "الحواسيب",
//             stockQuantity: 10,
//             image: "images/computer.png",
//             ratings: 4.0,
//           ),
//         ];
//       // يمكنك إضافة فئات أخرى هنا
//       default:
//         return [];
//     }
//   }
// }
