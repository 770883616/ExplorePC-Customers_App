import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:explore_pc/Payment/PaymentScreen.dart';
import 'package:explore_pc/auth/user_provider.dart';
import 'package:explore_pc/components/account_user.dart';
import 'package:explore_pc/components/explore_info.dart';
import 'package:explore_pc/components/my_drawer.dart';
import 'package:explore_pc/components/mycart.dart';
import 'package:explore_pc/components/notifications.dart';
import 'package:explore_pc/components/prodectnewpanl.dart';
import 'package:explore_pc/components/sections_pc.dart';
import 'package:explore_pc/constant/crud.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/cart.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/likeprodect.dart';
import 'package:explore_pc/models/my_custom_search.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/notification/notification_provider.dart';
import 'package:explore_pc/sections/categories_page.dart';
import 'package:explore_pc/widgets/continerprodect.dart';
import 'package:explore_pc/widgets/screenprodect.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.iscart})
      : super(
          key: key,
        );

  //final String title;
  // int butcart = 3;
  final int? iscart;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int? get iscart => widget.iscart;

  late int _tabIndex = widget.iscart == 2 ? 2 : 3;
  late PageController pageController;
  List<Computer> computers = [];
  bool isLoading = true;
  late Future<List<Computer>> futureProducts;
  final ApiService apiService = ApiService();

  List<Computer> allProducts = [];
  List<Computer> likedProducts = [];
  Map<String, dynamic>? _userData;
  @override
  void initState() {
    super.initState();
    // _tabIndex = widget.iscart == 2 ? 2 : 3;
    pageController = PageController(initialPage: _tabIndex);
    futureProducts = apiService.getProducts();

    _loadProducts();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserProvider.getUserData();
    setState(() {
      _userData = userData;
      // _isLoading = false;
    });
  }

  Future<void> _loadProducts() async {
    final products = await ApiService().getProducts();
    setState(() {
      allProducts = products;
    });
  }
  // Future<void> fetchProducts() async {
  //   try {
  //     final products = await .fetchProducts();
  //     setState(() {
  //       computers = products;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error loading products: $e')),
  //     );
  //   }
  // }

  Future<bool> onLikeButtonTapped(bool isLiked, Computer product) async {
    if (!isLiked) {
      setState(() {
        like.add(Likeprodect(
          id: product.productId,
          image: product.image,
          name: product.name,
          price: product.price,
          grie: product.description,
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت إضافة ${product.name} إلى المفضلة'),
          backgroundColor: Mycolors().myColor,
        ),
      );
    } else {
      setState(() {
        like.removeWhere((item) => item.id == product.productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('تمت إزالة ${product.name} من المفضلة'),
            backgroundColor: Mycolors().myColor),
      );
    }
    return !isLiked; // إرجاع الحالة الجديدة للإعجاب
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    try {
      return Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          final unreadCount = notificationProvider.unreadCount;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(icon, size: 24),
                color: Colors.black87,
                splashRadius: 24,
                onPressed: onPressed,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('Error in _buildAppBarAction: $e');
      // Fallback UI إذا فشل الـ Consumer
      return IconButton(
        icon: Icon(icon, size: 24),
        color: Colors.black87,
        splashRadius: 24,
        onPressed: onPressed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Computer computer;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
        toolbarHeight: 70,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // استدعاء الدالة مباشرة مع التحقق من context
                  if (context.mounted) {
                    showAppInfoDialog(context);
                  }
                },
                child: Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    "images/Explore.jpg",
                    // width: 100, // تحديد عرض مناسب
                    // height: 100, // تحديد ارتفاع مناسب
                    // fit: BoxFit.contain,
                  ),
                ),
              )),
        ),
        title: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            );
          },
          child: Text(
            "Explore PC",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          _buildAppBarAction(
            icon: Icons.notifications_none,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MyCustomSearch(
                    allComputers: allProducts,
                    likedComputers: allProducts,
                    searchFieldDecoration: InputDecoration(
                      hintText: 'ابحث عن منتج',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    )),
              );
            },
          ),
          IconButton(
            icon: Icon(FontAwesome.list_ul_solid),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mydrawer()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      //drawer: Drawer(),
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.person, color: Colors.white),
          Icon(Icons.shopping_bag_sharp, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.shopping_cart, color: Colors.white),
          Icon(Icons.favorite, color: Colors.red),
        ],
        inactiveIcons: const [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.black),
              Text("حسابي", style: TextStyle(color: Colors.black)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_sharp, color: Colors.black),
              Text("الاقسام", style: TextStyle(color: Colors.black)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, color: Colors.black),
              Text("الرئيسية", style: TextStyle(color: Colors.black)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, color: Colors.black),
              Text("تسوق", style: TextStyle(color: Colors.black)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, color: Colors.black),
              Text("المفضلة", style: TextStyle(color: Colors.black)),
            ],
          ),
        ],
        color: Colors.white,
        circleColor: const Color.fromARGB(255, 0, 217, 255),
        height: 60,
        circleWidth: 60,
        activeIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
            pageController.jumpToPage(_tabIndex);
          });
        },
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Color.fromARGB(255, 0, 217, 255),
        elevation: 5,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          setState(() {
            _tabIndex = v;
          });
        },
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: MyAccountUser(),
            //color: Colors.red,
          ),
          Container(
            //width: double.infinity,
            //height: double.infinity,
            // color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 20, bottom: 10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "الاقسام",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      color: Mycolors().myColor,
                      child: CategoriesPage()),
                ),
              ],
            ),
          ),
          ProductsPage(),
          // Container(
          //     color: const Color.fromARGB(255, 255, 255, 255),
          //     child: Column(children: [
          //       Container(child: SpecialOfferBanner()),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Container(
          //         alignment: Alignment.topRight,
          //         padding: EdgeInsets.only(right: 20),
          //         child: Text(
          //           "منتجات",
          //           style: TextStyle(
          //             fontSize: 20,
          //           ),
          //           textAlign: TextAlign.right,
          //         ),
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Expanded(
          //         child: FutureBuilder<List<Computer>>(
          //           future: futureProducts,
          //           builder: (context, snapshot) {
          //             if (snapshot.connectionState == ConnectionState.waiting) {
          //               return Center(child: CircularProgressIndicator());
          //             } else if (snapshot.hasError) {
          //               return Center(
          //                   child: Text('حدث خطأ: ${snapshot.error}'));
          //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //               return Center(child: Text('لا توجد منتجات متاحة'));
          //             } else {
          //               return Container(
          //                 margin: EdgeInsets.only(bottom: 80),
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(40),
          //                   color: Mycolors().myColorbackgrondprodect,
          //                 ),
          //                 child: GridView.builder(
          //                   gridDelegate:
          //                       SliverGridDelegateWithFixedCrossAxisCount(
          //                     crossAxisCount: 2,
          //                     crossAxisSpacing: 10,
          //                     mainAxisSpacing: 10,
          //                   ),
          //                   padding: EdgeInsets.all(10),
          //                   itemCount: snapshot.data!.length,
          //                   itemBuilder: (context, index) {
          //                     final computer = snapshot.data![index];
          //                     // final computer = computers[index];
          //                     final isLiked = like
          //                         .any((item) => item.id == computer.productId);
          //                     return Continerprodect(
          //                       computerindex: index,
          //                       computer: computer,
          //                       pree: () {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                             builder: (context) => Screenprodect(
          //                               computerindex: index,
          //                               computer: computer,
          //                             ),
          //                           ),
          //                         );
          //                       },
          //                       isLiked: isLiked,
          //                       onLikePressed: (isLiked) async {
          //                         return await onLikeButtonTapped(
          //                             isLiked, computer);
          //                       },
          //                     );
          //                   },
          //                 ),
          //               );
          //             }
          //           },
          //         ),
          //       ),
          //     ])),

          //  Container(
          //   margin: EdgeInsets.only(bottom: 70),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(40),
          //     color: Mycolors().myColorbackgrondprodect,
          //   ),
          // child:
          // GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 10,
          //     mainAxisSpacing: 10,
          //   ),
          //   padding: EdgeInsets.all(10),
          //   itemCount: computers.length,
          //   itemBuilder: (context, index) {
          //     final computer = computers[index];
          //     final isLiked =
          //         like.any((item) => item.id == computer.productId);
          //     return Continerprodect(
          //       computerindex: index,
          //       computer: computer,
          //       pree: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => Screenprodect(
          //               computerindex: index,
          //               computer: computer,
          //             ),
          //           ),
          //         );
          //       },
          //       isLiked: isLiked,
          //       onLikePressed: (isLiked) async {
          //         return await onLikeButtonTapped(isLiked, computer);
          //       },
          //     );
          //   },
          // ),
          // ),
          // ),

          // Container(
          //   child: Expanded(child: Homeprodect()),
          // ),

          // const SizedBox(height: 10),
          // Homeprodect()
          //Expanded(child: ProductGrid()),
          // ],
          // ),
          // ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                return cart.count == 0
                    ? Center(
                        child: Text("لايوجد منتجات في السلة"),
                      )
                    : Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Mycart(),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Mycolors().myColor.withOpacity(0.8),
                            ),

                            // width: 100,
                            margin: EdgeInsets.only(bottom: 75),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Text(
                                  "${cart.totalPrice.toStringAsFixed(2)}  :مجموع السعر",
                                  style: TextStyle(
                                      color: Mycolors().myColorbackgrond,
                                      fontSize: 20),
                                )),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: MaterialButton(
                                          onPressed: () async {
                                            final cart = Provider.of<Cart>(
                                                context,
                                                listen: false);

                                            if (cart.count == 0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'السلة فارغة، أضف منتجات أولاً')),
                                              );
                                              return;
                                            }

                                            bool isLoading = false;
                                            final useraddress =
                                                await UserProvider.getaddress();
                                            try {
                                              setState(() => isLoading = true);

                                              // 1. إنشاء الطلب أولاً
                                              final orderData = {
                                                "UserId": _userData![
                                                    'UserId'], // أو ID المستخدم المسجل
                                                "orderDate": DateTime.now()
                                                    .toUtc()
                                                    .toIso8601String(),
                                                "shippingAddress":
                                                    useraddress['Address'],
                                                // "صنعاء المطار - الرئيسي",
                                                "status": "قيد الانتظار",
                                                "products": cart.backetitem
                                                    .map((item) => {
                                                          "productId":
                                                              item.productId,
                                                          "quantity": cart
                                                              .getQuantity(item
                                                                  .productId),
                                                          "price": item.price,
                                                        })
                                                    .toList(),
                                              };

                                              final response = await http.post(
                                                Uri.parse(
                                                    '$LinkServerName/api/orders'),
                                                headers: {
                                                  'Content-Type':
                                                      'application/json'
                                                },
                                                body: jsonEncode(orderData),
                                              );

                                              if (response.statusCode == 201) {
                                                final responseData =
                                                    jsonDecode(response.body);
                                                final orderId =
                                                    responseData['order']
                                                        ['orderId'];
                                                final totalAmount =
                                                    responseData['order']
                                                        ['totalAmount'];

                                                // 2. تفريغ السلة بعد نجاح إنشاء الطلب
                                                cart.clearCart();

                                                // 3. الانتقال إلى صفحة الدفع مع تمرير orderId و totalAmount
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        PaymentScreen(
                                                      orderId: orderId,
                                                      totalAmount: totalAmount,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                throw Exception(
                                                    'خطأ في إنشاء الطلب: ${response.statusCode}');
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'حدث خطأ: ${e.toString()}')),
                                              );
                                            } finally {
                                              setState(() => isLoading = false);
                                            }
                                          },
                                          child: const Text("طلب المنتجات"),
                                          elevation: 10,
                                          splashColor: Mycolors().myColor,
                                          color: Mycolors().myColorbackgrond,
                                          // height: 45,
                                          // minWidth: 300,
                                          textColor: Mycolors().myColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Text(
                                          "${cart.count}   :عدد المنتجات",
                                          style: TextStyle(
                                            color: Mycolors().myColorbackgrond,
                                          ),
                                        ),
                                        Text(
                                          "${cart.getTotalItemCount()}   :عدد القطع",
                                          style: TextStyle(
                                            color: Mycolors().myColorbackgrond,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ],
                            ),
                            // padding: EdgeInsets.symmetric(vertical: 10),
                          ))
                        ],
                      );
              },
            ),
          ),

          Container(
              margin: EdgeInsets.only(bottom: 75),
              decoration: BoxDecoration(
                color: Mycolors().myColorbackgrondprodect,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FavoriteScreen(
                like: like,
              )),
        ],
      ),
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  final List<Likeprodect> like;
  const FavoriteScreen({super.key, required this.like});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SliverAppBar(
          //   expandedHeight: 150,
          //   floating: true,
          //   pinned: true,
          //   snap: false,
          //   elevation: 8,
          //   shadowColor: Colors.amber.withOpacity(0.3),
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: const Text('قائمتي المفضلة',
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 22,
          //         )),
          //     centerTitle: true,
          //     background: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [Colors.amber[100]!, Colors.white],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //       ),
          //       child: Align(
          //         alignment: Alignment.bottomRight,
          //         child: Padding(
          //           padding: const EdgeInsets.only(right: 20, bottom: 10),
          //           child: Icon(Icons.favorite,
          //               size: 40, color: Colors.red.withOpacity(0.2)),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          widget.like.isEmpty ? _buildEmptyState() : _buildProductGrid(),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildProductGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = widget.like[index];
            return _buildProductCard(product, index);
          },
          childCount: widget.like.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Likeprodect product, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.amber.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // تفاصيل المنتج
          },
          child: Stack(
            children: [
              // صورة المنتج
              Positioned.fill(
                child: Image.network(
                  '$LinkServerName/storage/${product.image}',
                  // fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey[200]!,
                                  Colors.grey[300]!,
                                ],
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                                color: Colors.amber[600],
                              ),
                            ),
                          );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      stops: [0.1, 0.5],
                    ),
                  ),
                ),
              ),

              // تفاصيل المنتج
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.name!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.price!.toStringAsFixed(2)} \$',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Badge العلامة
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Mycolors().myColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'مفضل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // زر الإجراءات
              Positioned(
                top: 12,
                right: 12,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.more_vert,
                        size: 20, color: Colors.black54),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red[400]),
                          const SizedBox(width: 8),
                          const Text('حذف من المفضلة'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share, color: Colors.blue[400]),
                          const SizedBox(width: 8),
                          const Text('مشاركة المنتج'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.green[400]),
                          const SizedBox(width: 8),
                          const Text('التفاصيل'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _removeItem(product);
                    } else if (value == 'share') {
                      // مشاركة المنتج
                    } else {
                      // عرض التفاصيل
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/Explore.jpg',
            width: 250,
            height: 250,
            // repeat: true,
          ),
          const SizedBox(height: 20),
          Text(
            'لم تقم بإضافة منتجات بعد',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'اضغط على أيقونة القلب ♡ لحفظ المنتجات المفضلة لديك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.search,
              size: 20,
              color: Colors.white,
            ),
            label: const Text(
              "اكتشف المنتجات",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Mycolors().myColor,

              // primarغ: Colors.amber[600],
              // onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              elevation: 4,
              shadowColor: Colors.amber.withOpacity(0.3),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyHomePage(
                  iscart: 2,
                ),
              ));
              // الانتقال لصفحة المنتجات
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'filter',
          mini: true,
          backgroundColor: Colors.white,
          elevation: 4,
          child: Icon(Icons.filter_list, color: Mycolors().myColor),
          onPressed: () {
            // فتح فلتر المنتجات
          },
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'share_all',
          mini: true,
          backgroundColor: Colors.white,
          elevation: 4,
          child: Icon(Icons.share, color: Mycolors().myColor),
          onPressed: () {
            // مشاركة كل المفضلة
          },
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'delete_all',
          mini: true,
          backgroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteAllDialog();
          },
        ),
      ],
    );
  }

  void _removeItem(Likeprodect product) {
    // إزالة المنتج من القائمة
    setState(() {
      widget.like.remove(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف ${product.name} من المفضلة'),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.amber[300],
          onPressed: () {
            // إعادة المنتج
            setState(() {
              widget.like.add(product);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mycolors().myColorbackgrond,
        title: const Text('حذف الكل'),
        content: const Text('هل أنت متأكد من حذف جميع المنتجات من المفضلة؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('حذف الكل', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                widget.like.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف جميع المنتجات من المفضلة'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class Likeprodect {
//   final String? id;
//   final String? name;
//   final double? price;
//   final String? image;

//   Likeprodect({this.id, this.name, this.price, this.image});
// }
