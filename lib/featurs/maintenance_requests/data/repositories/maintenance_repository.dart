import '../../../../core/services/dio_service.dart';

class MaintenanceRepository {
  final DioService dioService = DioService();

  Future createRequest({
    required int shopId,
    required String deviceModel,
    required String problemDescription,
  }) async {
    return await dioService.postData(
      endpoint: "/maintenance-requests",
      data: {
        "shop_id": shopId,
        "device_model": deviceModel,
        "problem_description": problemDescription,
      },
    );
  }
}

/*import '../../../../core/services/dio_service.dart';

class MaintenanceRequestsRepository {
  final DioService dioService = DioService();

  Future getAllRequests() async {
    return await dioService.getData("/maintenance-requests");
  }
}*/
