import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../controller/consultation_controller.dart';

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
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _Tab(
              label: 'Ask AI',
              icon: Icons.smart_toy_outlined,
              isSelected: selected == 'ai',
              accentColor: Colors.purpleAccent,
              onTap: () => controller.selectType('ai'),
            ),
            _Tab(
              label: 'Ask Technician',
              icon: Icons.engineering_outlined,
              isSelected: selected == 'technician',
              accentColor: Colors.blueAccent,
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
                ? accentColor.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: accentColor.withOpacity(0.6))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? accentColor : AppColors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? accentColor : AppColors.grey,
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
