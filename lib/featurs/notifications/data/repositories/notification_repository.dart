import '../../../../core/services/dio_service.dart';

class NotificationRepository {
  final DioService dioService = DioService();

  Future<dynamic> getNotifications() async {
    return await dioService.getData("/customer/notifications");
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
