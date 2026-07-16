import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';

class LoadingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ── Progress bar animation ────────────────────────────────────
  late AnimationController animationController;

  // Logo float animation
  late Animation<double> logoFloatAnimation;

  // Progress fill animation (0 → 1 over ~3 seconds)
  late Animation<double> progressAnimation;

  // Glow pulse animation
  late Animation<double> glowAnimation;

  // Particles fade-in
  late Animation<double> particlesFade;

  // Text fade+slide
  late Animation<double> textFade;
  late Animation<Offset> textSlide;

  // Tagline opacity (appears later)
  late Animation<double> taglineFade;

  final StorageService storage = StorageService();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Logo gentle floating (repeats separately via curved interval)
    logoFloatAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Progress bar fills from 0 to 1
    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.1, 0.95, curve: Curves.easeInOut),
      ),
    );

    // Glow pulse (opacity 0.4 → 1.0)
    glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Particles fade in early
    particlesFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Title text fades + slides up
    textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.05, 0.35, curve: Curves.easeOut),
      ),
    );

    textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.05, 0.35, curve: Curves.easeOut),
          ),
        );

    // Tagline appears after title
    taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
      ),
    );

    animationController.forward();

    // Navigate after animation completes + small buffer
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), _navigateNext);
      }
    });
  }

  void _navigateNext() {
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
