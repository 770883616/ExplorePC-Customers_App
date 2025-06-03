import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/models/cart.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/widgets/my_continer_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.backetitem.length,
                itemBuilder: (context, index) {
                  final item = cart.backetitem[index];
                  return MycontinerCart(
                    title: item.name,
                    image: item.image,
                    price: item.price,
                    productId: item.productId,
                    initialQuantity: cart.getQuantity(item.productId!),
                    onQuantityChanged: (newQuantity) {
                      cart.updateQuantity(item.productId!, newQuantity);
                    },
                    onRemove: () => cart.remove(item),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'المجموع: \$${cart.totalPrice.toStringAsFixed(2)}',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
