import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  static const String _unreadCountKey = 'unread_notifications_count';
  static const String _readNotificationsKey = 'read_notifications_ids';

  int _unreadCount = 0;
  List<String> _readNotificationsIds = [];
  List<String> _readNotifications = [];
  List<dynamic> _notifications = [];
  static const String _readKey = 'read_notifications';
  static const String _unreadKey = 'unread_count';
  int get unreadCount => _unreadCount;
  List<String> get readNotificationsIds => _readNotificationsIds;

  NotificationProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _unreadCount = prefs.getInt(_unreadCountKey) ?? 0;
    _readNotificationsIds = prefs.getStringList(_readNotificationsKey) ?? [];
    notifyListeners();
  }

  Future<void> updateUnreadCount(int count) async {
    _unreadCount = count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unreadCountKey, count);
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    if (!_readNotifications.contains(id)) {
      _readNotifications.add(id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_readKey, _readNotifications);

      if (_unreadCount > 0) {
        _unreadCount--;
        _saveUnreadCount();
      }

      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unreadCountKey);
    await prefs.remove(_readNotificationsKey);
    _unreadCount = 0;
    _readNotificationsIds = [];
    notifyListeners();
  }

  Future<void> loadUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    _unreadCount = prefs.getInt(_unreadKey) ?? 0;
    notifyListeners();
  }

  Future<void> _saveUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unreadKey, _unreadCount);
  }

  void incrementUnread() {
    _unreadCount++;
    _saveUnreadCount();
    notifyListeners();
  }

  void resetUnread() {
    _unreadCount = 0;
    _saveUnreadCount();
    notifyListeners();
  }
}
