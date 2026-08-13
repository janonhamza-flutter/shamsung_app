import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../controller/consultation_controller.dart';

/// Returns [darkColor] unchanged in Dark Mode; in Light Mode returns
/// [lightColor], a deepened variant tuned for legibility on light surfaces.
/// Used to distinguish "AI" vs "technician" — a decorative pairing that
/// doesn't map onto the semantic palette fields.
Color _typeAccent(BuildContext context, bool isAi) {
  if (isAi) {
    return context.colors.isDark
        ? Colors.purpleAccent
        : const Color(0xFF7B1FA2);
  }
  return context.colors.isDark ? Colors.blueAccent : const Color(0xFF1565C0);
}

/// Toggle selector between AI and Technician consultation types.
class ConsultationTypeSelector extends StatelessWidget {
  const ConsultationTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsultationController>();

    return Obx(() {
      final selected = controller.selectedType.value;

      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _Tab(
              label: 'ask_ai'.tr,
              icon: Icons.smart_toy_outlined,
              isSelected: selected == 'ai',
              accentColor: _typeAccent(context, true),
              onTap: () => controller.selectType('ai'),
            ),
            _Tab(
              label: 'ask_technician'.tr,
              icon: Icons.engineering_outlined,
              isSelected: selected == 'technician',
              accentColor: _typeAccent(context, false),
              onTap: () => controller.selectType('technician'),
            ),
          ],
        ),
      );
    });
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: accentColor.withValues(alpha: 0.6))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? accentColor : context.colors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? accentColor : context.colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
