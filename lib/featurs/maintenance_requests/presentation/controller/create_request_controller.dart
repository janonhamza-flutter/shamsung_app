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

  // List of available shops — extend when the API exposes a /shops endpoint
  final List<Map<String, dynamic>> shops = [
    {"id": 1, "name": "Main Shop — Damascus"},
  ];

  Future<void> createRequest() async {
    final device = deviceController.text.trim();
    final problem = problemController.text.trim();

    if (device.isEmpty || problem.isEmpty) {
      AppSnackbar.error("Please fill in all fields");
      return;
    }

    try {
      isLoading.value = true;

      final response = await repository.createRequest(
        shopId: selectedShopId.value,
        deviceModel: device,
        problemDescription: problem,
      );

      debugPrint("STATUS = ${response.statusCode}");
      debugPrint("BODY = ${response.data}");

      AppSnackbar.success("Maintenance request submitted successfully");
      Get.offNamed(AppRoutes.myRequests);
    } catch (e) {
      debugPrint("ERROR = $e");
      AppSnackbar.error("Failed to create request. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    deviceController.dispose();
    problemController.dispose();
    super.onClose();
  }
}
