import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';

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
    final lang = _resolveLanguage();
    final title = _localizedRemoteValue(
      message,
      key: 'title',
      fallback: message.notification?.title ?? 'notifications'.tr,
      lang: lang,
    );
    final body = _localizedRemoteValue(
      message,
      key: 'body',
      fallback: message.notification?.body ?? '',
      lang: lang,
    );

    return NotificationItem(
      id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      data: message.data,
    );
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    final lang = _resolveLanguage();
    return NotificationItem(
      id: map['id']?.toString() ?? '',
      title: _localizedMapValue(
        map,
        key: 'title',
        fallback: map['title']?.toString() ?? 'notifications'.tr,
        lang: lang,
      ),
      body: _localizedMapValue(
        map,
        key: 'body',
        fallback: map['body']?.toString() ?? '',
        lang: lang,
      ),
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      isRead: map['isRead'] == true,
      data: _normalizeData(map['data']),
    );
  }

  factory NotificationItem.fromApi(Map<String, dynamic> json) {
    final lang = _resolveLanguage();
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: _localizedJsonValue(
        json,
        key: 'title',
        fallback: json['title']?.toString() ?? '',
        lang: lang,
      ),
      body: _localizedJsonValue(
        json,
        key: 'body',
        fallback: json['body']?.toString() ?? '',
        lang: lang,
      ),
      type: json['type']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['is_read'] == true,
      data: _normalizeData(json['data']),
    );
  }

  static Map<String, dynamic> _normalizeData(dynamic rawData) {
    if (rawData is Map) {
      return Map<String, dynamic>.from(
        rawData.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    if (rawData is List) {
      return {'raw_data': rawData};
    }
    return {};
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

  static String _resolveLanguage() {
    final language = StorageService().getLanguage().toLowerCase();
    if (language.startsWith('ar')) return 'ar';
    return 'en';
  }

  static String _localizedJsonValue(
    Map<String, dynamic> json,
    {
      required String key,
      required String fallback,
      required String lang,
    }
  ) {
    return json['${key}_$lang']?.toString() ??
        json[key]?.toString() ??
        fallback;
  }

  static String _localizedMapValue(
    Map<String, dynamic> map,
    {
      required String key,
      required String fallback,
      required String lang,
    }
  ) {
    return map['${key}_$lang']?.toString() ??
        map[key]?.toString() ??
        fallback;
  }

  static String _localizedRemoteValue(
    RemoteMessage message,
    {
      required String key,
      required String fallback,
      required String lang,
    }
  ) {
    final dataValue = message.data['${key}_$lang'];
    if (dataValue is String && dataValue.isNotEmpty) {
      return dataValue;
    }

    return message.data[key]?.toString() ?? fallback;
  }
}
