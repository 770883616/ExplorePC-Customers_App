// import 'package:explore_pc/auth/user_provider.dart';
// import 'package:explore_pc/components/ProductReviewsScreen.dart';
// import 'package:explore_pc/models/review.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:provider/provider.dart';
// import 'package:explore_pc/components/bottomNigation_home.dart';
// import 'package:explore_pc/components/myscaffold.dart';
// import 'package:explore_pc/constant/linkapi.dart';
// import 'package:explore_pc/models/computer.dart';
// import 'package:explore_pc/models/mycolors.dart';
// import 'package:explore_pc/widgets/countbutton.dart';
// import 'package:explore_pc/widgets/mystar.dart';
// import '../models/cart.dart';

// class ScreenProduct extends StatefulWidget {
//   final int? computerindex;
//   final Computer computer;
//   final VoidCallback? pree;

//   const ScreenProduct({
//     Key? key,
//     this.computerindex,
//     required this.computer,
//     this.pree,
//   }) : super(key: key);

//   @override
//   _ScreenProductState createState() => _ScreenProductState();
// }

// class _ScreenProductState extends State<ScreenProduct> {
//   late Future<List<Review>> _reviewsFuture;
//   Map<String, dynamic>? _userData;
//   @override
//   void initState() {
//     super.initState();
//     _reviewsFuture = _fetchReviews();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final userData = await UserProvider.getUserData();
//     setState(() {
//       _userData = userData;
//     });
//   }

//   Future<double> _getAverageRating() async {
//     final reviews = await _reviewsFuture;
//     if (reviews.isEmpty) return 0.0;
//     return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
//         reviews.length;
//   }

//   Future<List<Review>> _fetchReviews() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             '$LinkServerName/api/reviews/product/${widget.computer.productId}'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body)['data'];
//         return jsonData.map((json) => Review.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load reviews');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   void _showReviewDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => ReviewDialog(
//         onSubmit: (rating, comment) async {
//           try {
//             final response = await http.post(
//               Uri.parse('$LinkServerName/api/reviews'),
//               headers: {'Content-Type': 'application/json'},
//               body: json.encode({
//                 'productId': widget.computer.productId,
//                 'UserId': _userData!['UserId'], // استبدل بقيمة المستخدم الحقيقي
//                 'rating': rating,
//                 'comment': comment,
//               }),
//             );

