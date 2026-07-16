import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../shops/data/models/shop_model.dart';
import '../../data/repositories/maintenance_repository.dart';

class CreateRequestController extends GetxController {
  final MaintenanceRepository repository = MaintenanceRepository();

  final deviceController = TextEditingController();
  final problemController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isLoadingShops = false.obs;
  RxInt selectedShopId = (-1).obs;
  RxString selectedShopName = ''.obs;
  RxList<ShopModel> shops = <ShopModel>[].obs;

  /// true عند القدوم من nearest shop — يُخفي الـ dropdown
  RxBool shopPreselected = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      final id = args['shopId'];
      final name = args['shopName'];
      if (id != null) {
        selectedShopId.value = id as int;
        shopPreselected.value = true;
      }
      if (name != null) {
        selectedShopName.value = name as String;
      }
    }
    if (!shopPreselected.value) {
      _fetchShops();
    }
  }

  Future<void> _fetchShops() async {
    try {
      isLoadingShops.value = true;
      final result = await repository.getAllShops();
      shops.assignAll(result);
      if (result.isNotEmpty && selectedShopId.value == -1) {
        selectedShopId.value = result.first.id;
        selectedShopName.value = result.first.name;
      }
    } catch (e) {
      AppSnackbar.error("Failed to load shops");
    } finally {
      isLoadingShops.value = false;
    }
  }

  Future<void> createRequest() async {
    final device = deviceController.text.trim();
    final problem = problemController.text.trim();

    if (device.isEmpty || problem.isEmpty) {
      AppSnackbar.error("Please fill in all fields");
      return;
    }
    if (selectedShopId.value == -1) {
      AppSnackbar.error("Please select a shop");
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
