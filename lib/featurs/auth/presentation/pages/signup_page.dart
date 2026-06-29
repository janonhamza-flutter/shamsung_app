import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/validators/app_validator.dart';

import '../../../../../core/constants/app_strings.dart';
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

                    /// ======================
                    /// LOGO
                    /// ======================
                    Image.asset(AppAssets.logo, width: 120),

                    const SizedBox(height: AppSizes.space15),

                    /// TITLE
                    Text(AppStrings.signUp, style: AppTextStyles.authTitle),

                    const SizedBox(height: AppSizes.space45),

                    /// ======================
                    /// FULL NAME
                    /// ======================
                    CustomTextField(
                      hint: AppStrings.first_name,

                      icon: Icons.person_outline,

                      controller: controller.firstNameController,
                      validator: AppValidator.validateName,
                    ),

                    const SizedBox(height: AppSizes.space20),

                    /// ======================
                    ///
                    /// ======================
                    CustomTextField(
                      hint: AppStrings.last_name,

                      icon: Icons.person_outline,

                      controller: controller.lastNameController,
                      validator: AppValidator.validateName,
                    ),

                    const SizedBox(height: AppSizes.space20),

                    /// ======================
                    /// Phone
                    /// ======================
                    CustomTextField(
                      hint: AppStrings.mobile,

                      icon: Icons.phone_outlined,

                      controller: controller.phoneController,
                      validator: AppValidator.validateMobile,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: AppSizes.space20),

                    /// ======================
                    /// EMAIL
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

                    const SizedBox(height: AppSizes.space20),

                    /// ======================
                    /// PASSWORD
                    /// ======================
                    Obx(() {
                      return CustomTextField(
                        hint: AppStrings.password,

                        icon: Icons.lock_outline,

                        controller: controller.passwordController,

                        obscureText: controller.obscureText.value,
                        validator: AppValidator.validatePassword,

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

                    Obx(() {
                      return CustomTextField(
                        hint: AppStrings.password_confirmation,

                        icon: Icons.lock_outline,

                        controller: controller.confirmPasswordController,

                        obscureText: controller.obscureText.value,
                        validator: AppValidator.validatePassword,

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

                    /// =====================
                    /// birthdate
                    /// =====================
                    CustomTextField(
                      hint: "Birth Date Ex: 2002-01-03",
                      controller: controller.birthdateController,
                      icon: Icons.date_range,
                    ),

                    const SizedBox(height: AppSizes.space55),

                    /// ======================
                    /// SIGN UP BUTTON
                    /// ======================
                    AuthButton(
                      title: AppStrings.signUp,

                      onPressed: () {
                        controller.signUp();
                      },
                    ),

                    const SizedBox(height: AppSizes.space70),

                    /// ======================
                    /// LOGIN
                    /// ======================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,

                          style: AppTextStyles.body,
                        ),

                        GestureDetector(
                          onTap: () {
                            //   Get.offNamed(AppRoutes.login);
                          },

                          child: const Text(
                            AppStrings.login,

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
