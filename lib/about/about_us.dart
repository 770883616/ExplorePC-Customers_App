import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن Explore PC'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),
      body: Directionality(
        // إضافة Directionality لجعل النص RTL
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 30),
              _buildMissionSection(),
              const SizedBox(height: 30),
              _buildFeaturesSection(),
              const SizedBox(height: 30),
              _buildTeamSection(),
              const SizedBox(height: 40),
              _buildContactButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                image: AssetImage('images/Explore.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Explore PC',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'متجرك المتكامل لجميع احتياجات الحواسيب والمستلزمات التقنية',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'رؤيتنا ورسالتنا',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'نهدف في Explore PC إلى توفير أحدث التقنيات وأجود المنتجات بأسعار تنافسية، مع تقديم تجربة شراء مميزة ودعم فني متكامل.',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.store, 'تأسسنا في: 2025'),
            _buildInfoRow(Icons.location_pin, 'اليمن ,   صنعاء'),
            _buildInfoRow(Icons.people, 'أكثر من 50,000 عميل راضٍ'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        textDirection: TextDirection.rtl, // جعل اتجاه الصف RTL
        children: [
          Icon(icon, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'لماذا نحن؟',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildFeatureCard(
                Icons.local_shipping, 'شحن سريع', 'توصيل خلال 24-48 ساعة'),
            _buildFeatureCard(
                Icons.verified_user, 'منتجات أصلية', 'ضمان على جميع المنتجات'),
            _buildFeatureCard(
                Icons.support_agent, 'دعم فني', 'خدمة عملاء 24/7'),
            _buildFeatureCard(
                Icons.credit_card, 'دفع آمن', 'خيارات دفع متعددة'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Icon(icon, size: 30, color: Colors.blue.shade800)),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'فريقنا',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTeamMember('images/AYMAN.jpg', 'أيمن توفيق ', 'مبرمج '),
              _buildTeamMember('assets/team2.jpg', ' حسام الصايدي', 'مبرمج'),
              _buildTeamMember('assets/team3.jpg', ' رامي القدسي', 'باحث '),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String image, String name, String position) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15), // تغيير right إلى left لتناسب RTL
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(image),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
              child: Text(name,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: Text(
              position,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 24),
        label: const Text(
          'تواصل معنا عبر واتساب',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        onPressed: () => _launchWhatsApp(context),
      ),
    );
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final phone = '+967770883615';
    final message = 'مرحباً، أريد الاستفسار عن منتجات Explore PC';
    final url = 'https://wa.me/$phone/?text=${Uri.encodeFull(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح WhatsApp')),
      );
    }
  }
}
