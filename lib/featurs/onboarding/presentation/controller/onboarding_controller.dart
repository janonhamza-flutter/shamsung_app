import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final StorageService storage = StorageService();

  RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void navigateNext() {
    if (!storage.isOnboardingSeen()) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (storage.isLoggedIn()) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.sendOtp);
    }
  }

  void skip() {
    finishOnboarding();
  }

  void finishOnboarding() {
    storage.saveOnboardingSeen();
    print("onboarding = ${storage.isOnboardingSeen()}");
    print("After Save = ${storage.isOnboardingSeen()}");
    Get.offAllNamed(AppRoutes.sendOtp);
  }

  @override
  void onClose() {
    // pageController.dispose();
    //super.onClose();
  }
}
