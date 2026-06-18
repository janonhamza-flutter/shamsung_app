import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/repositories/maintenance_repository.dart';

class CreateRequestController extends GetxController {
  final MaintenanceRepository repository = MaintenanceRepository();

  final deviceController = TextEditingController();
  final problemController = TextEditingController();

  RxBool isLoading = false.obs;

  RxInt selectedShopId = 1.obs;

  Future<void> createRequest() async {
    try {
      isLoading.value = true;

      final response = await repository.createRequest(
        shopId: selectedShopId.value,
        deviceModel: deviceController.text.trim(),
        problemDescription: problemController.text.trim(),
      );

      print("STATUS = ${response.statusCode}");
      print("BODY = ${response.data}");
      AppSnackbar.success("Maintenance request submitted successfully");

      Get.offNamed(AppRoutes.myRequests);
    } catch (e) {
      print("ERROR = $e");
      AppSnackbar.error("Failed to create request");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    //  deviceController.dispose();
    //problemController.dispose();
    super.onClose();
  }
}


/*import 'package:get/get.dart';

import '../../data/models/maintenance_request_model.dart';
import '../../data/repositories/maintenance_repository.dart';


class CreateRequestController extends GetxController {
  final MaintenanceRequestsRepository repository =
      MaintenanceRequestsRepository();

  RxBool isLoading = false.obs;

  RxList<MaintenanceRequestModel> requests =
      <MaintenanceRequestModel>[].obs;

  @override
  void onInit() {
    getRequests();
    super.onInit();
  }

  Future<void> getRequests() async {
    try {
      isLoading.value = true;

      final response = await repository.getAllRequests();

      requests.value =
          (response.data["data"] as List)
              .map((e) => MaintenanceRequestModel.fromJson(e))
              .toList();
    } finally {
      isLoading.value = false;
    }
  }
}*/