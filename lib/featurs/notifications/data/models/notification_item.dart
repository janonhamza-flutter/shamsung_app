import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String? type;
  final DateTime createdAt;
  bool isRead;
  final Map<String, dynamic> data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    required this.createdAt,
    this.isRead = false,
    this.data = const {},
  });

  factory NotificationItem.fromRemoteMessage(RemoteMessage message) {
    return NotificationItem(
      id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'notifications'.tr,
      body: message.notification?.body ?? '',
      createdAt: DateTime.now(),
      data: message.data,
    );
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'notifications'.tr,
      body: map['body']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      isRead: map['isRead'] == true,
      data: Map<String, dynamic>.from(map['data'] ?? const {}),
    );
  }

  factory NotificationItem.fromApi(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['is_read'] == true,
      data: Map<String, dynamic>.from(json['data'] ?? const {}),
    );
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }
}
