import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/create_request_controller.dart';

/// Header banner shown at top of CreateRequestPage.
class RequestFormHeaderBanner extends StatelessWidget {
  const RequestFormHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blue, Color(0xFF0D3D8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.build_circle_outlined,
              color: AppColors.green,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Submit a Repair Request",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Our technicians will review your request and provide an estimate",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Styled text field for the request form.
class RequestFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const RequestFormTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.white60, fontSize: 14),
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(icon, color: AppColors.green, size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 50,
            minHeight: 50,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.green, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: AppColors.blue,
        ),
      ),
    );
  }
}

/// Shop dropdown for the request form.
class RequestFormShopDropdown extends StatelessWidget {
  final CreateRequestController controller;

  const RequestFormShopDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedShopId.value,
            isExpanded: true,
            dropdownColor: AppColors.blue,
            iconEnabledColor: AppColors.green,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
            items: controller.shops
                .map(
                  (shop) => DropdownMenuItem<int>(
                    value: shop["id"] as int,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.store_outlined,
                          color: AppColors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(shop["name"] as String),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedShopId.value = value;
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Submit button for the request form.
class RequestFormSubmitButton extends StatelessWidget {
  final CreateRequestController controller;

  const RequestFormSubmitButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppSizes.buttonHeight,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.createRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            elevation: 4,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "Submit Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
