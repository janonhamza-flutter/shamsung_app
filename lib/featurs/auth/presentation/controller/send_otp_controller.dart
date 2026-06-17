import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/route/app_routes.dart';

class SendOtpController extends GetxController {
  final phoneController = TextEditingController();

  final AuthRepository authRepository = AuthRepository();

  RxBool isLoading = false.obs;

  Future<void> sendOtp() async {
    try {
      isLoading.value = true;

      final response = await authRepository.sendOtp(
        phone: phoneController.text,
      );

      AppSnackbar.success(response.data["message"]);

      Get.toNamed(AppRoutes.otp, arguments: phoneController.text);
    } catch (e) {
      AppSnackbar.error("Failed to send OTP");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // phoneController.dispose();

    // super.onClose();
  }
}
