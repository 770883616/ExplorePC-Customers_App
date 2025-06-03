import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  // حفظ بيانات المستخدم
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt(
        'UserId', userData['UserId'] ?? 0); // قيمة افتراضية إذا كانت null
    await prefs.setString('UserName', userData['UserName'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString(
        'Phone', userData['Phone']?.toString() ?? ''); // تحويل إلى String
    await prefs.setString('Address', userData['Address'] ?? '');
    await prefs.setString(
        'Image', userData['Image'] ?? ''); // قيمة افتراضية فارغة
  }

  static Future<void> saveaddress(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Address', userData['Address'] ?? '');
  }

  static Future<void> saveimage(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Image', userData['Image'] ?? '');
  }

  static Future<Map<String, dynamic>> getaddress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'Address': prefs.getString('Address') ?? '', // قيمة افتراضية فارغة
    };
  }

  static Future<Map<String, dynamic>> getimage() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'Image': prefs.getString('Image') ?? '', // قيمة افتراضية فارغة
    };
  }

  // جلب بيانات المستخدم
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool('isLoggedIn') ?? false,
      'UserId': prefs.getInt('UserId'),
      'UserName': prefs.getString('UserName'),
      'email': prefs.getString('email'),
      'Phone': prefs.getString('Phone'),
      'Address': prefs.getString('Address'),
      'Image': prefs.getString('Image'),
    };
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // أو استخدم remove لكل مفتاح على حدة
  }
}

// في أي صفحة تريد الوصول إلى بيانات المستخدم
Future<void> _loadUserData() async {
  final userData = await UserProvider.getUserData();
  if (userData['isLoggedIn'] == true) {
    print('User Name: ${userData['UserName']}');
    print('Email: ${userData['email']}');
    // استخدم البيانات كما تحتاج
  }
}

// ElevatedButton(
//   onPressed: () async {
//     await UserProvider.logout();
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => Login()),
//     );
//   },
//   child: Text('تسجيل الخروج'),
// )
