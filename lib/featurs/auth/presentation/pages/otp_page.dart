import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/featurs/auth/presentation/widgets/otp_field.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';
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
      body: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),

            child: Column(
              children: [
                const SizedBox(height: AppSizes.space60),

                Image.asset(AppAssets.logo, width: 140),

                const SizedBox(height: AppSizes.space30),

                const Text("Verification Code", style: AppTextStyles.authTitle),

                const SizedBox(height: AppSizes.space15),

                Text(
                  "Code sent to\n${controller.phone}",
                  textAlign: TextAlign.center,

                  style: AppTextStyles.body,
                ),

                const SizedBox(height: AppSizes.space60),

                OtpField(
                  controller: controller.codeController,

                  /*   keyboardType: TextInputType.number,

                  maxLength: 5,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    letterSpacing: 12,
                  ),

                  decoration: InputDecoration(
                    counterText: "",

                    filled: true,

                    fillColor: Colors.white.withOpacity(0.1),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                  ), */
                ),

                const SizedBox(height: AppSizes.space20),

                TextButton(
                  onPressed: () {},

                  child: const Text(
                    "Resend Code",
                    style: TextStyle(color: AppColors.green),
                  ),
                ),

                const Spacer(),

                Obx(() {
                  return AuthButton(
                    title: controller.isLoading.value ? "Loading..." : "Verify",

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
    );
  }
}
