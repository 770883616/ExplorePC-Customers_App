import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class CategoryGridItem extends StatefulWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final String? image;

  const CategoryGridItem({
    Key? key,
    required this.title,
    this.icon,
    required this.onTap,
    this.image,
  }) : super(key: key);

  @override
  _CategoryGridItemState createState() => _CategoryGridItemState();
}

class _CategoryGridItemState extends State<CategoryGridItem>
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
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 160;

                  return Container(
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
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () {
                          // تأثير النقر
                          _controller
                              .forward(from: 0.0)
                              .then((_) => widget.onTap());
                        },
                        borderRadius: BorderRadius.circular(18),
                        splashColor: Mycolors().myColor.withOpacity(0.2),
                        highlightColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Mycolors().myColorbackgrond.withOpacity(0.95),
                                Mycolors().myColorbackgrond.withOpacity(0.85),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // الجزء العلوي مع تأثير الطفو
                                Flexible(
                                  flex: 3,
                                  child: Transform.translate(
                                    offset: Offset(0, -5 * _controller.value),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF0077B6)
                                                .withOpacity(
                                                    0.1 * _controller.value),
                                            blurRadius: 8 * _controller.value,
                                            offset: Offset(
                                                0, 3 * _controller.value),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // تأثير خلفية متحرك
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              decoration: BoxDecoration(
                                                gradient: RadialGradient(
                                                  radius: 0.8,
                                                  colors: [
                                                    Mycolors()
                                                        .myColor
                                                        .withOpacity(0.05 *
                                                            _controller.value),
                                                    Mycolors()
                                                        .myColor
                                                        .withOpacity(0.02 *
                                                            _controller.value),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // الصورة مع تأثير الاهتزاز الخفيف
                                            _isHovered
                                                ? AnimatedRotation(
                                                    turns: _controller.value *
                                                        0.02,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    child: _buildImage(isSmall),
                                                  )
                                                : _buildImage(isSmall),

                                            // تأثير لمعان عند الضغط
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
                                ),

                                // الجزء السفلي مع تأثير التموج
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // العنوان مع تأثير التكبير
                                      Transform.scale(
                                        scale: 1.0 + (0.05 * _controller.value),
                                        child: Text(
                                          widget.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isSmall ? 14 : 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      // مؤشر تفاعل متحرك
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.only(top: 6),
                                        width: isSmall
                                            ? 20 + (4 * _controller.value)
                                            : 24 + (6 * _controller.value),
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
                              ],
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
        },
      ),
    );
  }

  Widget _buildImage(bool isSmall) {
    return widget.image != null
        ? Image.asset(
            widget.image!,
            fit: BoxFit.contain,
            width: isSmall ? 60 : 80,
            height: isSmall ? 60 : 80,
            filterQuality: FilterQuality.high,
          )
        : Icon(
            widget.icon ?? Icons.category_outlined,
            size: isSmall ? 40 : 50,
            color: Mycolors().myColor,
          );
  }
}
