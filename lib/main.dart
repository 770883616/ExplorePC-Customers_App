import 'package:explore_pc/auth/sign_in.dart';
import 'package:explore_pc/components/bottomNigation_home.dart';
import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/components/splashscreen.dart';
import 'package:explore_pc/models/cart.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/notification/notification_provider.dart';
import 'package:explore_pc/onboardingscreens/fristpage.dart';
import 'package:explore_pc/onboardingscreens/onepage.dart';
import 'package:explore_pc/widgets/mycirclstart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // تأكيد تهيئة Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        // Provider لعربة التسوق
        ChangeNotifierProvider(create: (context) => Cart()),

        // Provider للإشعارات
        ChangeNotifierProvider(
          create: (context) => NotificationProvider()..loadData(),
          lazy: false, // يتم التهيئة فوراً وليس عند الطلب
        ),

        // يمكن إضافة المزيد من الـ Providers هنا
      ],
      child: MaterialApp(
        color: Mycolors().myColorbackgrond,
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? Splashscreen() : FirstPage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Cart(),
        child: GetMaterialApp(
          locale: Locale('en'),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(iscart: 0),
        ) // تأكد من تمرير iscart إذا كان مطلوبًا
        );
  }
}
