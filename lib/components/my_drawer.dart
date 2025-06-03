import 'package:explore_pc/about/PrivacyPolicyPage.dart';
import 'package:explore_pc/about/about_us.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/widgets/mylist_drawer.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors().myColorbackgrondprodect,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, size: 28),
                    color: Mycolors().myColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "القائمة الجانبية",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Mycolors().myColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // General Section
                      _buildSectionHeader("عــام"),
                      const SizedBox(height: 8),
                      _buildSectionContainer([
                        _buildDrawerItem(
                          title: "الملف الشخصي",
                          icon: Icons.person_rounded,
                          onTap: () => _navigateTo(context, '/profile'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "العنــوان",
                          icon: AntDesign.environment_twotone,
                          onTap: () => _navigateTo(context, '/address'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "الفئــات",
                          icon: Icons.category_rounded,
                          onTap: () => _navigateTo(context, '/categories'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "الاشعــارات",
                          icon: Icons.notifications_rounded,
                          onTap: () => _navigateTo(context, '/notifications'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "الاعدادات",
                          icon: Icons.settings,
                          onTap: () => _navigateTo(context, '/settings'),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // Help & Support Section
                      _buildSectionHeader("المســاعدة والدعــم"),
                      const SizedBox(height: 8),
                      _buildSectionContainer([
                        _buildDrawerItem(
                          title: "صندوق الوارد",
                          icon: Icons.message,
                          onTap: () => _navigateTo(context, '/inbox'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "اتصل بنا",
                          icon: Icons.phone,
                          onTap: () => _navigateTo(context, '/contact'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "تذاكر الدعم",
                          icon: Icons.support_agent_sharp,
                          onTap: () => _navigateTo(context, '/support'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                          title: "الشروط والاحكام",
                          icon: Icons.document_scanner_rounded,
                          onTap: () => _navigateTo(context, '/terms'),
                        ),
                        _buildDivider(),
                        _buildDrawerItem(
                            title: "سياسة الخصوصية",
                            icon: Icons.privacy_tip,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage(),
                              ));
                            }),
                        _buildDivider(),
                        _buildDrawerItem(
                            title: "معلومات عنا",
                            icon: Icons.info_outline,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutUsPage(),
                              ));
                            }),
                      ]),

                      const SizedBox(height: 24),

                      // Logout Button
                      _buildDrawerItem(
                        title: "تسجيل الخروج",
                        icon: Icons.logout_outlined,
                        color: Colors.red,
                        onTap: () => _logout(context),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer with version
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "الاصدار 1.1",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Mycolors().myColorbackgrond,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: color ?? Mycolors().myColor, size: 24),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_left, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: Colors.grey[300],
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer first
    Navigator.pushNamed(context, route);
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تسجيل الخروج"),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close drawer
              // Add your logout logic here
            },
            child: Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
