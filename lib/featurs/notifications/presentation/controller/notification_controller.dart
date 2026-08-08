import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/notification_item.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository repository = NotificationRepository();
  final StorageService storage = StorageService();

  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  RxInt unreadCount = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    debugPrint('🔔 NotificationController.onInit called');
    fetchNotifications();
    super.onInit();
  }

  // ── Fetch from API ────────────────────────────────────────────────────────
  Future<void> fetchNotifications({String? lang}) async {
    print('🔔 fetchNotifications started lang=$lang');
    notifications.clear();
    try {
      isLoading.value = true;
      final response = await repository.getNotifications(lang: lang);

      debugPrint('📬 Notifications API status: ${response.statusCode}');
      debugPrint('📬 Notifications API response: ${response.data}');
      print('📬 Notifications API response printed');

      final responseData = response.data;
      final raw = _extractNotificationList(responseData);

      debugPrint('📬 Extracted raw list length=${raw.length}');
      debugPrint('📬 Notification raw payload type: ${raw.runtimeType}');
      for (var i = 0; i < raw.length; i++) {
        debugPrint('📬 raw[$i] type=${raw[i].runtimeType}');
      }

      if (raw.isEmpty) {
        debugPrint('⚠️ No notifications found. Full response: $responseData');
      }

      final normalizedItems = _normalizeNotificationItems(raw);
      debugPrint('📬 Normalized notification count: ${normalizedItems.length}');
      debugPrint('📬 Normalized types: ${normalizedItems.map((e) => e.runtimeType).toList()}');

      final parsedNotifications = normalizedItems
          .map((e) => NotificationItem.fromApi(e))
          .toList();

      for (final item in parsedNotifications) {
        debugPrint(
          '📌 Parsed notification item: id=${item.id} title="${item.title}" body="${item.body}"',
        );
      }

      notifications.assignAll(parsedNotifications);
      debugPrint('✅ Assigned ${notifications.length} notifications to controller list');

      try {
        _saveLocal();
        debugPrint('✅ Saved latest notifications to local cache');
      } catch (e, st) {
        debugPrint('⚠️ Failed to save latest notifications locally: $e\n$st');
      }

      if (unreadCount.value == 0) {
        _updateUnreadCount();
      }
    } catch (e, st) {
      debugPrint('❌ fetchNotifications error: $e\n$st');
      debugPrint('🔁 Falling back to local notifications because fetch failed');
      _loadLocal();
    } finally {
      isLoading.value = false;
    }
  }

  List<dynamic> _extractNotificationList(dynamic responseData) {
    if (responseData is List) {
      if (responseData.isEmpty) return [];
      if (responseData.first is List) {
        return _extractNotificationList(responseData.first);
      }
      return responseData;
    }

    if (responseData is Map) {
      if (responseData['data'] is Map && responseData['data']['notifications'] is List) {
        unreadCount.value = responseData['data']['unread_count'] ?? 0;
        return _extractNotificationList(responseData['data']['notifications']);
      }

      if (responseData['data'] is List) {
        return _extractNotificationList(responseData['data']);
      }

      if (responseData['notifications'] is List) {
        unreadCount.value = responseData['unread_count'] ?? 0;
        return _extractNotificationList(responseData['notifications']);
      }

      for (final value in responseData.values) {
        if (value is List) {
          return _extractNotificationList(value);
        }
      }
    }

    return [];
  }

  List<Map<String, dynamic>> _normalizeNotificationItems(List<dynamic> raw) {
    final normalized = <Map<String, dynamic>>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        normalized.add(item);
        continue;
      }

      if (item is Map) {
        normalized.add(
          Map<String, dynamic>.from(item.map(
            (key, value) => MapEntry(key.toString(), value),
          )),
        );
        continue;
      }

      if (item is List && item.isNotEmpty) {
        final nested = _normalizeNotificationItems(item);
        normalized.addAll(nested);
        continue;
      }

      debugPrint('⚠️ Skipping unsupported notification item type: ${item.runtimeType}');
    }
    return normalized;
  }

  // ── Local fallback ────────────────────────────────────────────────────────
  void _loadLocal() {
    final saved = storage.getNotifications();
    debugPrint('🔁 Loaded ${saved.length} local notifications');
    notifications.assignAll(
      saved.map((item) => NotificationItem.fromMap(item)).toList(),
    );
    _updateUnreadCount();
  }

  // ── Add from Firebase push ────────────────────────────────────────────────
  void addRemoteNotification(RemoteMessage message) {
    final item = NotificationItem.fromRemoteMessage(message);
    notifications.insert(0, item);
    _saveLocal();
    _updateUnreadCount();
  }

  // ── Mark as read ──────────────────────────────────────────────────────────
  Future<void> markAsRead(String id) async {
    // تحديث محلي فوري
    final index = notifications.indexWhere((item) => item.id == id);
    if (index == -1) return;
    if (notifications[index].isRead) return; // مقروء مسبقاً

    notifications[index] = notifications[index].copyWith(isRead: true);
    _saveLocal();
    _updateUnreadCount();

    // إرسال للـ API
    try {
      await repository.markAsRead(id);
    } catch (_) {
      // الـ UI محدّث بالفعل، تجاهل خطأ الشبكة
    }
  }

  void markAllAsRead() {
    notifications.assignAll(
      notifications.map((item) => item.copyWith(isRead: true)).toList(),
    );
    _saveLocal();
    _updateUnreadCount();

    // إرسال للـ API
    repository.markAllAsRead().catchError((_) {});
  }

  // ── FCM token ─────────────────────────────────────────────────────────────
  Future<void> updateFcmToken(String token) async {
    try {
      await repository.updateFcmToken(token);
    } catch (_) {}
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _saveLocal() {
    storage.saveNotifications(notifications.map((n) => n.toMap()).toList());
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((item) => !item.isRead).length;
  }
}
