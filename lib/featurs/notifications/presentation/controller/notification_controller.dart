import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/services/storage_service.dart';
import '../../data/models/notification_item.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository repository = NotificationRepository();
  final StorageService storage = StorageService();

  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    loadNotifications();
    super.onInit();
  }

  void loadNotifications() {
    final saved = storage.getNotifications();
    notifications.assignAll(
      saved.map((item) => NotificationItem.fromMap(item)).toList(),
    );
    updateUnreadCount();
  }

  void addNotification(NotificationItem item) {
    notifications.insert(0, item);
    storage.saveNotifications(
      notifications.map((notification) => notification.toMap()).toList(),
    );
    updateUnreadCount();
  }

  void addRemoteNotification(RemoteMessage message) {
    addNotification(NotificationItem.fromRemoteMessage(message));
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((item) => item.id == id);
    if (index == -1) return;

    notifications[index] = notifications[index].copyWith(isRead: true);
    storage.saveNotifications(
      notifications.map((notification) => notification.toMap()).toList(),
    );
    updateUnreadCount();
  }

  void markAllAsRead() {
    notifications.assignAll(
      notifications.map((item) => item.copyWith(isRead: true)).toList(),
    );
    storage.saveNotifications(
      notifications.map((notification) => notification.toMap()).toList(),
    );
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((item) => !item.isRead).length;
  }

  Future<void> updateFcmToken(String token) async {
    try {
      await repository.updateFcmToken(token);
    } catch (_) {
      // ignore API failures here so the app keeps working even if the backend is temporarily unavailable
    }
  }
}
