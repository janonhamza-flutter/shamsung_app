import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/maintenance_request_model.dart';
import '../../data/repositories/maintenance_requests_repository.dart';

class MyRequestsController extends GetxController {
  final MaintenanceRequestsRepository repository =
      MaintenanceRequestsRepository();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<MaintenanceRequestModel> requests = <MaintenanceRequestModel>[].obs;

  @override
  void onInit() {
    getRequests();
    super.onInit();
  }

  void deleteRequest(int id) {
    requests.removeWhere((r) => r.id == id);
    Get.snackbar(
      'Deleted',
      'Request has been removed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> getRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await repository.getAllRequests();
      debugPrint("▶ STATUS = ${response.statusCode}");

      // Response structure:
      // { "data": { "current_page": 1, "data": [ ...requests... ] } }
      final List rawList = response.data["data"]["data"] ?? [];

      requests.value = rawList
          .map(
            (e) => MaintenanceRequestModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      debugPrint("▶ LOADED ${requests.length} requests");
    } on DioException catch (e) {
      debugPrint("▶ DIO ERROR status = ${e.response?.statusCode}");
      debugPrint("▶ DIO ERROR body   = ${e.response?.data}");

      final status = e.response?.statusCode;
      if (status == 401) {
        errorMessage.value = "Session expired. Please log in again.";
      } else if (status != null) {
        errorMessage.value = "Server error ($status). Pull to refresh.";
      } else {
        errorMessage.value = "Network error. Check your connection.";
      }
    } catch (e) {
      debugPrint("▶ ERROR = $e");
      errorMessage.value = "Failed to load requests. Pull to refresh.";
    } finally {
      isLoading.value = false;
    }
  }
}
