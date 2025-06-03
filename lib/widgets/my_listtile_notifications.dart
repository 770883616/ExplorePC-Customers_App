import 'package:explore_pc/models/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyListtileNotifications extends StatelessWidget {
  final String title;
  final String? message;
  final bool? isRead;
  final String? date;
  final bool? isGeneral;
  final VoidCallback? onTap;

  const MyListtileNotifications({
    Key? key,
    required this.title,
    this.message,
    this.isRead = false,
    this.date,
    this.isGeneral = false,
    this.onTap,
  }) : super(key: key);

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.grey.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isRead == true ? Colors.grey[50] : Colors.blue[50],
            border: Border(
              left: BorderSide(
                color:
                    isGeneral == true ? Mycolors().myColor : Colors.greenAccent,
                width: 4,
              ),
            ),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // textDirection: TextDirection.rtl, // هنا نضبط اتجاه الصف
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isGeneral == true
                          ? Mycolors().myColor.withOpacity(0.2)
                          : Colors.greenAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isGeneral == true
                          ? Icons.notifications_active
                          : Icons.person_pin,
                      color: isGeneral == true
                          ? Mycolors().myColor
                          : Colors.greenAccent,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isRead == true ? FontWeight.w500 : FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.right, // محاذاة النص لليمين
                    ),
                  ),
                  if (isRead == false)
                    Container(
                      width: 12,
                      height: 12,
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              if (message != null && message!.isNotEmpty) ...[
                SizedBox(height: 10),
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center, // محاذاة النص لليمين
                  // textDirection: TextDirection.rtl, // اتجاه النص
                ),
              ],
              SizedBox(height: 12),
              Row(
                // textDirection: TextDirection.rtl, // اتجاه الصف
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    // textDirection: TextDirection.rtl, // اتجاه النص
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
