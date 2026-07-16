import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/featurs/auth/presentation/widgets/otp_field.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

import '../controller/otp_controller.dart';
import '../widgets/auth_button.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  final OtpController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      body: ListView(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.blue, AppColors.darkBlue],
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding,
                ),

                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.space60),

                    Image.asset(AppAssets.logo, width: 140),

                    const SizedBox(height: AppSizes.space30),

                    Text('verify_code'.tr, style: AppTextStyles.authTitle),

                    const SizedBox(height: AppSizes.space15),

                    Text(
                      '${'code_sent_to'.tr}\n${controller.phone}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: AppSizes.space60),

                    OtpField(controller: controller.codeController),

                    const SizedBox(height: AppSizes.space20),

                    GestureDetector(
                      onTap: () => Get.offNamed(AppRoutes.sendOtp),
                      child: RichText(
                        text: TextSpan(
                          text: '${'didnt_receive_code'.tr} ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'resend_otp'.tr,
                              style: const TextStyle(
                                color: AppColors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.space20),

                    Obx(() {
                      return AuthButton(
                        title: controller.isLoading.value
                            ? 'loading'.tr
                            : 'verify'.tr,
                        onPressed: () {
                          controller.verifyOtp();
                        },
                      );
                    }),

                    const SizedBox(height: AppSizes.space40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
