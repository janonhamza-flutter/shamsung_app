import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/repositories/auth_repository.dart';

class SignupController extends GetxController {
  // ─── Text Controllers ─────────────────────────────────────────────────────

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final birthdateController = TextEditingController();

  final StorageService storageService = StorageService();
  final AuthRepository authRepository = AuthRepository();
  final formKey = GlobalKey<FormState>();

  RxBool obscureText = true.obs;

  late String phone;

  @override
  void onInit() {
    phone = Get.arguments ?? '';
    // Pre-fill with the phone number that was just OTP-verified so the
    // value submitted to /customer/register matches it exactly.
    phoneController.text = phone;
    super.onInit();
  }

  // ─── Password Visibility ──────────────────────────────────────────────────

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  // ─── Sign Up ──────────────────────────────────────────────────────────────

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.error('Passwords do not match');
      return;
    }

    try {
      final response = await authRepository.signUp(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        birthdate: birthdateController.text.trim(),
      );

      final token = response.data['data']['token'];
      storageService.saveToken(token);

      // FIX #3: token is now saved — safe to register FCM token with the API
      await NotificationService.syncTokenAfterLogin();

      AppSnackbar.success(response.data['message']);
      Get.offAllNamed(AppRoutes.home);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Something went wrong';
      AppSnackbar.error(message);
    } catch (e) {
      AppSnackbar.error('Something went wrong');
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthdateController.dispose();
    super.onClose();
  }
}
