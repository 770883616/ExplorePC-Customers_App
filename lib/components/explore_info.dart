import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void showAppInfoDialog(BuildContext context) {
  final phone = '+967770883615';
  final message = 'مرحباً، أريد الاستفسار عن منتجات Explore PC';
  final url = 'https://wa.me/$phone/?text=${Uri.encodeFull(message)}';
  Future<void> _launchInstagram() async {
    const instagramUrl = 'https://www.instagram.com/besho_7a';
    final uri = Uri.parse(instagramUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'تعذر فتح الإنستجرام: $instagramUrl';
    }
  }

  Future<void> _launchFacebook() async {
    const facebookUrl = 'https://www.facebook.com/share/19WdAYfwkz/';
    final uri = Uri.parse(facebookUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('تعذر فتح الرابط: $e');
    }
  }

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Mycolors().myColor,
              const Color.fromARGB(124, 152, 144, 155)
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.computer, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  "Explore PC",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // App Description
            Text(
              "متجرك المتكامل لجميع احتياجات الحواسيب والمستلزمات التقنية. نوفر أحدث الأجهزة بأفضل الأسعار مع ضمان الجودة والموثوقية.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Tajawal',
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),

            SizedBox(height: 25),

            // Features List
            _buildFeatureItem(Icons.verified, "منتجات أصلية بضمان رسمي"),
            _buildFeatureItem(
                Icons.local_shipping, "توصيل سريع لجميع أنحاء العاصمة صنعاء"),
            _buildFeatureItem(Icons.support_agent, "دعم فني متخصص 24/7"),
            _buildFeatureItem(Icons.security, "دفع آمن عبر قنوات متعددة"),

            SizedBox(height: 30),

            // Contact & Version
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    final url = Uri.parse('tel:+967770883615');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: Colors.white),
                      SizedBox(width: 5),
                      Text("اتصل بنا", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Text(
                  "الإصدار 1.0.0",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Social Media
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: const Color.fromARGB(255, 0, 255, 8),
                    icon: FaIcon(FontAwesomeIcons.whatsapp, size: 24),
                    //  Image.asset('assets/icons/twitter.png', width: 30),
                    onPressed: () => _launchUrl(url),
                  ),
                  IconButton(
                    color: const Color.fromARGB(255, 214, 7, 255),
                    icon: FaIcon(FontAwesomeIcons.instagram),
                    //  Image.asset('assets/icons/instagram.png', width: 30),
                    onPressed: () => _launchInstagram(),
                  ),
                  IconButton(
                    color: const Color.fromARGB(255, 0, 55, 255),
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    // Image.asset('assets/icons/snapchat.png', width: 30),
                    onPressed: () => _launchFacebook(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildFeatureItem(IconData icon, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tajawal',
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(width: 10),
        Icon(icon, color: Colors.white, size: 20),
      ],
    ),
  );
}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
