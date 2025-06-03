import 'package:explore_pc/auth/user_provider.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:explore_pc/models/mycolors.dart';

class OrdersScreen extends StatefulWidget {
  final int userId;

  const OrdersScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _loadUserData() async {
    final userData = await UserProvider.getUserData();
    setState(() {
      _userData = userData;
      _isLoading = false;
    });
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$LinkServerName/api/users/${widget.userId}/orders'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          orders = data.map((json) => Order.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors().myColorbackgrondprodect,
      appBar: AppBar(
        backgroundColor: Mycolors().myColorbackgrond,
        title: const Text('طلباتي', style: TextStyle(fontFamily: 'Tajawal')),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: SpinKitSquareCircle(
          size: 50.0,
          color: Mycolors().myColor,
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
          child: Text(errorMessage, style: TextStyle(fontFamily: 'Tajawal')));
    }

    if (orders.isEmpty) {
      return const Center(
        child: Text('لا توجد طلبات سابقة',
            style: TextStyle(fontFamily: 'Tajawal')),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(orders[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        initiallyExpanded: order.items.isNotEmpty,
        title: Row(
          children: [
            Text('#${order.orderId}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            _buildStatusChip(order.status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDate(order.orderDate)),
            Text('${order.totalAmount.toStringAsFixed(2)} \$'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.shippingAddress.isNotEmpty)
                  _buildInfoRow('عنوان الشحن:', order.shippingAddress),
                const SizedBox(height: 16),
                if (order.items.isNotEmpty) ...[
                  const Text('المنتجات:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal')),
                  const Divider(),
                  ...order.items
                      .map((item) => _buildProductItem(item))
                      .toList(),
                ] else
                  const Text('لا توجد منتجات في هذا الطلب',
                      style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                _buildOrderSummary(order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // صورة المنتج
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                    '$LinkServerName/storage/${item.productImage}'),
                fit: BoxFit.cover,
                onError: (_, __) => const Icon(Icons.shopping_bag),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // تفاصيل المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal')),
                if (item.category != null)
                  Text(item.category!,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'Tajawal')),
                Text('الكمية: ${item.quantity}',
                    style: const TextStyle(fontFamily: 'Tajawal')),
              ],
            ),
          ),

          // السعر
          Text('${(item.price * item.quantity).toStringAsFixed(2)} \$',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'مكتمل':
        bgColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'قيد الانتظار':
        bgColor = Colors.orange;
        textColor = Colors.white;
        break;
      case 'ملغى':
        bgColor = Colors.red;
        textColor = Colors.white;
        break;
      default:
        bgColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontSize: 12, fontFamily: 'Tajawal'),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
          Expanded(
              child:
                  Text(value, style: const TextStyle(fontFamily: 'Tajawal'))),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSummaryRow('المجموع:', order.totalAmount.toStringAsFixed(2)),
          const Divider(height: 16),
          _buildSummaryRow('الإجمالي:', order.totalAmount.toStringAsFixed(2),
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isTotal ? Colors.blue : Colors.grey[600],
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Tajawal')),
          Text('$value \$',
              style: TextStyle(
                  color: isTotal ? Colors.blue : Colors.black,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
