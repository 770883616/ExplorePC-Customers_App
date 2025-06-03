import 'package:explore_pc/Payment/PaymentConfirmationScreen.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final dynamic orderId;
  final dynamic totalAmount;

  const PaymentScreen({
    Key? key,
    required this.orderId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod;
  bool isLoading = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'الدفع عند الاستلام',
      'icon': Icons.delivery_dining,
      'color': Colors.orange,
    },
    {
      'name': 'محفظة جوالي',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'name': 'كريمي',
      'icon': Icons.payment,
      'color': Colors.blue,
    },
    {
      'name': 'محفظة جيب',
      'icon': Icons.wallet,
      'color': Colors.purple,
    },
  ];

  Future<void> _processPayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار طريقة الدفع')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$LinkServerName/api/orders/${widget.orderId}/payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'payment_method': selectedPaymentMethod,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentConfirmationScreen(
              orderId: widget.orderId,
              paymentMethod: selectedPaymentMethod!,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        throw Exception(responseData['message'] ?? 'حدث خطأ غير متوقع');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors().myColorbackgrond,
      appBar: AppBar(
        backgroundColor: Mycolors().myColorbackgrond,
        title: const Text('اختر طريقة الدفع'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // بطاقة تفاصيل الطلب
            Card(
              color: Mycolors().myColorbackgrondprodect,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'تفاصيل الطلب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${widget.orderId}#'),
                        const Text(':رقم الطلب'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.totalAmount.toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(':المبلغ الإجمالي'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // طرق الدفع
            const Text(
              'طرق الدفع المتاحة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    color: selectedPaymentMethod == method['name']
                        ? method['color'].withOpacity(0.1)
                        : null,
                    child: ListTile(
                      trailing: Icon(method['icon'], color: method['color']),
                      title: Text(
                        method['name'],
                        textAlign: TextAlign.right,
                      ),
                      leading: selectedPaymentMethod == method['name']
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = method['name'];
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // زر تأكيد الدفع
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Mycolors().myColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? SpinKitSquareCircle(size: 50.0, color: Mycolors().myColor)
                    : const Text(
                        'تأكيد الدفع',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
