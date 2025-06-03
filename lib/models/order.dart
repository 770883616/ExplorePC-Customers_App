class Order {
  final int orderId;
  final DateTime orderDate;
  final String status;
  final double totalAmount;
  final String shippingAddress;
  final List<OrderItem> items;
  final DateTime createdAt;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.shippingAddress,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
      totalAmount: json['totalAmount'].toDouble(),
      shippingAddress: json['shippingAddress'],
      items: json['items'] != null
          ? List<OrderItem>.from(
              json['items'].map((x) => OrderItem.fromJson(x)))
          : [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class OrderItem {
  final int orderItemId;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final String? category;

  OrderItem({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    this.category,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['orderItemId'],
      productId: json['productId'],
      productName: json['product']['name'] ?? 'غير معروف',
      productImage: json['product']['image'] ?? '',
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      category: json['product']['category'],
    );
  }
}
