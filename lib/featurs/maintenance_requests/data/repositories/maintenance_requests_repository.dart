import '../../../../core/services/dio_service.dart';

class MaintenanceRequestsRepository {
  final DioService dioService = DioService();

  Future getAllRequests() async {
    return await dioService.getData("/maintenance-requests");
  }

  Future getRequestDetails(int id) async {
    return await dioService.getData("/maintenance-requests/$id");
  }
}
