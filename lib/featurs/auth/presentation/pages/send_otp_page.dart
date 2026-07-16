import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';

import '../controller/send_otp_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_text_field.dart';

class SendOtpPage extends StatelessWidget {
  SendOtpPage({super.key});

  final SendOtpController controller = Get.find();

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

            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.space90),

                  Image.asset(AppAssets.logo, width: 140),

                  const SizedBox(height: AppSizes.space90),

                  Text('verify_phone'.tr, style: AppTextStyles.authTitle),

                  const SizedBox(height: AppSizes.space50),

                  Text(
                    'enter_phone'.tr,
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSizes.space90),

                  Obx(
                    () => CustomTextField(
                      keyboardType: TextInputType.phone,
                      hint: 'phone_hint'.tr,
                      icon: Icons.phone_outlined,
                      controller: controller.phoneController,
                    ),
                  ),

                  const SizedBox(height: AppSizes.space70),

                  Obx(() {
                    return AuthButton(
                      title: controller.isLoading.value
                          ? 'loading'.tr
                          : 'send_otp'.tr,
                      onPressed: () {
                        controller.sendOtp();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
