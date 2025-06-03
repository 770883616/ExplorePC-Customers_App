// import 'package:explore_pc/models/cart.dart';

// class Computer {
//   int? id;
//   String? image;
//   String? name;
//   double? price;
//   String? grie;
//   Computer({this.id, this.image, this.name, this.price, this.grie});
// }

// List<Computer> Computers = [
//   Computer(
//     id: 1,
//     image: "images/computer.png",
//     name: "com",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 2,
//     image: "images/d.png",
//     name: "com",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 3,
//     image: "images/d.png",
//     name: "com",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 4,
//     image: "images/computer.png",
//     name: "com",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 5,
//     image: "images/boxpc.png",
//     name: "box pc",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 6,
//     image: "images/hp.png",
//     name: "hp ",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 7,
//     image: "images/ky.png",
//     name: "ky ",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 8,
//     image: "images/mp3.png",
//     name: "سماعة حاسوب لاسلكية جيمنج ",
//     price: 10000,
//     grie: "احترافية سهولة التوصيل تشتغل عبر البلوتوث ",
//   ),
//   Computer(
//     id: 9,
//     image: "images/mous.png",
//     name: "mous ",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 10,
//     image: "images/pc.png",
//     name: "pc ",
//     price: 10.5,
//     grie: "pro",
//   ),
//   Computer(
//     id: 11,
//     image: "images/pcgemng.png",
//     name: "gemng ",
//     price: 10.5,
//     grie: "pro",
//   ),
// ];
class Computer {
  final int productId;
  final int merchantId;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stockQuantity;
  final String? image;
  final double? ratings;

  Computer({
    required this.productId,
    required this.merchantId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    this.image,
    this.ratings,
  });

  factory Computer.fromJson(Map<String, dynamic> json) {
    return Computer(
      productId: json['productId'],
      merchantId: json['MerchantId'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      category: json['category'],
      stockQuantity: json['stockQuantity'],
      image: json['image'],
      ratings: json['ratings'] != null
          ? double.parse(json['ratings'].toString())
          : null,
    );
  }
}
