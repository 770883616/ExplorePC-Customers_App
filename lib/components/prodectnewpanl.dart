import 'package:explore_pc/components/bottomNigation_home.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:explore_pc/constant/crud.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/likeprodect.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/widgets/continerprodect.dart';
import 'package:explore_pc/widgets/screenprodect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
// import 'package:cached_network_image/cached_network_image.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // تأكد من إضافة الحزمة في pubspec.yaml

class SpecialOfferBanner extends StatefulWidget {
  final int autoScrollDuration; // جعل المدة قابلة للتعديل
  const SpecialOfferBanner({super.key, this.autoScrollDuration = 3});

  @override
  _SpecialOfferBannerState createState() => _SpecialOfferBannerState();
}

class _SpecialOfferBannerState extends State<SpecialOfferBanner> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;
  double _currentPage = 0.0;
  Timer? _autoScrollTimer;
  Timer? _manualScrollPauseTimer;
  bool _isAutoScrollEnabled = true;

  final List<Map<String, dynamic>> offers = [
    {
      "image": "images/desktopcomputer.png",
      "title": "عروض اللابتوبات",
      "subtitle": "خصم يصل إلى 35% على الموديلات الجديدة",
      "color": const Color(0xFF4A6FA5),
      "productOffset": -30.0,
    },
    {
      "image": "images/computer.png",
      "title": "أجهزة الكمبيوتر",
      "subtitle": "أقوى المواصفات بأفضل الأسعار",
      "color": const Color(0xFF6B5B95),
      "productOffset": -25.0,
    },
    {
      "image": "images/mp3.png",
      "title": "السماعات المميزة",
      "subtitle": "جودة صوت استثنائية بخصم 30%",
      "color": const Color(0xFF88B04B),
      "productOffset": -40.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_updatePage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(
      Duration(seconds: widget.autoScrollDuration),
      (timer) {
        if (!_isAutoScrollEnabled) return;

        if (_currentIndex < offers.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentIndex,
            duration: 500.ms,
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  void _handleManualScroll() {
    // إيقاف التمرير التلقائي مؤقتاً
    setState(() => _isAutoScrollEnabled = false);

    // إلغاء أي مؤقت سابق
    _manualScrollPauseTimer?.cancel();

    // بدء مؤقت جديد لمدة 3 ثواني
    _manualScrollPauseTimer = Timer(const Duration(seconds: 3), () {
      setState(() => _isAutoScrollEnabled = true);
    });
  }

  void _updatePage() {
    setState(() => _currentPage = _pageController.page ?? 0.0);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _manualScrollPauseTimer?.cancel();
    _pageController.removeListener(_updatePage);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _handleManualScroll(); // التعامل مع التمرير اليدوي
            },
            itemBuilder: (context, index) {
              final offset = (index - _currentPage).abs();
              final scale = 1.0 - (offset * 0.2);
              final opacity = 1.0 - (offset * 0.5);
              final isCenter = (index - _currentPage).abs() < 0.5;

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY((index - _currentPage) * -0.1),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: opacity.clamp(0.7, 1.0),
                  child: Transform.scale(
                      scale: scale,
                      child: _buildOfferCard(index, isCenter)
                          .animate() // تأثيرات من flutter_animate
                          .fadeIn(duration: 300.ms)
                          .scale(
                            begin: const Offset(0.9, 0.9),
                          )),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildOfferCard(int index, bool isCenter) {
    return GestureDetector(
      onTap: () => debugPrint('Selected: ${offers[index]["title"]}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: offers[index]["color"].withOpacity(0.3),
              blurRadius: isCenter ? 20 : 10,
              spreadRadius: isCenter ? 3 : 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // الخلفية مع تأثير متحرك
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      offers[index]["color"].withOpacity(0.8),
                      offers[index]["color"].withOpacity(0.9),
                    ],
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms, angle: 0.5),

              // صورة المنتج مع تأثير
              Positioned(
                right: offers[index]["productOffset"],
                bottom: -15,
                child: Transform.scale(
                  scale: isCenter ? 1.15 : 1.0,
                  child: Image.asset(
                    offers[index]["image"],
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .shake(duration: 1000.ms, hz: 2)
                      .then(delay: 500.ms),
                ),
              ),

              // المحتوى النصي
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // شريط العرض المحدود مع تأثير
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "عرض محدود",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().scaleXY(begin: 0.8),

                    const Spacer(),

                    // العنوان والوصف مع تأثيرات
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offers[index]["title"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ).animate().fadeIn().slideY(begin: 0.5),
                        const SizedBox(height: 8),
                        Text(
                          offers[index]["subtitle"],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ).animate().fadeIn(delay: 100.ms),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // زر الشراء مع تأثير
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: offers[index]["color"],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'اشتر الآن',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ).animate().scale(delay: 200.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        offers.length,
        (index) => AnimatedContainer(
          duration: 300.ms,
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? offers[index]["color"]
                : Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        ).animate().flipH(delay: 100.ms * index),
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showSpecialOffer = true;
  late Future<List<Computer>> futureProducts;
  List<Computer> allProducts = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    futureProducts = _loadProducts();
  }

  Future<List<Computer>> _loadProducts() async {
    try {
      final products = await ApiService().getProducts();
      return products;
    } catch (e) {
      debugPrint('Error loading products: $e');
      return [];
    }
  }

  void _handleScroll() {
    if (_scrollController.offset > 100 && _showSpecialOffer) {
      setState(() => _showSpecialOffer = false);
    } else if (_scrollController.offset <= 100 && !_showSpecialOffer) {
      setState(() => _showSpecialOffer = true);
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked, Computer product) async {
    final messenger = ScaffoldMessenger.of(context);

    // إخفاء أي رسالة حالية قبل عرض الجديدة
    messenger.hideCurrentSnackBar();

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

      await _showAdvancedSnackBar(
        context: context,
        message: 'تمت إضافة ${product.name} إلى المفضلة',
        icon: Icons.favorite,
        color: Colors.green, // أو استخدام Mycolors().myColor
        action: 'عرض',
        onAction: () => _navigateToFavorites(),
      );
    } else {
      setState(() {
        like.removeWhere((item) => item.id == product.productId);
      });

      await _showAdvancedSnackBar(
        context: context,
        message: 'تمت إزالة ${product.name} من المفضلة',
        icon: Icons.favorite_border,
        color: Colors.red, // أو استخدام Mycolors().myColor
        action: 'تراجع',
        onAction: () => _undoRemove(product),
      );
    }

    return !isLiked;
  }

// دالة مساعدة لعرض SnackBar متطور
  Future<void> _showAdvancedSnackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color color,
    String? action,
    VoidCallback? onAction,
  }) async {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      elevation: 6,
      duration: const Duration(seconds: 3),
      action: action != null
          ? SnackBarAction(
              label: action,
              textColor: Colors.white,
              onPressed: onAction ?? () {},
            )
          : null,
      dismissDirection: DismissDirection.horizontal,
      animation: _buildSnackBarAnimation(),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// تأثير حركي للظهور
  Animation<double>? _buildSnackBarAnimation() {
    return CurvedAnimation(
      parent: kAlwaysCompleteAnimation,
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }

// دالة التراجع عن الحذف
  void _undoRemove(Computer product) {
    setState(() {
      like.add(Likeprodect(
        id: product.productId,
        image: product.image,
        name: product.name,
        price: product.price,
        grie: product.description,
      ));
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

// الانتقال لصفحة المفضلة
  void _navigateToFavorites() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FavoriteScreen(like: like),
    //   ),
    // );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors().myColorbackgrondprodect,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            floating: false,
            pinned: false,
            flexibleSpace: _showSpecialOffer
                ? FlexibleSpaceBar(background: SpecialOfferBanner())
                : null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                "منتجات",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Mycolors().myColor,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: FutureBuilder<List<Computer>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: SpinKitSquareCircle(
                        color: Mycolors().myColor,
                        size: 50.0,
                      ),
                      //  CircularProgressIndicator(
                      //   color: Mycolors().myColor,
                      // ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'حدث خطأ في تحميل المنتجات',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      final isLiked =
                          like.any((item) => item.id == product.productId);

                      return ProductCard(
                        product: product,
                        isLiked: isLiked,
                        onLikePressed: (isLiked) async {
                          return await onLikeButtonTapped(isLiked, product);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenProduct(
                                computer: product,
                                computerindex: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
