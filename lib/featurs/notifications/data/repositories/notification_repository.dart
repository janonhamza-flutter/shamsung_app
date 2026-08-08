import 'package:flutter/material.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class NotificationRepository {
  final DioService dioService = DioService();
  final StorageService _storage = StorageService();

  Future<dynamic> getNotifications({String? lang}) async {
    // StorageService هو المصدر الموثوق للغة — لا يعتمد على Get.locale
    final String effectiveLang = _normalizeLang(lang ?? _storage.getLanguage());
    debugPrint('Notifications GET request | lang=$effectiveLang');
    final response = await dioService.getData(
      '/customer/notifications',
      queryParameters: {'lang': effectiveLang},
    );
    debugPrint('Notifications response data: ${response.data}');
    return response;
  }

  String _normalizeLang(String languageCode) {
    final normalized = languageCode.toLowerCase();
    if (normalized.startsWith('ar')) return 'ar';
    return 'en';
  }

  Future<dynamic> markAsRead(String id) async {
    return await dioService.postData(
      endpoint: "/customer/notifications/$id/read",
      data: {},
    );
  }

  Future<dynamic> markAllAsRead() async {
    return await dioService.postData(
      endpoint: "/customer/notifications/mark-all-read",
      data: {},
    );
  }

  Future<dynamic> updateFcmToken(String token) async {
    return await dioService.postData(
      endpoint: "/customer/fcm-token",
      data: {"fcm_token": token},
    );
  }
}