//             if (response.statusCode == 201) {
//               setState(() {
//                 _reviewsFuture = _fetchReviews();
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('تم إضافة تقييمك بنجاح'),
//                   backgroundColor: Colors.green,
//                   duration: Duration(seconds: 2),
//                 ),
//               );
//             }
//           } catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('فشل في إضافة التقييم: ${e.toString()}'),
//                 backgroundColor: Colors.red,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildReviewItem(Review review) {
//     return Card(
//       color: Mycolors().myColorbackgrondprodect,
//       elevation: 2,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Mycolors().myColor,
//                   backgroundImage: review.userImage != null
//                       ? NetworkImage(
//                           '$LinkServerName/storage/${review.userImage}')
//                       : null,
//                   child: review.userImage == null
//                       ? Text(
//                           review.userName.substring(0, 1),
//                           style: TextStyle(color: Colors.white),
//                         )
//                       : null,
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       review.userName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     RatingBarIndicator(
//                       rating: review.rating,
//                       itemBuilder: (context, index) => Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                       ),
//                       itemCount: 5,
//                       itemSize: 20.0,
//                       direction: Axis.horizontal,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             if (review.comment.isNotEmpty)
//               Text(
//                 review.comment,
//                 style: TextStyle(fontSize: 14),
//               ),
//             SizedBox(height: 10),
//             Text(
//               '${review.date.day}/${review.date.month}/${review.date.year}',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double rating = (widget.computer.ratings ?? 0).toDouble();

//     return Myscaffold(
//       mywidget: Scaffold(
//         backgroundColor: Mycolors().myColor,
//         floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _showReviewDialog(context),
//           child: Icon(Icons.chat_bubble, color: Colors.white),
//           backgroundColor: Mycolors().myColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           elevation: 5,
//         ),
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // قسم صورة المنتج والمعلومات الأساسية
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.4,
//                     color: Mycolors().myColor,
//                     padding: EdgeInsets.only(top: 20),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: () => Navigator.pop(context),
//                               icon: Icon(Icons.keyboard_backspace_rounded),
//                               color: Mycolors().myColorbackgrond,
//                             ),
//                             Consumer<Cart>(
//                               builder: (context, cart, child) {
//                                 return Row(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         Navigator.of(context)
//                                             .pushAndRemoveUntil(
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       MyHomePage(iscart: 3),
//                                                 ),
//                                                 (route) => false);
//                                         // Navigator.of(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder: (context) =>
//                                         //         MyHomePage(iscart: 3),
//                                         //   ),
//                                         // );
//                                       },
//                                       icon: Icon(Icons.shopping_cart),
//                                       color: Mycolors().myColorbackgrond,
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.only(right: 10),
//                                       child: Text(
//                                         "${cart.count}",
//                                         style: TextStyle(
//                                             color: Mycolors().myColorbackgrond),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             )
//                           ],
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   flex: 2,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       image: DecorationImage(
//                                         image: NetworkImage(
//                                           '$LinkServerName/storage/${widget.computer.image}',
//                                         ),
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Text(
//                                         widget.computer.name!,
//                                         style: TextStyle(
//                                           color: Mycolors().myColorbackgrond,
//                                           fontSize: 20,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       Column(
//                                         children: [
//                                           Text(
//                                             "السعر",
//                                             style: TextStyle(
//                                               color:
//                                                   Mycolors().myColorbackgrond,
//                                               fontSize: 20,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           Text(
//                                             "${widget.computer.price!} \$",
//                                             style: TextStyle(
//                                               color:
//                                                   Mycolors().myColorbackgrond,
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // قسم تفاصيل المنتج والتقييمات
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Mycolors().myColorbackgrond,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "وصف المنتج",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           widget.computer.description ?? "لا يوجد وصف متاح",
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(height: 20),
//                         FutureBuilder<double>(
//                           future: _getAverageRating(),
//                           builder: (context, snapshot) {
//                             final avgRating =
//                                 snapshot.data ?? widget.computer.ratings ?? 0.0;
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IgnorePointer(
//                                   child: Mystar(rating: avgRating),
//                                 ),
//                                 Text(
//                                   " (${avgRating.toStringAsFixed(1)})",
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                                 Text(
//                                   "   التقييم العام",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Buttoncount(),
//                             Text(
//                               "${widget.computer.stockQuantity.toString()} متوفر في المخزن",
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 30),
//                         Text(
//                           "تقييمات العملاء",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         FutureBuilder<List<Review>>(
//                           future: _reviewsFuture,
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             } else if (snapshot.hasError) {
//                               return Text(
//                                 "حدث خطأ في تحميل التقييمات",
//                                 style: TextStyle(color: Colors.red),
//                               );
//                             } else if (!snapshot.hasData ||
//                                 snapshot.data!.isEmpty) {
//                               return Center(
//                                 child: Text(
//                                   "لا توجد تقييمات بعد",
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               );
//                             } else {
//                               return Column(
//                                 children: snapshot.data!
//                                     .map(_buildReviewItem)
//                                     .toList(),
//                               );
//                             }
//                           },
//                         ),
//                         // مساحة فارغة لتجنب تغطية الزر العائم
//                         SizedBox(height: 100),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // زر إضافة إلى السلة العائم
//             Positioned(
//               bottom: 5,
//               left: 60,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   // color: Mycolors().myColorbackgrond,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Consumer<Cart>(
//                   builder: (context, cart, child) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         cart.add(widget.computer);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                                 'تمت إضافة ${widget.computer.name} إلى السلة'),
//                             backgroundColor: Mycolors().myColor,
//                             duration: Duration(seconds: 2),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Mycolors().myColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.shopping_cart,
//                               color: Mycolors().myColorbackgrond),
//                           SizedBox(width: 10),
//                           Text(
//                             "إضافة إلى السلة",
//                             style: TextStyle(
//                               color: Mycolors().myColorbackgrond,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
