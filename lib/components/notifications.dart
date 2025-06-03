import 'dart:async';
import 'dart:convert';

import 'package:explore_pc/auth/user_provider.dart';
import 'package:explore_pc/components/myscaffold.dart';
import 'package:explore_pc/constant/linkapi.dart';
import 'package:explore_pc/models/mycolors.dart';
import 'package:explore_pc/notification/notification_provider.dart';

import 'package:explore_pc/widgets/my_listtile_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // int get unreadCount {
  //   return notifications
  //       .where((notification) => !(notification['is_read'] ?? false))
  //       .length;
  // }

  List<dynamic> notifications = [];
  bool isLoading = true;
  bool hasError = false;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer? _pollingTimer;
  int? _userId;
  final String _readNotificationsKey = 'read_notifications';

  @override
  void initState() {
    super.initState();
    _loadUserId();
    // _initializeNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
        ..loadData()
        ..loadUnreadCount();
    });
  }

  Future<void> _loadUserId() async {
    final userData = await UserProvider.getUserData();
    setState(() {
      _userId = userData['UserId'];
    });
    if (_userId != null) {
      await _fetchNotifications();
      _startNotificationPolling();
    }
  }

  // Future<void> _initializeNotifications() async {
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse details) {
  //       if (details.payload != null) {
  //         final notification = json.decode(details.payload!);
  //         _showNotificationDetails(notification);
  //       }
  //     },
  //   );
  // }

  void _startNotificationPolling() {
    _pollingTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await _checkForNewNotifications();
    });
  }

  Future<void> _checkForNewNotifications() async {
    if (_userId == null) return;

    try {
      final response = await http.post(
        Uri.parse('$LinkServerName/api/notifications'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': _userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newNotifications = data['data'] as List;

        if (newNotifications.isNotEmpty &&
            (notifications.isEmpty ||
                newNotifications[0]['id'] != notifications[0]['id'])) {
          // _showNewNotification(newNotifications[0]);
          await _updateNotificationsList(newNotifications);
        }
      }
    } catch (e) {
      debugPrint('Error checking for new notifications: $e');
    }
  }

  Future<void> _updateNotificationsList(List<dynamic> newNotifications) async {
    final prefs = await SharedPreferences.getInstance();
    final readNotifications = prefs.getStringList(_readNotificationsKey) ?? [];

    // تحديث حالة القراءة للإشعارات الجديدة بناءً على البيانات المحفوظة
    final updatedNotifications = newNotifications.map((notification) {
      return {
        ...notification,
        'is_read': readNotifications.contains(notification['id'].toString()),
      };
    }).toList();

    setState(() {
      notifications = updatedNotifications;
    });
  }

  Future<void> _fetchNotifications() async {
    if (_userId == null) return;

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.post(
        Uri.parse('$LinkServerName/api/notifications'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': _userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        await _updateNotificationsList(data['data']);
        final unread = notifications.where((n) => !n['is_read']).length;
        Provider.of<NotificationProvider>(context, listen: false)
            .updateUnreadCount(unread);
      } else {
        setState(() {
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> _showNewNotification(dynamic notification) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'channel_id',
  //     'الإشعارات الجديدة',
  //     channelDescription: 'قناة إشعارات التطبيق',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //     playSound: true,
  //     colorized: true,
  //     color: Colors.blue,
  //   );

  //   const NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //   );

  //   await flutterLocalNotificationsPlugin.show(
  //     notification['id'],
  //     notification['title'],
  //     notification['message'],
  //     notificationDetails,
  //     payload: json.encode(notification),
  //   );
  // }

  void _showNotificationDetails(dynamic notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Mycolors().myColorbackgrond,
          title: Text(
            notification['title'],
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(
              notification['message'],
              textAlign: TextAlign.right,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
                _markAsRead(notification['id']);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _markAsRead(int notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final readNotifications = prefs.getStringList(_readNotificationsKey) ?? [];

    if (!readNotifications.contains(notificationId.toString())) {
      readNotifications.add(notificationId.toString());
      await prefs.setStringList(_readNotificationsKey, readNotifications);
    }
    final newUnread = notifications.where((n) => !n['is_read']).length;
    Provider.of<NotificationProvider>(context, listen: false)
        .updateUnreadCount(newUnread);
    setState(() {
      notifications = notifications.map((notification) {
        if (notification['id'] == notificationId) {
          return {...notification, 'is_read': true};
        }
        return notification;
      }).toList();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      mywidget: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        color: Mycolors().myColorbackgrondprodect,
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 10),
            _buildNotificationContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.cancel_presentation_sharp,
            color: Mycolors().myColor,
          ),
        ),
        const Text(
          "الإشعــارات",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildNotificationContent() {
    if (_userId == null) {
      return const Center(child: Text('يجب تسجيل الدخول لعرض الإشعارات'));
    } else if (isLoading) {
      return Center(
        child: SpinKitSquareCircle(size: 50.0, color: Mycolors().myColor),
      );
    } else if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 50),
            const Text('حدث خطأ في جلب الإشعارات'),
            ElevatedButton(
              onPressed: _fetchNotifications,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    } else if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_off, size: 50, color: Colors.grey),
            const Text('لا توجد إشعارات لعرضها'),
          ],
        ),
      );
    } else {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: _fetchNotifications,
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return MyListtileNotifications(
                title: notification['title'],
                message: notification['message'],
                isRead: notification['is_read'] ?? false,
                date: notification['created_at'],
                isGeneral: notification['is_general'],
                onTap: () {
                  _markAsRead(notification['id']);
                  _showNotificationDetails(notification);
                },
              );
            },
          ),
        ),
      );
    }
  }
}
