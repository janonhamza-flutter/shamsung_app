import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../controller/create_request_controller.dart';

/// Header banner shown at top of CreateRequestPage.
///
/// Kept as a fixed brand-navy gradient in both themes (like the profile
/// page's hero header) rather than turned into a plain surface card —
/// otherwise its gradient collapses to a flat white-on-white block in Light
/// Mode, losing the intended "welcome" hero treatment.
class RequestFormHeaderBanner extends StatelessWidget {
  const RequestFormHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary, context.colors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
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
              color: context.colors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.build_circle_outlined,
              color: context.colors.accent,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'submit_repair_request'.tr,
                  style: TextStyle(
                    color: context.colors.textOnPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'submit_repair_request_sub'.tr,
                  style: TextStyle(
                    color: context.colors.textOnPrimary.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
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
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: context.colors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: context.colors.textSecondary, fontSize: 14),
          hintStyle: TextStyle(color: context.colors.textDisabled, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(icon, color: context.colors.accent, size: 22),
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
            borderSide: BorderSide(color: context.colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: context.colors.accent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: context.colors.surfaceVariant,
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
    return Obx(() {
      if (controller.shopPreselected.value) {
        return _SelectedShopBadge(name: controller.selectedShopName.value);
      }

      if (controller.isLoadingShops.value) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: context.colors.accent,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'loading_shops'.tr,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        );
      }

      if (controller.shops.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
          ),
          child: Text(
            'no_shops_available'.tr,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedShopId.value == -1
                ? null
                : controller.selectedShopId.value,
            isExpanded: true,
            dropdownColor: context.colors.surfaceVariant,
            iconEnabledColor: context.colors.accent,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 15),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
            hint: Text(
              'select_a_shop'.tr,
              style: TextStyle(color: context.colors.textSecondary),
            ),
            items: controller.shops
                .map(
                  (shop) => DropdownMenuItem<int>(
                    value: shop.id,
                    child: Row(
                      children: [
                        Icon(
                          Icons.store_outlined,
                          color: context.colors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            shop.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedShopId.value = value;
                final shop = controller.shops.firstWhereOrNull(
                  (s) => s.id == value,
                );
                if (shop != null) {
                  controller.selectedShopName.value = shop.name;
                }
              }
            },
          ),
        ),
      );
    });
  }
}

/// Badge shown when shop is preselected from nearest shop page.
class _SelectedShopBadge extends StatelessWidget {
  final String name;
  const _SelectedShopBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.accent.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.colors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: context.colors.accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selected_branch'.tr,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.colors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'nearest'.tr,
              style: TextStyle(
                color: context.colors.accent,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Map location picker for the request form.
class RequestFormLocationPicker extends StatelessWidget {
  final CreateRequestController controller;

  const RequestFormLocationPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.latitude.value != null;
      final locationName = controller.locationName.value;

      return GestureDetector(
        onTap: controller.openMapPicker,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.colors.accent.withValues(alpha: 0.4)
                  : context.colors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.accent.withValues(alpha: 0.15)
                      : context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isSelected
                      ? Icons.location_on_rounded
                      : Icons.add_location_alt_rounded,
                  color: isSelected
                      ? context.colors.accent
                      : context.colors.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSelected
                          ? 'location_selected'.tr
                          : 'set_request_location'.tr,
                      style: TextStyle(
                        color: isSelected
                            ? context.colors.textPrimary
                            : context.colors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isSelected && locationName.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        locationName,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.edit_location_alt_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: isSelected
                    ? context.colors.accent
                    : context.colors.textDisabled,
                size: isSelected ? 22 : 16,
              ),
            ],
          ),
        ),
      );
    });
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
            backgroundColor: context.colors.accent,
            disabledBackgroundColor: context.colors.accent.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            elevation: 4,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: context.colors.textOnPrimary,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_rounded,
                      color: context.colors.textOnPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'submit_request'.tr,
                      style: TextStyle(
                        color: context.colors.textOnPrimary,
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
