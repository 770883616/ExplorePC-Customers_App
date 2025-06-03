import 'dart:convert';
import 'package:explore_pc/Payment/PaymentMethodsScreen.dart';
import 'package:explore_pc/auth/edit_custom.dart';
import 'package:explore_pc/notification/notification_provider.dart';
import 'package:explore_pc/setting/my_setting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:explore_pc/Map/map_screen.dart';
import 'package:explore_pc/auth/sign_in.dart';
import 'package:explore_pc/auth/user_provider.dart';
import 'package:explore_pc/chat/explore_ai.dart';
import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/constant/linkapi.dart';
// import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/order/OrdersScreen.dart';
import 'package:explore_pc/widgets/mylisttileuser.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mime/mime.dart';

// import 'package:permission_handler/permission_handler.dart';

class MyAccountUser extends StatefulWidget {
  const MyAccountUser({super.key});

  @override
  State<MyAccountUser> createState() => _MyAccountUserState();
}

class _MyAccountUserState extends State<MyAccountUser> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  File? _imageFile;
  Map<String, dynamic>? imagePath;
  String? _customerImageUrl;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fetchAndSetCustomerImage(_userData!['UserId']);
    // });

    // fetchCustomerImage(_userData!['UserId']);

    // print(imagePath!['Image']);
    //  _loadUserData().then((_) => _loadLocalImage());
    // _loadLocalImage();
    // _loadSavedImage(); // تحميل الصورة المحفوظة
  }

  // Future<void> _loadSavedImage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final imageString = prefs.getString('profile_image');

  //   if (imageString != null && mounted) {
  //     setState(() {
  //       _imageFile = File.fromRawPath(base64Decode(imageString));
  //     });
  //   }
  // }

  Future<bool> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // final status = await Permission.photos.request();
        // return status.isGranted;
      }
      return true; // iOS يكفي إضافة الوصف في Info.plist
    } catch (e) {
      debugPrint('خطأ في الصلاحيات: $e');
      return false;
    }
  }

  // Future<bool> _checkAndRequestPermissions() async {
  //   if (Platform.isAndroid) {
  //     final status = await Permission.photos.status;
  //     if (!status.isGranted) {
  //       final result = await Permission.photos.request();
  //       return result.isGranted;
  //     }
  //     return true;
  //   }
  //   return true; // iOS لا يحتاج طلب صلاحيات هنا
  // }

  // Future<void> _saveImageLocally(File imageFile) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final bytes = await imageFile.readAsBytes();
  //   final base64Image = base64Encode(bytes);
  //   await prefs.setString('profile_image', base64Image);
  // }

  // Future<void> _loadLocalImage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final image = prefs.getString('profile_image');

  //   if (image != null && mounted) {
  //     setState(() {
  //       _userData!['Image'] = image;
  //     });
  //   }
  // }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        // حفظ الصورة محلياً
        // await _saveImageLocally(_imageFile!);

        // هنا نستدعي دالة تحديث الصورة على السيرفر
        await _updateProfileImage(_imageFile!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
        );
      }
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _loadUserData() async {
    final userData = await UserProvider.getUserData();
    // final imageuser = await UserProvider.getimage();
    setState(() {
      _userData = userData;
      _isLoading = false;
      _loadCustomerImage();
      // imagePath = imageuser;
    });
  }

  // Future<Map<String, dynamic>> setaddress() async {

  // }

  Future<void> _logout() async {
    // عرض AlertDialog مع تنسيقات مخصصة
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // لا يغلق عند الضغط خارج الصندوق
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Mycolors().myColorbackgrond,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // زوايا مدورة
          ),
          title: const Text(
            'تأكيد تسجيل الخروج',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red, // لون العنوان
            ),
            textAlign: TextAlign.center, // محاذاة النص إلى الوسط
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround, // توزيع الأزرار
          actions: [
            // زر "لا" - يبقى في الصفحة
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[800], // لون النص
                backgroundColor: Colors.grey[200], // لون الخلفية
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'لا',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(false), // إرجاع false
            ),

            // زر "نعم" - تسجيل الخروج
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // لون أحمر
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'نعم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final notificationProvider =
                    Provider.of<NotificationProvider>(context, listen: false);
                await notificationProvider.clearAll();
                Navigator.of(context).pop(true);
              }, // إرجاع true
            ),
          ],
        );
      },
    );

    // إذا وافق المستخدم على الخروج (confirmLogout == true)
    if (confirmLogout ?? false) {
      await UserProvider.logout(); // تنفيذ تسجيل الخروج
      if (mounted) {
        // التحقق من أن الـ widget لا يزال موجودًا في الشجرة
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    }
    // إذا لم يوافق (confirmLogout == false)، لا تفعل شيئًا (يبقى في الصفحة)
  }

  Future<void> _updateProfileImage(File imageFile) async {
    try {
      // إنشاء FormData لرفع الملف
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$LinkServerName/api/customs/${_userData!['UserId']}/update-image'),
      );

      // إضافة الصورة
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // يجب أن يتطابق مع اسم الحقل في Laravel
          imageFile.path,
        ),
      );

      // إضافة headers
      request.headers['Accept'] = 'application/json';
      // request.headers['Authorization'] = 'Bearer $token'; // تفعيل عند وجود مصادقة

      // إرسال الطلب
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        await _loadUserData();
        // تحديث حالة التطبيق بالصورة الجديدة
        setState(() {
          _userData!['Image'] = jsonResponse['data']['image_url'];
        });

        // إظهار رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث الصورة بنجاح')),
        );

        // هنا يمكنك حفظ الصورة في SharedPreferences إذا لزم الأمر
        // await UserProvider.saveImage({'Image': jsonResponse['data']['image_url']});
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to update image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
      debugPrint('Error updating image: $e');
    }
  }

  Future<void> _loadCustomerImage() async {
    try {
      final response = await http.get(
        Uri.parse('$LinkServerName/api/customs/${_userData!['UserId']}/image'),
        headers: {'Accept': 'application/json'},
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        setState(() {
          _customerImageUrl =
              '$LinkServerName${jsonResponse['data']['image_url']}';
        });
      }
    } catch (e) {
      debugPrint('Error loading customer image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      mywidget: _isLoading
          ? Center(
              child: SpinKitSquareCircle(size: 50.0, color: Mycolors().myColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Column(
                  children: [
                    // قسم معلومات المستخدم
                    _buildUserProfileSection(context),
                    const SizedBox(height: 24),

                    // خط فاصل
                    _buildDivider(),
                    const SizedBox(height: 24),

                    // قائمة الخيارات
                    _buildOptionsList(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: Mycolors().myColor,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.qr_code,
                  color: Mycolors().myColor,
                )),
          ],
        ),

        // صورة المستخدم
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Mycolors().myColor.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _customerImageUrl != null
                          ? NetworkImage(_customerImageUrl!)
                          : AssetImage('images/Explore.jpg') as ImageProvider,
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Mycolors().myColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 20),
                    onPressed: () => _showImageSourceDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // اسم المستخدم
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _userData?['UserName'] ?? "ضيف",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.person_outline,
              color: Mycolors().myColor,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _userData?['email'] ?? "لا يوجد بريد إلكتروني",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.email_outlined,
              color: Mycolors().myColor,
              size: 20,
            ),
          ],
        ),
        // البريد الإلكتروني
        // Text(
        //   _userData?['email'] ?? "لا يوجد بريد إلكتروني",
        //   style: TextStyle(
        //     fontSize: 16,
        //     color: Colors.grey[600],
        //   ),
        // ),
        const SizedBox(height: 16),

        // أزرار التعديل
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.update_rounded,
              label: "تعديل الصورة",
              onPressed: () => _showImageSourceDialog(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.mode_edit,
                label: "تعديل الملف الشخصي",
                onPressed: () => _navigateToEditProfile(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      // barrierColor: Colors.white,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mycolors().myColorbackgrond,
        title: const Text(
          "اختر مصدر الصورة",
          textAlign: TextAlign.right,
        ),
        content: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(
                "الكاميرا",
              ),
              leading: const Icon(
                Icons.camera,
              ),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("المعرض"),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String text,
    required ImageSource source,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: () async {
        Navigator.of(context).pop(); // إغلاق الديالوج أولاً
        if (await _requestPermissions()) {
          await _pickImage(source);
        }
      },
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    ).then((updated) async {
      if (updated == true) {
        await _loadUserData();
        setState(() {});
        // إعادة تحميل بيانات المستخدم
        // تم التحديث بنجاح، يمكنك تحديث الواجهة إذا لزم الأمر
      }
    });
    // يمكنك إنشاء صفحة لتعديل الملف الشخصي هنا
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Mycolors().myColor,
        boxShadow: [
          BoxShadow(
            color: Mycolors().myColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey[300],
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // الزر الجديد للذكاء الاصطناعي
          Mylisttile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            title: "اسأل الذكاء الاصطناعي", // أو أي اسم تفضله
            leading: Icon(Icons.smart_toy, color: Mycolors().myColor),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
          ),

          _buildListDivider(),
          Mylisttile(
            onTap: () async {
              final selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfessionalLocationPicker(
                    onLocationSaved: (location) {
                      // حفظ الموقع في قاعدة البيانات
                    },
                  ),
                ),
              );

              if (selectedLocation != null) {
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.setString(
                // '$selectedLocation', _userData!['Address']);

                await UserProvider.saveaddress({
                  'Address': selectedLocation.toString(),
                });

                final userData = await UserProvider.getaddress();
                if (userData['isLoggedIn'] == true) {
                  // print('User Name: ${userData['UserName']}');
                  // print('Address: ${userData['Address']}');
                  // استخدم البيانات كما تحتاج
                }

                print('Address: ${userData['Address']}'
                    // selectedLocation.toString(),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تحديث الموقع بنجاح')),
                );
              }
            },
            title: "العنوان",
            leading:
                Icon(AntDesign.environment_twotone, color: Mycolors().myColor),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
          ),
          _buildListDivider(),
          Mylisttile(
            onTap: () {
              if (_userData?['UserId'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrdersScreen(userId: _userData!['UserId']),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
                );
              }
            },
            title: "الطلبات",
            leading:
                Icon(Icons.shopping_bag_rounded, color: Mycolors().myColor),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
          ),
          _buildListDivider(),
          Mylisttile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentMethodsScreen(
                    userName: _userData!['UserName'],
                    userPhone: _userData!['Phone'].toString(),
                  ),
                ),
              );
            },
            title: "طرق الدفع",
            leading: Icon(Icons.payment, color: Mycolors().myColor),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
          ),

          _buildListDivider(),
          Mylisttile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            title: "الاعدادات",
            leading: Icon(Icons.settings, color: Mycolors().myColor),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
          ),
          _buildListDivider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: Mylisttile(
              onTap: _logout,
              title: "تسجيل الخروج",
              leading: Icon(Icons.logout_outlined, color: Colors.red[400]),
              trailing: const Icon(Icons.chevron_left, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey[200],
      ),
    );
  }
}
