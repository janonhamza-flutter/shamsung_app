import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_strings.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controller/splash_controller.dart';
import '../widgets/get_started_button.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,

      body: Center(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: controller.fadeAnimation,
        
                child: ScaleTransition(
                  scale: controller.scaleAnimation,
        
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                    children: [
                      const SizedBox(height: 40),
        
                      // Logo + Title
                      Column(
                        children: [
                          Image.asset(AppAssets.logo, width: 140),
        
                          const SizedBox(height: 25),
        
                          const Text(
                            AppStrings.appName,
                            style: AppTextStyles.splashTitle,
                          ),
                        ],
                      ),
        
                      // Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.space50),
        
                        child: GetStartedButton(
                          onPressed: () {
                            controller.navigateNext();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
