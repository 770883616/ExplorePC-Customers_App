import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/models/sections.dart';
import 'package:explore_pc/sections/category_gridItem.dart';
import 'package:explore_pc/sections/class_subcategoreis.dart';
import 'package:explore_pc/sections/get_product_category.dart';
import 'package:explore_pc/sections/sub_categories_page.dart';
import 'package:explore_pc/widgets/My_snakbar_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      mywidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(bottom: 80),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Mycolors().myColorbackgrondprodect,
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            CategoryGridItem(
              image: "images/computer.png",
              title: 'الحواسيب',
              icon: Icons.computer,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                // عرض مؤشر تحميل
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories =
                      await GetProductCategory.getSubCategories('الحواسيب');
                  // _getSubCategories('الحواسيب');

                  // إغلاق مؤشر التحميل
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد منتجات متاحة حالياً');

                    return;
                  }

                  // الانتقال إلى صفحة الأقسام الفرعية
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'الحواسيب',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('حدث خطأ أثناء جلب البيانات: $e')),
                  );
                }
              },
            ),

            // قسم السماعات
            CategoryGridItem(
              image: "images/s.png",
              title: 'السماعات',
              icon: Icons.headphones,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getHeadphonesSubCategories(); // _getHeadphonesSubCategories();
                  // _getHeadphonesSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد سماعات متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'السماعات',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text('حدث خطأ أثناء جلب بيانات السماعات: $e')),
                  );
                }
              },
            ),
            // قسم الكيبوردات
            CategoryGridItem(
              image: "images/k.png",
              title: 'الكيبوردات',
              icon: Icons.keyboard,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getKeyboardsSubCategories(); // _getKeyboardsSubCategories();
                  //  _getKeyboardsSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد كيبوردات متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'الكيبوردات',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content:
                            Text('حدث خطأ أثناء جلب بيانات الكيبوردات: $e')),
                  );
                }
              },
            ),

            CategoryGridItem(
              image: "images/Led-screen.png", // صورة رئيسية للشاشات
              title: 'الشاشات',
              icon: Icons.desktop_windows, // أيقونة مناسبة للشاشات
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getMonitorsSubCategories(); // _getMonitorsSubCategories();
                  // _getMonitorsSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(context, 'لا توجد شاشات متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'الشاشات',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text('حدث خطأ أثناء جلب بيانات الشاشات: $e')),
                  );
                }
              },
            ),

            // قسم الصوتيات
            CategoryGridItem(
              image: "images/speker.png", // صورة رئيسية للصوتيات
              title: 'الصوتيات',
              icon: Icons.mic, // أيقونة مناسبة للميكروفونات
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getAudioSubCategories(); // _getAudioSubCategories();
                  // _getAudioSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد منتجات صوتيات متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'الصوتيات',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text('حدث خطأ أثناء جلب بيانات الصوتيات: $e')),
                  );
                }
              },
            ),

            // قسم التخزين
            CategoryGridItem(
              image: "images/Hard.png",
              title: 'أجهزة التخزين',
              icon: Icons.storage,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getStorageSubCategories(); // _getStorageSubCategories();
                  //  _getStorageSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد أجهزة تخزين متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'أجهزة التخزين',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text('حدث خطأ أثناء جلب بيانات التخزين: $e')),
                  );
                }
              },
            ),

            // قسم الطاقة
            CategoryGridItem(
              image: "images/power.png",
              title: 'الطاقة',
              icon: Icons.power,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getPowerSubCategories(); // _getPowerSubCategories();
                  // _getPowerSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد منتجات طاقة متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'الطاقة',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text('حدث خطأ أثناء جلب بيانات الطاقة: $e')),
                  );
                }
              },
            ),

            // قسم قطع الغيار
            CategoryGridItem(
              image: "images/ComputerParts/computerstarts.png",
              title: 'قطع الغيار',
              icon: Icons.build,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getComputerPartsSubCategories(); // _getPartsSubCategories();
                  // _getPartsSubCategories();
                  Navigator.of(context).pop();

                  if (subCategories.isEmpty) {
                    MySnackbarError.show(
                        context, 'لا توجد قطع غيار متاحة حالياً');

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'قطع الغيار',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content:
                            Text('حدث خطأ أثناء جلب بيانات قطع الغيار: $e')),
                  );
                }
              },
            ),

            CategoryGridItem(
              image: "images/InputDevices/R.png",
              title: 'أجهزة الإدخال',
              icon: Icons.build,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories =
                      await GetProductCategory.getInputDevicesSubCategories();
                  // .getComputerPartsSubCategories(); // _getPartsSubCategories();
                  // _getPartsSubCategories();
                  Navigator.of(context).pop();

                  // if (subCategories.isEmpty) {
                  //   MySnackbarError.show(
                  //       context, 'لا توجد   اجهزة ادخال حالياً');

                  //   return;
                  // }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'أجهزة الإدخال',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text(
                            'حدث خطأ أثناء جلب بيانات  اجهزة الادخال: $e')),
                  );
                }
              },
            ),

            CategoryGridItem(
              image: "images/OutputDevices/Output.png",
              title: 'أجهزة الاخراج',
              icon: Icons.build,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories =
                      await GetProductCategory.getOutputDevicesSubCategories();
                  // .getComputerPartsSubCategories(); // _getPartsSubCategories();
                  // _getPartsSubCategories();
                  Navigator.of(context).pop();

                  // if (subCategories.isEmpty) {
                  //   MySnackbarError.show(
                  //       context, 'لا توجد   اجهزة ادخال حالياً');

                  //   return;
                  // }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: 'أجهزة الاخراج',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text(
                            'حدث خطأ أثناء جلب بيانات  اجهزة الاخراج: $e')),
                  );
                }
              },
            ),

            CategoryGridItem(
              image: "images/Networking/Network.png",
              title: 'ملحقات الشبكة',
              icon: Icons.build,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories =
                      await GetProductCategory.getNetworkingSubCategories();
                  // .getComputerPartsSubCategories(); // _getPartsSubCategories();
                  // _getPartsSubCategories();
                  Navigator.of(context).pop();

                  // if (subCategories.isEmpty) {
                  //   MySnackbarError.show(
                  //       context, 'لا توجد   اجهزة ادخال حالياً');

                  //   return;
                  // }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: ' ملحقات الشبكة',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text(
                            'حدث خطأ أثناء جلب بيانات   ملحقات الشبكة: $e')),
                  );
                }
              },
            ),

            CategoryGridItem(
              image: "images/OtherAccessories/other.png",
              title: 'ملحقات اخرى',
              icon: Icons.build,
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: SpinKitSquareCircle(
                    color: Mycolors().myColor,
                    size: 50.0,
                  )),
                );

                try {
                  final subCategories = await GetProductCategory
                      .getOtherAccessoriesSubCategories();
                  // .getComputerPartsSubCategories(); // _getPartsSubCategories();
                  // _getPartsSubCategories();
                  Navigator.of(context).pop();

                  // if (subCategories.isEmpty) {
                  //   MySnackbarError.show(
                  //       context, 'لا توجد   اجهزة ادخال حالياً');

                  //   return;
                  // }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                        title: ' ملحقات اخرى',
                        subCategories: subCategories,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content:
                            Text('حدث خطأ أثناء جلب بيانات   ملحقات اخرى: $e')),
                  );
                }
              },
            ),
            // يمكن إضافة المزيد من الفئات الرئيسية هنا
          ],
        ),
      ),
    );
  }
}
