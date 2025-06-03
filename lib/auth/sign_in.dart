import 'package:explore_pc/auth/ForgotPasswordPage.dart';
import 'package:explore_pc/auth/ResetPasswordPage.dart';
import 'package:explore_pc/auth/user_provider.dart';
import 'package:explore_pc/components/bottomNigation_home.dart';
import 'package:explore_pc/components/valid.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/auth/sign_up.dart';
import 'package:explore_pc/notification/notification_provider.dart';
import 'package:explore_pc/widgets/mytext_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color _myColor = Mycolors().myColor;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.28:8000/api/customer/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'UserPassword':
              _passwordController.text.trim(), // تأكد من استخدام الحقل الصحيح
        }),
      );

      final responseData = jsonDecode(response.body);
      print(responseData); // لرؤية الاستجابة الكاملة

      if (response.statusCode == 200) {
        final customer = responseData['customer'];
        final notificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);
        await notificationProvider.loadData();
        // التحقق من القيم قبل الحفظ
        await UserProvider.saveUserData({
          'UserId': customer['UserId'],
          'UserName': customer['UserName'] ?? 'غير معروف',
          'email': customer['email'],
          'Phone': customer['Phone']?.toString() ?? '', // تحويل إلى String
          'Address': customer['Address'] ?? '',
          'Image': customer['Image'] ?? '', // معالجة قيمة null
        });

        // إذا كان المستخدم اختار "تذكرني" احفظ بيانات الدخول
        // if (_rememberMe) {
        //   await prefs.setString('savedEmail', _emailController.text);
        //   await prefs.setString('savedPassword', _passwordController.text);
        //   await prefs.setBool('rememberMe', true);
        // } else {
        //   await prefs.remove('savedEmail');
        //   await prefs.remove('savedPassword');
        //   await prefs.setBool('rememberMe', false);
        // }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyHomePage(iscart: 2),
            ),
            (route) => false);
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'بيانات الدخول غير صحيحة';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطاء في الاتصال بالخادم: ';
        //  ${e.toString()}';
      });
      print('Error details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  // Future<void> _login() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   try {
  //     final response = await http.post(
  //       Uri.parse(LinkLogin),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': _emailController.text,
  //         'UserPassword': _passwordController.text.toString(),
  //       }),
  //     );

  //     final responseData = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       // تسجيل الدخول ناجح
  //       final customer = responseData['customer'];

  //       // حفظ بيانات المستخدم في SharedPreferences
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('isLoggedIn', true);
  //       await prefs.setInt('UserId', customer['UserId']);
  //       await prefs.setString('UserName', customer['UserName']);
  //       await prefs.setString('email', customer['email']);
  //       await prefs.setString('Phone', customer['Phone'].toString());
  //       await prefs.setString('Address', customer['Address']);
  //       await prefs.setString('Image', customer['Image']);

  //       // إذا كان المستخدم اختار "تذكرني" احفظ بيانات الدخول
  //       if (_rememberMe) {
  //         await prefs.setString('savedEmail', _emailController.text);
  //         await prefs.setString('savedPassword', _passwordController.text);
  //         await prefs.setBool('rememberMe', true);
  //       } else {
  //         await prefs.remove('savedEmail');
  //         await prefs.remove('savedPassword');
  //         await prefs.setBool('rememberMe', false);
  //       }

  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => MyHomePage(iscart: 2)),
  //       );
  //     } else {
  //       // خطأ في تسجيل الدخول
  //       setState(() {
  //         _errorMessage = responseData['message'] ?? 'بيانات الدخول غير صحيحة';
  //         if (responseData['errors'] != null) {
  //           _errorMessage = responseData['errors']['email']?.join(', ') ??
  //               'بيانات الدخول غير صحيحة';
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'فشل في التسجيل: ${e.toString()}';
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // تحميل بيانات "تذكرني" عند بدء التشغيل
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('savedEmail') ?? '';
        _passwordController.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            // padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/login.png',
                      width: screenWidth / 2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),

                  // رسالة الخطأ
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  MyTextFormField(
                    valid: (val) {
                      if (val!.isEmpty) return 'البريد الإلكتروني مطلوب';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'البريد الإلكتروني غير صالح';
                      }
                      return null;
                    },
                    mycontroller: _emailController,
                    label: "البريد الإلكتروني",
                    icon: Icon(Icons.email),
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 30),

                  MyTextFormField(
                    valid: (val) {
                      if (val != null) {
                        return vaildInput(val, 6, 20);
                      }
                      if (val!.isEmpty) return 'كلمة المرور مطلوبة';

                      return null;
                    },
                    mycontroller: _passwordController,
                    label: "كلمة المرور",
                    icon: Icon(Icons.lock),
                    textAlign: TextAlign.left,
                    // obscureText: true,
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ));
                          // يمكنك إضافة صفحة استعادة كلمة المرور لاحقاً
                        },
                        child: Text(
                          "هل نسيت كلمة المرور؟",
                          style: TextStyle(color: _myColor),
                        ),
                      ),
                      Row(
                        children: [
                          Text("تذكرني"),
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: _myColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  _isLoading
                      ? SpinKitSquareCircle(
                          size: 50.0,
                          color: Mycolors().myColor,
                        )
                      : SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _myColor,
                              foregroundColor: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "دخــول",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                  SizedBox(height: 30),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: Text(
                      "ليس لديك حساب؟ إنشاء حساب",
                      style: TextStyle(color: _myColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
