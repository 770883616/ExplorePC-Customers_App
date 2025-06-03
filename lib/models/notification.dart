class AppNotification {
  final int id;
  final int? userId;
  final String title;
  final String message;
  final bool isRead;
  final bool isGeneral;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.isGeneral,
    required this.createdAt,
    this.data,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'] ?? false,
      isGeneral: json['is_general'] ?? json['user_id'] == null,
      createdAt: DateTime.parse(json['created_at']),
      data: json['data'],
    );
  }
}
