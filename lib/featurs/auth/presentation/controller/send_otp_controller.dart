import 'package:dio/dio.dart';
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

      print("OTP STATUS = ${response.statusCode}");
      print("OTP BODY = ${response.data}");
      AppSnackbar.success(response.data["message"]);

      Get.toNamed(AppRoutes.otp, arguments: phoneController.text);
    } catch (e) {
      print("OTP ERROR = $e");
      AppSnackbar.error("Failed to send OTP");

      if (e is DioException) {
        print("OTP STATUS = ${e.response?.statusCode}");
        print("OTP BODY = ${e.response?.data}");
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // phoneController.dispose();
   /* "message": "OTP sent successfully"



} نجح بالبوست مان بس بالتطبيق هيك طلع 



OTP ERROR = DioException [connection error]: The connection errored: The XMLHttpRequest onError callback was called. This typically indicates an error on the network layer. This indicates an error which most likely cannot be solved by the library.



OTP STATUS = null



OTP BODY = null*/
    // super.onClose();
  }
}
