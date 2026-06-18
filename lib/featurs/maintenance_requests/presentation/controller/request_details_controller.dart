import 'package:get/get.dart';

import '../../data/models/maintenance_request_model.dart';
import '../../data/repositories/maintenance_requests_repository.dart';

class RequestDetailsController extends GetxController {
  final repository = MaintenanceRequestsRepository();

  RxBool isLoading = false.obs;

  MaintenanceRequestModel? request;

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

      print(response.data);
    } finally {
      isLoading.value = false;
    }
  }
}
