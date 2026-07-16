import 'package:firebase_messaging/firebase_messaging.dart';
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
    fetchNotifications();
    super.onInit();
  }

  // ── Fetch from API ────────────────────────────────────────────────────────
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await repository.getNotifications();
      final data = response.data['data'];
      final List raw = data['notifications'] ?? [];
      notifications.assignAll(
        raw
            .map((e) => NotificationItem.fromApi(e as Map<String, dynamic>))
            .toList(),
      );
      unreadCount.value = data['unread_count'] ?? 0;
    } catch (e) {
      // fallback to local if API fails
      _loadLocal();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Local fallback ────────────────────────────────────────────────────────
  void _loadLocal() {
    final saved = storage.getNotifications();
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
