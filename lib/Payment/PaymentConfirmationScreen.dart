import 'package:explore_pc/components/bottomNigation_home.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final int orderId;
  final String paymentMethod;

  const PaymentConfirmationScreen({
    Key? key,
    required this.orderId,
    required this.paymentMethod,
  }) : super(key: key);

  String _getPaymentMethodDetails() {
    switch (paymentMethod) {
      case 'محفظة جوالي':
        return 'الرجاء التحويل إلى الحساب البنكي: 770883615';
      case 'الدفع عند الاستلام':
        return 'سيتم الدفع عند استلام الطلب';
      case 'كريمي':
        return 'الرجاء استخدام تطبيق كريمي للدفع ايداع الي حساب (ايمن توفيق عبدالودود)';
      case 'محفظة جيب':
        return 'الرجاء التحويل إلى حساب محفظة جيب : 770883615';
      default:
        return 'تم استلام طلب الدفع بنجاح';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('تمت العملية بنجاح'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'شكراً لك!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'رقم طلبك: #$orderId',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 15),
              Text(
                'طريقة الدفع: $paymentMethod',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getPaymentMethodDetails(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Mycolors().myColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'العودة للصفحة الرئيسية',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
