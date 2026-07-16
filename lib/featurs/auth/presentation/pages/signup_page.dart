import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/validators/app_validator.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controller/signup_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_text_field.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final SignupController controller = Get.find();

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
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.space30),

                    // ── Logo ──────────────────────────────────────────────
                    Image.asset(AppAssets.logo, width: 120),
                    const SizedBox(height: AppSizes.space15),

                    // ── Title ─────────────────────────────────────────────
                    Text('sign_up'.tr, style: AppTextStyles.authTitle),
                    const SizedBox(height: AppSizes.space45),

                    // ── First Name ────────────────────────────────────────
                    CustomTextField(
                      hint: 'first_name'.tr,
                      icon: Icons.person_outline,
                      controller: controller.firstNameController,
                      validator: AppValidator.validateName,
                    ),
                    const SizedBox(height: AppSizes.space20),

                    // ── Last Name ─────────────────────────────────────────
                    CustomTextField(
                      hint: 'last_name'.tr,
                      icon: Icons.person_outline,
                      controller: controller.lastNameController,
                      validator: AppValidator.validateName,
                    ),
                    const SizedBox(height: AppSizes.space20),

                    // ── Phone ─────────────────────────────────────────────
                    CustomTextField(
                      hint: 'mobile'.tr,
                      icon: Icons.phone_outlined,
                      controller: controller.phoneController,
                      validator: AppValidator.validateMobile,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSizes.space20),

                    // ── Email ─────────────────────────────────────────────
                    CustomTextField(
                      hint: 'email'.tr,
                      icon: Icons.email_outlined,
                      controller: controller.emailController,
                      validator: AppValidator.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.grey,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space20),

                    // ── Password ──────────────────────────────────────────
                    // obscureText.value is Rx — Obx is correct here
                    Obx(
                      () => CustomTextField(
                        hint: 'password'.tr,
                        icon: Icons.lock_outline,
                        controller: controller.passwordController,
                        obscureText: controller.obscureText.value,
                        validator: AppValidator.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.obscureText.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space20),

                    // ── Confirm Password ──────────────────────────────────
                    Obx(
                      () => CustomTextField(
                        hint: 'password_confirmation'.tr,
                        icon: Icons.lock_outline,
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureText.value,
                        validator: AppValidator.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.obscureText.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space20),

                    // ── Birth Date ────────────────────────────────────────
                    CustomTextField(
                      hint: 'birth_date_hint'.tr,
                      controller: controller.birthdateController,
                      icon: Icons.date_range,
                    ),
                    const SizedBox(height: AppSizes.space55),

                    // ── Sign Up Button ────────────────────────────────────
                    AuthButton(
                      title: 'sign_up'.tr,
                      onPressed: () => controller.signUp(),
                    ),
                    const SizedBox(height: AppSizes.space70),

                    // ── Already have account ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already_have_account'.tr,
                          style: AppTextStyles.body,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'login'.tr,
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
