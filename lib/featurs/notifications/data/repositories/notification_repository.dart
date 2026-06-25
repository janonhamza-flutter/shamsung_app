import '../../../../core/services/dio_service.dart';

class NotificationRepository {
  final DioService dioService = DioService();

  Future<dynamic> updateFcmToken(String token) async {
    return await dioService.postData(
      endpoint: "/customer/fcm-token",
      data: {
        "fcm_token": token,
      },
    );
  }
}
