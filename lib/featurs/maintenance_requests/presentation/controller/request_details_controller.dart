import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/repositories/maintenance_requests_repository.dart';

class RequestDetailsController extends GetxController {
  final repository = MaintenanceRequestsRepository();

  RxBool isLoading = false.obs;

  RxMap request = {}.obs;

  @override
  void onInit() {
    getDetails();
    super.onInit();
  }

  Future<void> getDetails() async {
    try {
      isLoading.value = true;

      final int requestId = Get.arguments;

      final response = await repository.getRequestDetails(requestId);

      print("DETAILS STATUS = ${response.statusCode}");
      print("DETAILS BODY = ${response.data}");

      request.value = response.data["data"];
    } catch (e) {
      print("DETAILS ERROR = $e");

      if (e is DioException) {
        print("STATUS = ${e.response?.statusCode}");
        print("BODY = ${e.response?.data}");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
