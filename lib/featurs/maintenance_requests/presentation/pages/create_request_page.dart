import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_palette.dart';
import '../controller/create_request_controller.dart';
import '../widgets/request_form_widgets.dart';

class CreateRequestPage extends StatelessWidget {
  CreateRequestPage({super.key});

  final CreateRequestController controller = Get.put(CreateRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.colors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'new_maintenance_request'.tr,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RequestFormHeaderBanner(),
              const SizedBox(height: AppSizes.space30),
              _sectionLabel(context, 'device_information'.tr),
              const SizedBox(height: AppSizes.space15),
              RequestFormTextField(
                controller: controller.deviceController,
                label: 'device_model'.tr,
                hint: 'device_model_hint'.tr,
                icon: Icons.phone_android_outlined,
              ),
              const SizedBox(height: AppSizes.space20),
              _sectionLabel(context, 'problem_description'.tr),
              const SizedBox(height: AppSizes.space15),
              RequestFormTextField(
                controller: controller.problemController,
                label: 'describe_issue'.tr,
                hint: 'describe_issue_hint'.tr,
                icon: Icons.report_problem_outlined,
                maxLines: 5,
              ),
              const SizedBox(height: AppSizes.space20),
              _sectionLabel(context, 'select_shop'.tr),
              const SizedBox(height: AppSizes.space15),
              RequestFormShopDropdown(controller: controller),
              const SizedBox(height: AppSizes.space40),
              RequestFormSubmitButton(controller: controller),
              const SizedBox(height: AppSizes.space20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        color: context.colors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}
