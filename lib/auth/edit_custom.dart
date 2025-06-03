import 'package:explore_pc/auth/user_provider.dart';
import 'package:explore_pc/components/valid.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/widgets/mytext_form_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingInitialData = true;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserProvider.getUserData();
      setState(() {
        _userData = userData;
        _nameController.text = userData['UserName'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['Phone'] ?? '';
        _addressController.text = userData['Address'] ?? '';
        _isLoadingInitialData = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل بيانات المستخدم';
        _isLoadingInitialData = false;
      });
    }
  }

  Future<void> updateProfile() async {
    // التحقق من صحة النموذج أولاً
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // جلب بيانات المستخدم الحالية
      final userData = await UserProvider.getUserData();
      final userId = userData['UserId'];

      // إعداد بيانات الطلب
      final Map<String, dynamic> requestData = {
        'UserName': _nameController.text,
        'email': _emailController.text,
        'Phone': _phoneController.text,
        'Address': _addressController.text,
      };

      // إضافة كلمة المرور فقط إذا تم إدخالها
      if (_passwordController.text.isNotEmpty) {
        requestData['UserPassword'] = _passwordController.text;
      }

      // إرسال طلب التحديث
      final response = await http.post(
        Uri.parse('$LinkServerName/api/customer/$userId/update'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // تحديث بيانات المستخدم المحلية
        final updatedUserData = {
          'UserId': userId,
          'UserName': _nameController.text,
          'email': _emailController.text,
          'Phone': _phoneController.text,
          'Address': _addressController.text,
          'Image': userData['Image'], // الاحتفاظ بنفس الصورة
        };

        await UserProvider.saveUserData(updatedUserData);
        Navigator.pop(context, true); // العودة إلى الصفحة السابقة
        // إظهار رسالة النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الملف الشخصي بنجاح'),
            duration: Duration(seconds: 2),
          ),
        );

        // إعادة تحميل الصفحة
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => ProfilePage()),
        // );
      } else {
        // معالجة أخطاء التحقق
        setState(() {
          _errorMessage = _parseError(responseData);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء التحديث: ${e.toString()}';
      });
      debugPrint('Error updating profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// دالة مساعدة لتحليل رسائل الخطأ
  String _parseError(Map<String, dynamic> responseData) {
    if (responseData['errors'] != null) {
      final errors = responseData['errors'] as Map<String, dynamic>;
      return errors.values.join('\n');
    }
    return responseData['message'] ?? 'فشل في تحديث البيانات';
  }

  @override
  Widget build(BuildContext context) {
    final myColor = Mycolors().myColor;

    return Scaffold(
      backgroundColor: Mycolors().myColorbackgrond,
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        centerTitle: true,
      ),
      body: _isLoadingInitialData
          ? Center(
              child: SpinKitSquareCircle(size: 50.0, color: Mycolors().myColor),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    MyTextFormField(
                      textAlign: TextAlign.right,
                      mycontroller: _nameController,
                      label: "الاسم الكامل",
                      icon: const Icon(Icons.person),
                      valid: (val) => vaildInput(val!, 3, 255),
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      textAlign: TextAlign.right,
                      mycontroller: _emailController,
                      label: "البريد الإلكتروني",
                      icon: const Icon(Icons.email),
                      valid: (val) => vaildInputemail(val!, 5, 255),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      textAlign: TextAlign.right,
                      mycontroller: _passwordController,
                      label: "كلمة المرور (اتركه فارغاً إذا لم ترد التغيير)",
                      icon: const Icon(Icons.lock),
                      valid: (val) {
                        if (val!.isEmpty) return null;
                        return vaildInput(val, 6, 22);
                      },
                      // obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      textAlign: TextAlign.right,
                      mycontroller: _phoneController,
                      label: "رقم الهاتف",
                      icon: const Icon(Icons.phone),
                      valid: validatePhoneNumber,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      textAlign: TextAlign.right,
                      mycontroller: _addressController,
                      label: "العنوان",
                      icon: const Icon(Icons.location_on),
                      valid: (val) => vaildInput(val!, 5, 255),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? SpinKitSquareCircle(
                            size: 50.0, color: Mycolors().myColor)
                        : ElevatedButton(
                            onPressed: _isLoading ? null : updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: _isLoading
                                ? SpinKitSquareCircle(
                                    size: 50.0, color: Mycolors().myColor)
                                : Text(
                                    'حفظ التغييرات',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
