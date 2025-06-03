import 'package:flutter/material.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/services.dart';

class MycontinerCart extends StatefulWidget {
  final String? image, title;
  final double? price;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;
  final int initialQuantity;
  final int? productId;

  const MycontinerCart({
    Key? key,
    this.image,
    this.title,
    this.price,
    this.onRemove,
    this.onQuantityChanged,
    this.initialQuantity = 1,
    this.productId,
  }) : super(key: key);

  @override
  _MycontinerCartState createState() => _MycontinerCartState();
}

class _MycontinerCartState extends State<MycontinerCart> {
  late int _quantity;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Mycolors().myColorbackgrond,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _isRemoving
          ? SizeTransition(
              sizeFactor: AlwaysStoppedAnimation(0),
              child: Container(),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // صورة المنتج مع تأثيرات
                      Hero(
                        tag: 'product-image-${widget.productId}',
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                '$LinkServerName/storage/${widget.image}',
                              ),
                              // fit: BoxFit.contain,
                              onError: (_, __) => Icon(Icons.shopping_bag),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // معلومات المنتج
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.price?.toStringAsFixed(2) ?? '0.00'}\$',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // عداد الكمية مع تأثيرات
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                        widget.onQuantityChanged
                                            ?.call(_quantity);
                                        _playVibration();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                    child: Center(
                                      child: Text(
                                        '$_quantity',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                    onPressed: () {
                                      setState(() => _quantity++);
                                      widget.onQuantityChanged?.call(_quantity);
                                      _playVibration();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // زر الحذف مع تأثيرات
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red.withOpacity(0.7),
                        onPressed: () async {
                          setState(() => _isRemoving = true);
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          widget.onRemove?.call();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _playVibration() async {
    try {
      // استخدم selectionClick للكمية و heavyImpact للحذف
      if (widget.onQuantityChanged != null) {
        await HapticFeedback.selectionClick();
      } else if (widget.onRemove != null) {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      debugPrint('Haptic not supported: $e');
    }
  }
}
