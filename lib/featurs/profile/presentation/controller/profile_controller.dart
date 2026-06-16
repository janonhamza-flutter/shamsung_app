import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/data/models/customer_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository = ProfileRepository();

  final StorageService storage = StorageService();

  RxBool isLoading = false.obs;

  Rx<CustomerModel?> customer = Rx<CustomerModel?>(null);

  @override
  void onInit() {
    getProfile();

    super.onInit();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      final response = await repository.getProfile();

      customer.value = CustomerModel.fromJson(response.data["data"]);

      storage.saveCustomerName(customer.value!.firstName);

      storage.saveCustomerEmail(customer.value!.email);

      storage.saveCustomerId(customer.value!.id);
    } catch (e) {
      AppSnackbar.error("Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await repository.logout();

      storage.clearData();

      AppSnackbar.success("Logged out successfully");
      Get.offAllNamed(AppRoutes.sendOtp);
    } catch (e) {
      AppSnackbar.error("Logout failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await repository.deleteAccount();

      storage.clearData();

      AppSnackbar.success("Account deleted successfully");
      Get.offAllNamed(AppRoutes.sendOtp);
    } catch (e) {
      AppSnackbar.error("Delete account failed");
    } finally {
      isLoading.value = false;
    }
  }
}
