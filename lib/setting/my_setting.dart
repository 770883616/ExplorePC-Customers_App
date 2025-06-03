import 'package:explore_pc/components/mycart.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'دولار أمريكي';
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final myColor = Mycolors().myColor; // اللون الرئيسي من كلاسك

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('الإعدادات',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                myColor.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // إعداد المظهر
                _buildSettingCard(
                  icon: Icons.brightness_4_outlined,
                  title: 'المظهر',
                  value: _isDarkMode ? 'مظلم' : 'فاتح',
                  trailing: Switch(
                    value: _isDarkMode,
                    activeColor: myColor,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                  color: myColor,
                ),
                const SizedBox(height: 20),

                // إعداد اللغة
                _buildSettingCard(
                  icon: Icons.language_outlined,
                  title: 'اللغة',
                  value: _selectedLanguage,
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    underline: Container(),
                    icon: Icon(Icons.arrow_drop_down, color: myColor),
                    items: <String>['العربية', 'English']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                  ),
                  color: myColor,
                ),
                const SizedBox(height: 20),

                // إعداد العملة
                _buildSettingCard(
                  icon: Icons.currency_exchange_outlined,
                  title: 'العملة',
                  value: _selectedCurrency,
                  trailing: DropdownButton<String>(
                    value: _selectedCurrency,
                    underline: Container(),
                    icon: Icon(Icons.arrow_drop_down, color: myColor),
                    items: <String>['ريال يمني', 'دولار أمريكي', 'ريال سعودي']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                  ),
                  color: myColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String value,
    required Widget trailing,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(value,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
