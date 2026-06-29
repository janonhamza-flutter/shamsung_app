import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  final StorageService storage = StorageService();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();
  }

  void navigateNext() {
    print("onboardingSeen = ${storage.isOnboardingSeen()}");

    print("loggedIn = ${storage.isLoggedIn()}");
    if (!storage.isOnboardingSeen()) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (storage.isLoggedIn()) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.sendOtp);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
