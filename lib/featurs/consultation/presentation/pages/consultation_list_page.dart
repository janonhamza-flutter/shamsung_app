import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../controller/consultation_controller.dart';
import '../widgets/consultation_card.dart';

class ConsultationListPage extends StatelessWidget {
  const ConsultationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsultationController>();

    return Scaffold(
      backgroundColor: context.colors.background,

      appBar: AppBar(
        backgroundColor: context.colors.surface,
        title: Text(
          'my_consultations'.tr,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.colors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: context.colors.textPrimary),
            onPressed: controller.fetchConsultations,
          ),
        ],
      ),

      // ── FAB — new consultation ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.createConsultation),
        backgroundColor: context.colors.accent,
        icon: Icon(Icons.add, color: context.colors.textOnPrimary),
        label: Text(
          'new_consultation_fab'.tr,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return LottieLoading(label: 'loading_consultations'.tr);
        }

        if (controller.consultations.isEmpty) {
          return _EmptyState(
            onTap: () => Get.toNamed(AppRoutes.createConsultation),
          );
        }

        return RefreshIndicator(
          color: context.colors.accent,
          backgroundColor: context.colors.surface,
          onRefresh: controller.fetchConsultations,
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(AppSizes.padding),
              itemCount: controller.consultations.length,
              itemBuilder: (_, index) {
                final c = controller.consultations[index];
                return ConsultationCard(consultation: c);
              },
            ),
          ),
        );
      }),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colors.accent.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 52,
              color: context.colors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'no_consultations_yet'.tr,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'no_consultations_hint'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.add, color: context.colors.textOnPrimary),
            label: Text(
              'start_consultation'.tr,
              style: TextStyle(
                color: context.colors.textOnPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
