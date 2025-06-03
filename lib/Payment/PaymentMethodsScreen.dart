import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final String userName;
  final String userPhone;

  const PaymentMethodsScreen({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl, // هذا السطر يضمن أن اتجاه النص RTL
        child: Scaffold(
          appBar: AppBar(
            title: const Text('طرق الدفع المتاحة'),
            centerTitle: true,
            backgroundColor: Mycolors().myColor,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildPaymentMethodCard(
                  icon: Icons.account_balance_wallet,
                  title: 'محفظة جوالي',
                  instructions: '''
1. افتح تطبيق جوالي واختر "تحويل أموال"
2. أدخل الرقم التالي: 770883615
3. تأكد من مطابقة المعلومات:
   - الاسم: $userName
   - رقم الهاتف: $userPhone
4. أرسل صورة الإيصال عبر التطبيق''',
                  color: Colors.blue[100]!,
                ),
                const SizedBox(height: 20),
                _buildPaymentMethodCard(
                  icon: Icons.delivery_dining,
                  title: 'الدفع عند الاستلام',
                  instructions: '''
• سيتم الاتصال بك على الرقم $userPhone لتأكيد العنوان
• يمكنك فحص المنتج قبل السداد
• نقداً فقط عند التسليم
• خدمة الدفع عند الاستلام متاحة لمعظم المناطق''',
                  color: Colors.green[100]!,
                ),
                const SizedBox(height: 20),
                _buildPaymentMethodCard(
                  icon: Icons.account_balance,
                  title: 'كريمي',
                  instructions: '''
1. اختر "تحويل أموال" في تطبيق كريمي
2. أدخل معلومات الحساب:
   - المستلم: ايمن توفيق عبدالودود
   - الرقم: 770883615
3. أضف ملاحظة تحتوي على:
   - اسمك: $userName
   - رقم طلبك''',
                  color: Colors.orange[100]!,
                ),
                const SizedBox(height: 20),
                _buildPaymentMethodCard(
                  icon: Icons.phone_android,
                  title: 'محفظة جيب',
                  instructions: '''
1. اختر "إرسال أموال" في تطبيق جيب
2. أدخل رقم المحفظة: 770883615
3. تأكد من:
   - مطابقة اسم المرسل ($userName)
   - إضافة رقم الهاتف ($userPhone)
4. سيصلك تأكيد الدفع عبر الوتساب''',
                  color: Colors.purple[100]!,
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نصائح مهمة:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.right, // محاذاة النص لليمين
                      ),
                      const SizedBox(height: 10),
                      _buildTipItem(
                          '✓ تأكد من مطابقة بياناتك المسجلة في التطبيق '),
                      _buildTipItem('✓ احفظ إيصال الدفع حتى تأكيد الطلب'),
                      _buildTipItem(
                          '✓ الطلبات المؤكدة قبل 3 مساءً تُشحن في نفس اليوم'),
                      _buildTipItem('✓ للاستفسارات اتصل بنا على 770883615'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required String instructions,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // تغيير المحاذاة لليمين
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // تغيير محاذاة الصف لليمين
              children: [
                Text(title,
                    // textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Icon(icon, size: 30),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              instructions,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right, // محاذاة النص لليمين
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // تغيير المحاذاة لليمين
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right, // محاذاة النص لليمين
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.circle, size: 8),
        ],
      ),
    );
  }
}
