import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final AuthRepository authRepository = AuthRepository();

  RxBool obscureText = true.obs;
  RxBool isLoading = false.obs; //تعرضي Loading على الزر أثناء تسجيل الدخول.
  final StorageService storage = StorageService();

  /// =========================
  /// TOGGLE PASSWORD
  /// =========================

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  /// =========================
  /// LOGIN
  /// =========================

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await authRepository.login(
        login: emailController.text
            .trim(), //اذا المستخدم حط فراغ بالبداية او النهاية
        password: passwordController.text.trim(),
      );

      final customer = response.data["data"]["customer"];

      final token = response.data["data"]["token"];

      StorageService storage = StorageService();

      storage.saveToken(token);

      storage.saveCustomerId(customer["id"]);

      storage.saveCustomerName(customer["first_name"]);

      storage.saveCustomerEmail(customer["email"]);

      print("Customer: $customer");
      print("Token: $token");

      print(StorageService().getToken());

      print(StorageService().getCustomerName());

      AppSnackbar.success("Login Successful");

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print(e);

      AppSnackbar.error("Invalid credentials provided");
    } finally {
      isLoading.value = false; // ايقاف ال load سواء نجح الطلب او فشل
    }
  }

  @override
  void onClose() {
    //emailController.dispose();
    //passwordController.dispose();

    super.onClose();
  }
}


///  يتولى المُتحكّم إدارة مُدخلات المستخدم وتغيّرات الحالة، ويتواصل مع طبقة خدمة Dio لمعالجة طلبات واجهة برمجة التطبيقات (API)، مع الحفاظ على فصل واجهة المستخدم عن منطق الأعمال.