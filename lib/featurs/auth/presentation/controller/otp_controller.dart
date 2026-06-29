import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/otp_response_model.dart';
import '../../data/repositories/auth_repository.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/storage_service.dart';

class OtpController extends GetxController {
  final codeController = TextEditingController();

  final AuthRepository authRepository = AuthRepository();
  final StorageService storageService = StorageService();
  RxBool isLoading = false.obs;
  RxInt seconds = 60.obs;
  late String phone;

  @override
  void onInit() {
    phone = Get.arguments;

    super.onInit();
  }

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;

      final OtpResponseModel otpResponse = await authRepository.verifyOtp(
        phone: phone,
        code: codeController.text,
      );

      /// NEW USER
      if (otpResponse.isNewUser) {
        Get.offNamed(AppRoutes.signup, arguments: phone);
      }
      /// EXISTING USER
      else {
        storageService.saveToken(otpResponse.token);

        if (otpResponse.customer != null) {
          storageService.saveCustomerId(otpResponse.customer!.id);

          storageService.saveCustomerName(
            "${otpResponse.customer!.firstName} ${otpResponse.customer!.lastName}",
          );

          storageService.saveCustomerEmail(otpResponse.customer!.email);
        }

        await NotificationService.syncTokenAfterLogin();

        Get.offAllNamed(AppRoutes.home);
      }

      AppSnackbar.success("OTP verified successfully");
    } catch (e) {
      AppSnackbar.error("Invalid or expired OTP");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      final response = await authRepository.sendOtp(phone: phone);

      AppSnackbar.success(response.data["message"]);
    } catch (e) {
      AppSnackbar.error(
        "Too many attempts. Please wait before requesting a new OTP.",
      );
    }
  }

  @override
  void onClose() {
    // codeController.dispose();

    // super.onClose();
  }
}
