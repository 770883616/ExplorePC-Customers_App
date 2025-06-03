import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/sections.dart';
import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
class Cart with ChangeNotifier {
  // List<Computer> _items = [];
  // List<Sections> _itemssection = [];
  double _price = 0.0;
  // void add(Computer item) {
  //   _items.add(item);
  //   _price += item.price!;
  //   notifyListeners();
  // }

  final List<Computer> _basketItems = [];
  final Map<int, int> _productQuantities = {}; // <productId, quantity>

  List<Computer> get backetitem => _basketItems;

  // إضافة منتج إلى السلة
  void add(Computer product) {
    if (!_basketItems.any((item) => item.productId == product.productId)) {
      _basketItems.add(product);
      _productQuantities[product.productId!] = 1;
      notifyListeners();
    }
  }

  // إزالة منتج من السلة
  void remove(Computer product) {
    _basketItems.removeWhere((item) => item.productId == product.productId);
    _productQuantities.remove(product.productId);
    notifyListeners();
  }

  // تحديث كمية منتج معين
  void updateQuantity(int productId, int newQuantity) {
    if (_productQuantities.containsKey(productId)) {
      _productQuantities[productId] = newQuantity;
      notifyListeners();
    }
  }

  // الحصول على كمية منتج معين
  int getQuantity(int productId) {
    return _productQuantities[productId] ?? 1;
  }

  // الحصول على السعر الكلي
  double get totalPrice {
    double total = 0.0;
    for (var item in _basketItems) {
      total += item.price! * getQuantity(item.productId!);
    }
    return total;
  }

  bool isInCart(Computer item) {
    return _productQuantities.containsKey(item.productId);
  }

  void addSections(Computer item) {
    _basketItems.add(item);

    _price += item.price;
    notifyListeners();
  }

  // void remove(Computer item) {
  //   _items.remove(item);
  //   _price -= item.price!;
  //   notifyListeners();
  // }

  void removeSections(Computer item) {
    _basketItems.remove(item);
    _price -= item.price!;
    notifyListeners();
  }

  void clearCart() {
    _basketItems.clear();
    _productQuantities.clear();
    // _itemssection.clear();
    _price = 0.0;
    notifyListeners();
  }

  int getTotalItemCount() {
    return _productQuantities.values.fold(0, (sum, quantity) => sum + quantity);

    // أو باستخدام القائمة:
    // return _basketItems.fold(0, (sum, item) => sum + getQuantity(item.productId!));
  }

  int get count {
    int c = _basketItems.length;
    // int s = _itemssection.length;
    return c;
  }

  double get totilprice {
    return _price;
  }

  // List<Computer> get backetitem {
  //   return _items;
  // }

  // List<Sections> get backetitemsection {
  //   return _itemssection;
  // }

  // final Map<int, int> _productsQuantity = {};

  // void updateQuantity(int productId, int quantity) {
  //   _productsQuantity[productId] = quantity;
  //   notifyListeners();
  // }

  // int getQuantity(int productId) {
  //   return _productsQuantity[productId] ?? 1;
  // }
}
