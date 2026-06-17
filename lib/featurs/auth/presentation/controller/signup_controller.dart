import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/repositories/auth_repository.dart';

class SignupController extends GetxController {
  /// =========================
  /// TEXT CONTROLLERS
  /// =========================

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final birthdateController = TextEditingController();

  final StorageService storageService = StorageService();

  final formKey = GlobalKey<FormState>();

  late String phone;

  @override
  void onInit() {
    phone = Get.arguments ?? "";

    super.onInit();
  }

  /// =========================
  /// DIO SERVICE
  /// =========================

  final AuthRepository authRepository = AuthRepository();

  /// =========================
  /// PASSWORD VISIBILITY
  /// =========================

  RxBool obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  /// =========================
  /// SIGN UP
  /// =========================

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.error("Passwords do not match");
      return;
    }

    try {
      final response = await authRepository.signUp(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        birthdate: birthdateController.text,
      );

      final token = response.data["data"]["token"];

      storageService.saveToken(token);

      print("TOKEN SAVED = ${storageService.getToken()}");

      AppSnackbar.success(response.data['message']);

      Get.offAllNamed(AppRoutes.home);
    } on DioException catch (e) {
      print(e.response?.data);

      String errorMessage = "Something went wrong";

      if (e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      AppSnackbar.error(errorMessage);
    } catch (e) {
      print(e);
      AppSnackbar.error("Something went wrong");
    }
  }
}










  /*Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.error("Passwords do not match");
      return;
    }

    try {
      final response = await authRepository.signUp(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        birthdate: birthdateController.text,
      );

      print(response.data);

      AppSnackbar.success(response.data['message']);

      Get.offAllNamed(AppRoutes.login);
    } on DioException catch (e) {
      print(e.response?.data);

      String errorMessage = "Something went wrong";

      if (e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      AppSnackbar.error(errorMessage);
    } catch (e) {
      print(e);
      AppSnackbar.error("Something went wrong");
    }
  }

  /*Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // =========================
    // CHECK PASSWORD MATCH
    // =========================

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.error("Passwords do not match");

      return;
    }
    try {
     final response = await authRepository.signUp(
        firstName: firstNameController.text,

        lastName: lastNameController.text,

        phone: phoneController.text,

        email: emailController.text,

        password: passwordController.text,

        passwordConfirmation: confirmPasswordController.text,

        birthdate: birthdateController.text,
      );

      print(response.data);

      AppSnackbar.success(/*"Account Created Successfully"*/ response.message);
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print(e);
      if (e is DioException) {
        print(e.response?.data);
      }

      AppSnackbar.error(response['message']);
    }
  }
*/
  /// =========================
  /// DISPOSE
  /// =========================

  @override
  void onClose() {
    //   firstNameController.dispose();

    //   lastNameController.dispose();

    //   phoneController.dispose();

    //   //emailController.dispose();

    //   //passwordController.dispose();

    //   confirmPasswordController.dispose();

    //   birthdateController.dispose();

    super.onClose();*/
  
