import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/validators/app_validator.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/route/app_routes.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controller/login_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.find();

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
                    const SizedBox(height: AppSizes.space40),

                    /// ======================
                    /// LOGO
                    /// ======================
                    Image.asset(AppAssets.logo, width: 140),

                    const SizedBox(height: AppSizes.space20),

                    /// TITLE
                    const Text(
                      AppStrings.login,
                      style: AppTextStyles.authTitle,
                    ),

                    const SizedBox(height: AppSizes.space60),

                    /// ======================
                    /// EMAIL FIELD
                    /// ======================
                    CustomTextField(
                      hint: AppStrings.email,

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

                    const SizedBox(height: AppSizes.space25),

                    /// ======================
                    /// PASSWORD FIELD
                    /// ======================
                    Obx(() {
                      return CustomTextField(
                        hint: AppStrings.password,

                        icon: Icons.lock_outline,

                        controller: controller.passwordController,

                        validator: AppValidator.validatePassword,

                        obscureText: controller.obscureText.value,

                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },

                          icon: Icon(
                            controller.obscureText.value
                                ? Icons.visibility_off
                                : Icons.visibility,

                            color: AppColors.grey,
                            size: 30,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: AppSizes.space20),

                    /// FORGET PASSWORD
                    Align(
                      alignment: Alignment.centerLeft,

                      child: TextButton(
                        onPressed: () {},

                        child: const Text(
                          AppStrings.forgetPassword,

                          style: AppTextStyles.body,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.space50),

                    /// ======================
                    /// LOGIN BUTTON
                    /// ======================
                    AuthButton(
                      title: AppStrings.login,

                      onPressed: () {
                        controller.login();
                      },
                    ),

                    const SizedBox(height: AppSizes.space90),

                    /// SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          AppStrings.dontHaveAccount,

                          style: AppTextStyles.body,
                        ),

                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.signup);
                          },

                          child: const Text(
                            AppStrings.signUp,

                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ],
                    ),
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
