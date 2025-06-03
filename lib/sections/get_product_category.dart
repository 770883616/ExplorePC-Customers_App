import 'package:explore_pc/models/computer.dart';
import 'package:explore_pc/models/sections.dart';
import 'package:explore_pc/sections/class_subcategoreis.dart';

class GetProductCategory {
  static Future<List<subcategoreis>> getSubCategories(
      String mainCategory) async {
    try {
      // جلب جميع المنتجات من الفئة الرئيسية
      final products = await Sections.fetchProductsByCategory("الحواسيب");

      // تصنيف المنتجات إلى فئات فرعية
      List<Computer> personalComputers = products
          .where((product) => product.category == 'الحواسيب الشخصية')
          .toList();

      List<Computer> desktopComputers = products
          .where((product) => product.category == 'الحواسيب المكتبية')
          .toList();

      List<Computer> gamingComputers = products
          .where((product) => product.category == 'حواسيب جيمنج')
          .toList();

      // إنشاء قائمة الأقسام الفرعية
      List<subcategoreis> subCategories = [];

      // إضافة الأقسام الفرعية فقط إذا كانت تحتوي على منتجات
      if (personalComputers.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'حواسيب شخصية',
            image: "images/computer.png",
            sections: personalComputers,
          ),
        );
      }

      if (desktopComputers.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'حواسيب مكتبية',
            image: "images/desktopcomputer.png",
            sections: desktopComputers,
          ),
        );
      }

      if (gamingComputers.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'حواسيب جيمنج',
            image: "images/gaming.png",
            sections: gamingComputers,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching subcategories: $e');
      return [];
    }
  }

  // دالة لجلب الأقسام الفرعية للكيبوردات
  static Future<List<subcategoreis>> getKeyboardsSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('الكيبوردات');

      List<Computer> standardKeyboards = products
          .where((product) => product.category == 'كيبورد عادي')
          .toList();

      List<Computer> gamingKeyboards = products
          .where((product) => product.category == 'كيبورد جيمنج')
          .toList();

      List<subcategoreis> subCategories = [];

      if (!standardKeyboards.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'كيبورد عادي',
            image: "images/k.png",
            sections: standardKeyboards,
          ),
        );
      }

      if (!gamingKeyboards.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'كيبورد جيمنج',
            image: "images/ky.png",
            sections: gamingKeyboards,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching keyboards subcategories: $e');
      return [];
    }
  }

  // دالة لجلب الأقسام الفرعية للسماعات
  static Future<List<subcategoreis>> getHeadphonesSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('السماعات');

      List<Computer> wiredHeadphones = products
          .where((product) => product.category == 'سماعات سلكية')
          .toList();

      List<Computer> wirelessHeadphones = products
          .where((product) => product.category == 'سماعات لاسلكية')
          .toList();

      List<subcategoreis> subCategories = [];

      if (wiredHeadphones.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'سماعات سلكية',
            image: "images/Wired.png",
            sections: wiredHeadphones,
          ),
        );
      }

      if (wirelessHeadphones.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'سماعات لاسلكية',
            image: "images/Wireless.png",
            sections: wirelessHeadphones,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching headphones subcategories: $e');
      return [];
    }
  }

  // دالة لجلب الأقسام الفرعية للشاشات
  static Future<List<subcategoreis>> getMonitorsSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('الشاشات');

      List<Computer> lcdMonitors =
          products.where((product) => product.category == 'LCD شاشات').toList();

      List<Computer> ledMonitors =
          products.where((product) => product.category == 'LED شاشات').toList();

      List<Computer> oledMonitors = products
          .where((product) => product.category == 'OLED شاشات')
          .toList();

      List<subcategoreis> subCategories = [];

      if (lcdMonitors.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'LCD شاشات',
            image: "images/monitor_lcd.png", // تأكد من وجود الصورة
            sections: lcdMonitors,
          ),
        );
      }

      if (!ledMonitors.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'LED شاشات',
            image: "images/monitor_led.png", // تأكد من وجود الصورة
            sections: ledMonitors,
          ),
        );
      }

      if (!oledMonitors.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'OLED شاشات',
            image: "images/monitor_oled.png", // تأكد من وجود الصورة
            sections: oledMonitors,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching monitors subcategories: $e');
      return [];
    }
  }

  static Future<List<subcategoreis>> getAudioSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('الصوتيات');

      List<Computer> wiredMicrophones = products
          .where((product) => product.category == 'مكرفون سلكي')
          .toList();

      List<Computer> wirelessMicrophones = products
          .where((product) => product.category == 'مكرفون لا سلكي')
          .toList();

      List<subcategoreis> subCategories = [];

      if (!wiredMicrophones.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'مكرفونات سلكية',
            image: "images/mic_wired.png", // تأكد من وجود الصورة
            sections: wiredMicrophones,
          ),
        );
      }

      if (wirelessMicrophones.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'مكرفونات لاسلكية',
            image: "images/mic_wireless.png", // تأكد من وجود الصورة
            sections: wirelessMicrophones,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching audio subcategories: $e');
      return [];
    }
  }

  // دالة لجلب الأقسام الفرعية للتخزين
  static Future<List<subcategoreis>> getStorageSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('التخزين');

      List<Computer> hdd =
          products.where((product) => product.category == 'HDD').toList();

      List<Computer> ssd =
          products.where((product) => product.category == 'SSD').toList();

      List<Computer> nvme =
          products.where((product) => product.category == 'NVMe M.2').toList();

      List<Computer> nas =
          products.where((product) => product.category == 'NAS').toList();

      List<Computer> ssdHdd =
          products.where((product) => product.category == 'SSD HDD').toList();

      List<Computer> sshd =
          products.where((product) => product.category == 'SSHD').toList();

      List<subcategoreis> subCategories = [];

      if (!hdd.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'HDD',
            image: "images/storage_hdd.png",
            sections: hdd,
          ),
        );
      }

      if (!ssd.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'SSD',
            image: "images/storage_ssd.png",
            sections: ssd,
          ),
        );
      }

      if (!nvme.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'NVMe M.2',
            image: "images/storage_nvme.png",
            sections: nvme,
          ),
        );
      }

      if (!nas.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'NAS',
            image: "images/storage_nas.jpg",
            sections: nas,
          ),
        );
      }

      if (!ssdHdd.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'SSD HDD',
            image: "images/storage_ssd_hdd.png",
            sections: ssdHdd,
          ),
        );
      }

      if (!sshd.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'SSHD',
            image: "images/storage_sshd.png",
            sections: sshd,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching storage subcategories: $e');
      return [];
    }
  }

  // دالة لجلب الأقسام الفرعية للطاقة
  static Future<List<subcategoreis>> getPowerSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('الطاقة');

      List<Computer> batteries =
          products.where((product) => product.category == 'البطاريات').toList();

      List<Computer> cables =
          products.where((product) => product.category == 'الكابلات').toList();

      List<Computer> adapters =
          products.where((product) => product.category == 'المحولات').toList();

      List<subcategoreis> subCategories = [];

      if (!batteries.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'البطاريات',
            image: "images/power_battery.png",
            sections: batteries,
          ),
        );
      }

      if (!cables.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الكابلات',
            image: "images/power_cable.png",
            sections: cables,
          ),
        );
      }

      if (!adapters.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'المحولات',
            image: "images/power_adapter.png",
            sections: adapters,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching power subcategories: $e');
      return [];
    }
  }

  // دالة لجلب الأقسام الفرعية لقطع غيار الحاسوب
  static Future<List<subcategoreis>> getComputerPartsSubCategories() async {
    try {
      final products =
          await Sections.fetchProductsByCategory('قطع غيار الحاسوب');

      // تصنيف المنتجات حسب الفئات الموجودة في الصورة
      List<Computer> coolingFans = products
          .where((product) => product.category == 'مراوح التبريد')
          .toList();

      List<Computer> cpus =
          products.where((product) => product.category == 'المعالجات').toList();

      List<Computer> drives = products
          .where((product) => product.category == 'محركات الأقراص')
          .toList();

      List<Computer> flexibleParts =
          products.where((product) => product.category == 'قطع مرنة').toList();

      List<Computer> hardDisks = products
          .where((product) => product.category == 'الأقراص الصلبة')
          .toList();

      List<Computer> motherboards = products
          .where((product) => product.category == 'اللوحات الأم')
          .toList();

      List<Computer> powerSupplies = products
          .where((product) => product.category == 'وحدات التغذية')
          .toList();

      List<Computer> rams =
          products.where((product) => product.category == 'RAM').toList();

      List<subcategoreis> subCategories = [];

      // إضافة الفئات الفرعية فقط إذا كانت تحتوي على منتجات
      if (!coolingFans.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'مراوح التبريد',
            image: "images/ComputerParts/Fan.png",
            sections: coolingFans,
          ),
        );
      }

      if (!cpus.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'المعالجات',
            image: "images/ComputerParts/CPU.png",
            sections: cpus,
          ),
        );
      }

      if (!drives.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'محركات الأقراص',
            image: "images/ComputerParts/D_disk.png",
            sections: drives,
          ),
        );
      }

      if (!flexibleParts.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'قطع مرنة',
            image: "images/ComputerParts/Floppy.png",
            sections: flexibleParts,
          ),
        );
      }

      if (!hardDisks.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الأقراص الصلبة',
            image: "images/ComputerParts/Hard_disk.png",
            sections: hardDisks,
          ),
        );
      }

      if (!motherboards.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'اللوحات الأم',
            image: "images/ComputerParts/Mainboard.png",
            sections: motherboards,
          ),
        );
      }

      if (!powerSupplies.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'وحدات التغذية',
            image: "images/ComputerParts/Power.png",
            sections: powerSupplies,
          ),
        );
      }

      if (!rams.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'ذاكرة RAM',
            image: "images/ComputerParts/Ram.png",
            sections: rams,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching computer parts subcategories: $e');
      return [];
    }
  }

  static Future<List<subcategoreis>> getInputDevicesSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('أجهزة الإدخال');

      // تصنيف المنتجات حسب أنواع أجهزة الإدخال
      List<Computer> keyboards = products
          .where((product) => product.category == 'لوحة المفاتيح')
          .toList();

      List<Computer> mice =
          products.where((product) => product.category == 'الفأرة').toList();

      List<Computer> graphicsTablets = products
          .where((product) => product.category == 'لوحة الرسم الرقمية')
          .toList();

      List<Computer> scanners = products
          .where((product) => product.category == 'الماسح الضوئي')
          .toList();

      List<Computer> webcams = products
          .where((product) => product.category == 'كاميرا الويب')
          .toList();

      List<Computer> microphones = products
          .where((product) => product.category == 'الميكروفون')
          .toList();
      List<subcategoreis> subCategories = [];
      // List<SubCategory> subCategories = [];

      // إضافة الفئات الفرعية فقط إذا كانت تحتوي على منتجات
      if (!keyboards.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'لوحات المفاتيح',
            image: "images/InputDevices/Keyboard.png",
            sections: keyboards,
          ),
        );
      }

      if (!mice.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الفأرة',
            image: "images/InputDevices/Mouse.png",
            sections: mice,
          ),
        );
      }

      if (!graphicsTablets.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'لوحات الرسم الرقمية',
            image: "images/InputDevices/GraphicsTablet.png",
            sections: graphicsTablets,
          ),
        );
      }

      if (!scanners.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الماسحات الضوئية',
            image: "images/InputDevices/Scanner.png",
            sections: scanners,
          ),
        );
      }

      if (!webcams.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'كاميرات الويب',
            image: "images/InputDevices/Webcam.png",
            sections: webcams,
          ),
        );
      }

      if (!microphones.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الميكروفونات',
            image: "images/InputDevices/Microphone.png",
            sections: microphones,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching input devices subcategories: $e');
      return [];
    }
  }

  static Future<List<subcategoreis>> getOutputDevicesSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('أجهزة الإخراج');

      // تصنيف المنتجات حسب أنواع أجهزة الإخراج
      List<Computer> monitors =
          products.where((product) => product.category == 'الشاشة').toList();

      List<Computer> printers =
          products.where((product) => product.category == 'الطابعة').toList();

      List<Computer> projectors = products
          .where((product) => product.category == 'جهاز الإسقاط')
          .toList();

      List<Computer> speakers = products
          .where((product) => product.category == 'السماعات الخارجية')
          .toList();

      List<Computer> headsets = products
          .where((product) => product.category == 'سماعات الرأس')
          .toList();

      List<subcategoreis> subCategories = [];

      // إضافة الفئات الفرعية فقط إذا كانت تحتوي على منتجات (تم تصحيح الشرط من !isNotEmpty إلى isNotEmpty)
      if (!monitors.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الشاشات',
            image: "images/OutputDevices/Monitor.png",
            sections: monitors,
          ),
        );
      }

      if (!printers.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الطابعات',
            image: "images/OutputDevices/Printer.png",
            sections: printers,
          ),
        );
      }

      if (!projectors.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'أجهزة الإسقاط',
            image: "images/OutputDevices/Projector.png",
            sections: projectors,
          ),
        );
      }

      if (!speakers.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'السماعات الخارجية',
            image: "images/OutputDevices/Speaker.png",
            sections: speakers,
          ),
        );
      }

      if (!headsets.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'سماعات الرأس',
            image: "images/OutputDevices/Headset.png",
            sections: headsets,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('Error fetching output devices subcategories: $e');
      return [];
    }
  }

  static Future<List<subcategoreis>> getNetworkingSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('ملحقات الشبكات');

      // تصنيف المنتجات حسب أنواع ملحقات الشبكات
      List<Computer> routers =
          products.where((product) => product.category == 'الراوتر').toList();

      List<Computer> switches =
          products.where((product) => product.category == 'السويتش').toList();

      List<Computer> networkCards = products
          .where((product) => product.category == 'كارت الشبكة')
          .toList();

      List<Computer> wifiAdapters = products
          .where((product) => product.category == 'محول الواي فاي')
          .toList();

      List<Computer> cables = products
          .where((product) => product.category == 'كابلات الشبكة')
          .toList();

      List<subcategoreis> subCategories = [];

      // إضافة الفئات الفرعية فقط إذا كانت تحتوي على منتجات
      if (!routers.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'الراوترات',
            image: "images/Networking/Router.png",
            sections: routers,
          ),
        );
      }

      if (!switches.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'السويتشات',
            image: "images/Networking/Switch.png",
            sections: switches,
          ),
        );
      }

      if (!networkCards.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'كروت الشبكة',
            image: "images/Networking/NetworkCard.png",
            sections: networkCards,
          ),
        );
      }

      if (!wifiAdapters.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'محولات الواي فاي',
            image: "images/Networking/WifiAdapter.png",
            sections: wifiAdapters,
          ),
        );
      }

      if (!cables.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'كابلات الشبكة',
            image: "images/Networking/Cable.png",
            sections: cables,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('حدث خطأ أثناء جلب أقسام ملحقات الشبكات: $e');
      return [];
    }
  }

  static Future<List<subcategoreis>> getOtherAccessoriesSubCategories() async {
    try {
      final products = await Sections.fetchProductsByCategory('ملحقات أخرى');

      // تصنيف المنتجات حسب أنواع الملحقات الأخرى
      List<Computer> coolingPads = products
          .where((product) => product.category == 'حامل التبريد')
          .toList();

      List<Computer> laptopStands = products
          .where((product) => product.category == 'حامل اللابتوب')
          .toList();

      List<Computer> usbHubs =
          products.where((product) => product.category == 'محول USB').toList();

      List<Computer> dockingStations = products
          .where((product) => product.category == 'مساند ماوس')
          .toList();

      List<Computer> screenProtectors = products
          .where((product) => product.category == 'محولات الشاشة')
          .toList();

      List<Computer> laptopBags = products
          .where((product) => product.category == 'حقيبة اللابتوب')
          .toList();

      List<Computer> other = products
          .where((product) => product.category == 'ملحقات أخرى')
          .toList();

      List<subcategoreis> subCategories = [];

      // إضافة الفئات الفرعية فقط إذا كانت تحتوي على منتجات
      if (!coolingPads.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'حوامل التبريد',
            image: "images/OtherAccessories/CoolingPad.png",
            sections: coolingPads,
          ),
        );
      }

      if (!laptopStands.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'حوامل اللابتوب',
            image: "images/OtherAccessories/LaptopStand.png",
            sections: laptopStands,
          ),
        );
      }

      if (!usbHubs.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'محولات USB',
            image: "images/OtherAccessories/USBHub.png",
            sections: usbHubs,
          ),
        );
      }

      if (!dockingStations.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'مساند ماوس',
            image: "images/OtherAccessories/DockingStation.png",
            sections: dockingStations,
          ),
        );
      }

      if (!screenProtectors.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'محولات الشاشة',
            image: "images/OtherAccessories/ScreenProtector.png",
            sections: screenProtectors,
          ),
        );
      }

      if (!laptopBags.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'حقائب اللابتوب',
            image: "images/OtherAccessories/LaptopBag.png",
            sections: laptopBags,
          ),
        );
      }

      if (!laptopBags.isNotEmpty) {
        subCategories.add(
          subcategoreis(
            name: 'ملحقات اخرى',
            image: "images/OtherAccessories/other.png",
            sections: laptopBags,
          ),
        );
      }

      return subCategories;
    } catch (e) {
      print('حدث خطأ أثناء جلب أقسام الملحقات الأخرى: $e');
      return [];
    }
  }
}
