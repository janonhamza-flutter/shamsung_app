import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/data/models/customer_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository = ProfileRepository();

  final StorageService storage = StorageService();

  RxBool isLoading = false.obs;

  Rxn<CustomerModel> customer = Rxn<CustomerModel>();

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
    } catch (e) {
      AppSnackbar.error("Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await repository.logout();

      storage.clearData();

      AppSnackbar.success("Logged out successfully");
    } catch (e) {
      AppSnackbar.error("Logout failed");
    }
  }

  Future<void> deleteAccount() async {
    try {
      await repository.deleteAccount();

      storage.clearData();

      AppSnackbar.success("Account deleted successfully");
    } catch (e) {
      AppSnackbar.error("Delete account failed");
    }
  }
}
