import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/sections/product_details_page.dart';
import 'package:explore_pc/widgets/screenprodect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductGridItem extends StatefulWidget {
  final Computer pc;
  final double itemWidth;
  final double itemHeight;

  const ProductGridItem({
    Key? key,
    required this.pc,
    this.itemWidth = 160,
    this.itemHeight = 240, // زيادة الارتفاع الأساسي
  }) : super(key: key);

  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    isHovered ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmall = widget.itemWidth < 160;
    final double imageHeight = widget.itemHeight * 0.5; // 50% للصورة
    final double infoHeight = widget.itemHeight * 0.5; // 50% للمعلومات

    return SizedBox(
      width: widget.itemWidth,
      height: widget.itemHeight,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Mycolors()
                            .myColor
                            .withOpacity(0.2 * _controller.value),
                        blurRadius: 12 * _controller.value,
                        spreadRadius: 1 * _controller.value,
                        offset: Offset(0, 4 * _controller.value),
                      ),
                    ],
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        _controller.forward(from: 0.0).then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScreenProduct(computer: widget.pc),
                            ),
                          );
                        });
                      },
                      splashColor: Mycolors().myColor.withOpacity(0.2),
                      highlightColor: Colors.transparent,
                      child: ConstrainedBox(
                        // أضافة ConstrainedBox لمنع التجاوز
                        constraints: BoxConstraints(
                          minHeight: widget.itemHeight - 16, // طرح الـ margin
                          maxHeight: widget.itemHeight - 16,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Mycolors().myColorbackgrond.withOpacity(0.50),
                                Mycolors().myColorbackgrond.withOpacity(0.85),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // جزء الصورة
                              Expanded(
                                child: Container(
                                  height: imageHeight,
                                  constraints: BoxConstraints(
                                    maxHeight: imageHeight,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              radius: 0.8,
                                              colors: [
                                                Mycolors().myColor.withOpacity(
                                                    0.3 * _controller.value),
                                                Mycolors().myColor.withOpacity(
                                                    0.05 * _controller.value),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              isSmall ? 5.0 : 5.0),
                                          child: _isHovered
                                              ? AnimatedRotation(
                                                  turns:
                                                      _controller.value * 0.02,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: _buildProductImage(
                                                      isSmall),
                                                )
                                              : _buildProductImage(isSmall),
                                        ),
                                        Positioned.fill(
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            opacity: _isHovered ? 0.3 : 0.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                  radius: 0.9,
                                                  colors: [
                                                    Colors.white
                                                        .withOpacity(0.4),
                                                    Colors.white
                                                        .withOpacity(0.0),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // جزء المعلومات
                              Expanded(
                                child: Container(
                                  height: infoHeight,
                                  constraints: BoxConstraints(
                                    maxHeight: infoHeight,
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: 8,
                                    bottom: 10, // زيادة المساحة السفلية
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, // تغيير إلى start
                                    children: [
                                      Text(
                                        widget.pc.name ?? 'اسم المنتج',
                                        style: TextStyle(
                                          fontSize: isSmall ? 13 : 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '\$${widget.pc.price?.toStringAsFixed(2) ?? '0.00'}',
                                        style: TextStyle(
                                          // fontSize: isSmall ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Spacer(), // استخدام Spacer لملء المساحة
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: isSmall ? 20 : 24,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          gradient: LinearGradient(
                                            colors: [
                                              Mycolors()
                                                  .myColor
                                                  .withOpacity(0.8),
                                              Mycolors()
                                                  .myColor
                                                  .withOpacity(0.4),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(bool isSmall) {
    return Expanded(
      child: Image.network(
        '$LinkServerName/storage/${widget.pc.image}',
        // fit: BoxFit.cover,
        // width: isSmall ? 60 : 80,
        // height: isSmall ? 60 : 80,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
              child: SpinKitCircle(
            size: 30,
            color: Mycolors().myColor,
          )
              //  CircularProgressIndicator(
              //   strokeWidth: 1.5,
              //   valueColor: AlwaysStoppedAnimation<Color>(
              //     Theme.of(context).primaryColor,
              //   ),
              // ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.computer,
            size: isSmall ? 40 : 50,
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}
