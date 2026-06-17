import '../../../../core/services/dio_service.dart';

class ProfileRepository {
  final DioService dioService = DioService();

  Future getProfile() async {
    return await dioService.getData("/customer/profile");
  }

  Future logout() async {
    return await dioService.postData(endpoint: "/customer/logout", data: {});
  }

  Future deleteAccount() async {
    return await dioService.postData(
      endpoint: "/customer/delete-account",
      data: {},
    );
  }
}
