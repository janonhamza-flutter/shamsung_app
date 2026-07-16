import '../../../../core/services/dio_service.dart';

class MaintenanceRequestsRepository {
  final DioService dioService = DioService();

  Future getAllRequests() async {
    return await dioService.getData("/maintenance-requests");
  }

  Future getRequestDetails(int id) async {
    return await dioService.getData("/maintenance-requests/$id");
  }

  /// GET /maintenance-requests/{id}/parts
  Future getRequestParts(int id) async {
    return await dioService.getData("/maintenance-requests/$id/parts");
  }

  /// POST /maintenance-requests/{id}/approve
  Future approveRequest({
    required int id,
    required List<int> selectedParts,
    required String paymentMethod,
    required double latitude,
    required double longitude,
  }) async {
    return await dioService.postData(
      endpoint: "/maintenance-requests/$id/approve",
      data: {
        "selected_parts": selectedParts,
        "payment_method": paymentMethod,
        "latitude": latitude,
        "longitude": longitude,
      },
    );
  }

  /// POST /maintenance-requests/{id}/reject
  Future rejectRequest({
    required int id,
    required String rejectionReason,
  }) async {
    return await dioService.postData(
      endpoint: "/maintenance-requests/$id/reject",
      data: {"rejection_reason": rejectionReason},
    );
  }

  /// POST /maintenance-requests/{id}/cancel  (no body required)
  Future cancelRequest({required int id}) async {
    return await dioService.postData(
      endpoint: "/maintenance-requests/$id/cancel",
      data: {},
    );
  }
}
