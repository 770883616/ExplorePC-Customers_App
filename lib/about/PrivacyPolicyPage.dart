import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // تحديد اتجاه النص RTL
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 25),
              _buildPolicyContent(),
              const SizedBox(height: 30),
              _buildContactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سياسة الخصوصية لـ Explore PC',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'آخر تحديث: 1 يناير 2024',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyContent() {
    const String htmlContent = """
      <div dir='rtl'>
        <h3>1. المعلومات التي نجمعها</h3>
        <p>نجمع المعلومات التالية عند استخدامك لخدماتنا:</p>
        <ul>
          <li>البيانات الشخصية (الاسم، البريد الإلكتروني، رقم الهاتف)</li>
          <li>معلومات الدفع (يتم معالجتها عبر بوابات دفع آمنة)</li>
          <li>بيانات الجهاز وعنوان IP</li>
        </ul>

        <h3>2. كيفية استخدام المعلومات</h3>
        <p>نستخدم البيانات لـ:</p>
        <ul>
          <li>معالجة الطلبات والدفعات</li>
          <li>تحسين تجربة المستخدم</li>
          <li>إرسال تحديثات وعروض خاصة (يمكنك إلغاء الاشتراك في أي وقت)</li>
        </ul>

        <h3>3. مشاركة البيانات</h3>
        <p>لا نبيع بياناتك لأطراف ثالثة. قد نشارك معلومات محدودة مع:</p>
        <ul>
          <li>مقدمي خدمات الدفع</li>
          <li>شركات الشحن</li>
          <li>الجهات الحكومية عند الضرورة القانونية</li>
        </ul>

        <h3>4. حماية البيانات</h3>
        <p>نستخدم تقنيات التشفير (SSL) ونلتزم بمعايير PCI DSS لمعالجة الدفعات.</p>

        <h3>5. حقوقك</h3>
        <p>لديك الحق في:</p>
        <ul>
          <li>الوصول إلى بياناتك الشخصية</li>
          <li>طلب تصحيح أو حذف البيانات</li>
          <li>رفض معالجة البيانات لأغراض تسويقية</li>
        </ul>

        <h3>6. ملفات تعريف الارتباط (Cookies)</h3>
        <p>نستخدم ملفات تعريف الارتباط لتحسين تجربة التصفح. يمكنك إدارتها عبر إعدادات المتصفح.</p>
      </div>
    """;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Html(
          data: htmlContent,
          style: {
            "h3": Style(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              fontSize: FontSize(18),
              textAlign: TextAlign.right, // محاذاة النص لليمين
            ),
            "p": Style(
              lineHeight: LineHeight(1.5),
              fontSize: FontSize(15),
              textAlign: TextAlign.right, // محاذاة النص لليمين
            ),
            "ul": Style(

                // padding: EdgeInsets.only(right: 15),
                ), // تعديل padding لليمين
            "li": Style(
              fontSize: FontSize(14),
            ),
            "div": Style(
              direction: TextDirection.rtl, // تحديد اتجاه النص للعنصر div
            ),
          },
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'للاستفسارات حول الخصوصية:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ListTile(
          leading: const Icon(Icons.email, color: Colors.blue),
          title: const Text('ayman@gmail.com'),
          trailing: IconButton(
            // إضافة زر للاتصال
            icon:
                const Icon(Icons.arrow_back_ios, size: 16), // تعديل اتجاه السهم
            onPressed: () => _launchEmail(),
          ),
          onTap: () => _launchEmail(),
        ),
        ListTile(
          leading: const Icon(Icons.phone, color: Colors.blue),
          title: const Text('+967 770 883 615'),
          trailing: IconButton(
            // إضافة زر للاتصال
            icon:
                const Icon(Icons.arrow_back_ios, size: 16), // تعديل اتجاه السهم
            onPressed: () => _launchPhone(),
          ),
          onTap: () => _launchPhone(),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () => _showConsentDialog(context),
            child: const Text(
              'إدارة تفضيلات الخصوصية',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'ayman@gmail.com',
      host: 'استفسار حول سياسة الخصوصية',
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    }
  }

  Future<void> _launchPhone() async {
    const url = 'tel:+967770883615';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showConsentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl, // جعل اتجاه النص في الحوار RTL
        child: AlertDialog(
          title: const Text('تفضيلات الخصوصية', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('الموافقة على ملفات تعريف الارتباط'),
                value: true,
                onChanged: (v) {},
              ),
              SwitchListTile(
                title: const Text('تلقي عروض ترويجية'),
                value: false,
                onChanged: (v) {},
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حفظ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
